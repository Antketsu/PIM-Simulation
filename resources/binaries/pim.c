#include "pim.h"
#include <stdatomic.h>
uint8_t *pim_region;
uint32_t *crf;
int16_t *pu_space;
uint8_t instr_idx = 0;

size_t pim_size = 0x1000000;  // 16 MB

uint64_t next_addr = 0x20000000;

uint8_t processing_units = 1;



#define ROW_INCREMENT 0x00002000

#define SRF_ETNRIES 16

#define GRF_ENTRIES 16

#define PU_SIZE (SRF_ETNRIES + GRF_ENTRIES * 16)// How many elements of 16 bits

void set_processing_units(uint8_t units){
    processing_units = units;
}

uint8_t get_processing_units(){
    return processing_units;
}

int init_operand(pim_operand *op, uint32_t rows, uint32_t cols){ 
    op->rows = rows;
    op->cols = cols;
    uint32_t elems = rows * cols;
    uint32_t elems_per_bank = elems / processing_units;
    op->bank_rows = elems_per_bank / ELEMS_PER_ROW;
    op->bank_rows = (elems_per_bank % ELEMS_PER_ROW) ? op->bank_rows + 1 : op->bank_rows; // Round up if there are remaining elements
    uint32_t ptr = next_addr;
    for(int i = 0; i < processing_units; ++i){
        op->banks[i] = malloc(sizeof(row_t) * op->bank_rows);
        for(int j = 0; j < op->bank_rows; ++j){
            if(j == op->bank_rows - 1 && elems_per_bank % ELEMS_PER_ROW){ // If it's the last row and there are remaining elements, adjust the row size
                op->banks[i][j].size = elems_per_bank % ELEMS_PER_ROW;
            }
            else{
                op->banks[i][j].size = ELEMS_PER_ROW;
            }
            op->banks[i][j].elems = mmap(
                (void *)ptr,  
                ELEMS_PER_ROW * 2, // 16 bits per element
                PROT_READ | PROT_WRITE,
                MAP_PRIVATE | MAP_ANONYMOUS | MAP_FIXED,
                -1,
                0
            );
            if (op->banks[i][j].elems == MAP_FAILED) {
                printf("Intentando mapear al banco %d\n", i + 1);
                perror("Error al mapear la memoria del banco");
                return 1;
            }
            ptr += ROW_INCREMENT;
        }
    }
    next_addr = ptr;
    return 0;
}

uint16_t read_operand(pim_operand* op, int idx){
    uint32_t elems = op->rows * op->cols;
    uint32_t elems_per_bank = elems / processing_units;
    uint32_t row_idx = idx / ELEMS_PER_ROW;
    return op->banks[0][row_idx].elems[idx % ELEMS_PER_ROW];
}

void write_operand(pim_operand* op, int idx, int16_t value){
    uint32_t elems = op->rows * op->cols;
    uint32_t elems_per_bank = elems / processing_units;
    uint32_t row_idx = idx / ELEMS_PER_ROW;
    op->banks[0][row_idx].elems[idx % ELEMS_PER_ROW] = value;
}

void write_add_block(uint8_t op_idx){
    //MOV GRF_A0, BAN0
    crf[instr_idx++] = DATA_INST(3, 1, 3, 0, op_idx, 0);
    //ADD GRF_B0, GRF_A0, BANK1
    crf[instr_idx++] = ALU_INST(4, 2, 1, 4, 0, op_idx, op_idx, 0);
    // MOV BANK0, GRF_B0
    crf[instr_idx++] = DATA_INST(3, 3, 2, 0, 0, op_idx);
}


int add(pim_operand A, pim_operand B, pim_operand C){
    m5_work_begin(0, 0);
    uint64_t elems = A.rows * A.cols;
    if(elems != B.rows * B.cols || elems != C.rows * C.cols)
        return 1;

    int16_t *v1 = A.banks[0][0].elems; 
    int16_t *v2 = B.banks[0][0].elems;
    int16_t *v3 = C.banks[0][0].elems;

    uint32_t elems_per_pu = elems / processing_units;
    uint8_t regs = 8;
    while(elems_per_pu % regs){
        --regs;
    }
    uint16_t loops = elems_per_pu / (SIMD_WIDTH * regs);
    for(int i = 0; i < regs; ++i){
        write_add_block(i);
    }
    if(loops > 1){
        // JUMP 3, loops
        crf[instr_idx++] = CTL_INST(1, 3 * regs, loops - 1);
    }
    // EXIT
    crf[instr_idx++] = CTL_INST(2, 0 , 0);     
    if(processing_units > 1){
        // ACTIVATE ALL BANKS MODE
        *(uint8_t *)(pim_region + 4) = 1; // Writing to this address activates the mode for all banks  
    }
    // ACTIVATE PIM MODE
    pim_region[0] = 1; // Writing to this address activates PIM mode
    
    int16_t dummy1, dummy2; //For fake memory access
    for(int i = 0; i < loops; ++i){
        for(int j = 0; j < regs; ++j){
            dummy1 = read_operand(&A, (i * regs + j) * SIMD_WIDTH); // Read to A's address to trigger the MOV instruction
            dummy2 = read_operand(&B, (i * regs + j) * SIMD_WIDTH); // Read to B's address to trigger the ADD instruction
            write_operand(&C, (i * regs + j) * SIMD_WIDTH, 0); // Write to C's address to trigger the MOV instruction to write back the result
        }
        if(loops > 1)
            write_operand(&C, 0, 0); // Some memory access to trigger the execution of JUMP
    }
    write_operand(&C, 0, 0); // Some memory access to trigger the execution of EXIT
    if(processing_units > 1){
        // DEACTIVATE ALL BANKS MODE
        *(uint8_t *)(pim_region + 4) = 0; // Writing to this address deactivates the mode for all banks  
    }
    m5_work_end(0, 0);
    return 0;
}

void write_mul_block(uint8_t op_idx){
    //MOV GRFB, BANK0 
    crf[instr_idx++] = DATA_INST(3, 2, 3, 0, op_idx, 0);
    //MAC GRFB, BANK1, SRFM
    crf[instr_idx++] = ALU_INST(7, 2, 4, 5, 0, op_idx, 0, op_idx);
    //MOV BANK0 GRFB
    crf[instr_idx++] = DATA_INST(3, 3, 2, 0, 0, op_idx);
}

uint16_t read_mul_operand(pim_operand* op, int idx){
    uint32_t chunk = idx / SIMD_WIDTH;
    uint32_t bank_idx = chunk % get_processing_units();
    uint32_t chunk_number_in_bank = chunk / get_processing_units();
    uint32_t idx_in_chunk = idx % SIMD_WIDTH;
    uint32_t linear_idx_in_bank = chunk_number_in_bank * SIMD_WIDTH + idx_in_chunk;
    uint32_t row_idx = linear_idx_in_bank / ELEMS_PER_ROW;
    uint32_t elem_offset = linear_idx_in_bank % ELEMS_PER_ROW;
    return op->banks[bank_idx][row_idx].elems[elem_offset];
}

void write_mul_operand(pim_operand* op, int idx, int16_t value){
    uint32_t chunk = idx / SIMD_WIDTH;
    uint32_t bank_idx = chunk % get_processing_units();
    uint32_t chunk_number_in_bank = chunk / get_processing_units();
    uint32_t idx_in_chunk = idx % SIMD_WIDTH;
    uint32_t linear_idx_in_bank = chunk_number_in_bank * SIMD_WIDTH + idx_in_chunk;
    uint32_t row_idx = linear_idx_in_bank / ELEMS_PER_ROW;
    uint32_t elem_offset = linear_idx_in_bank % ELEMS_PER_ROW;
    op->banks[bank_idx][row_idx].elems[elem_offset] = value;
}

typedef struct{
    uint32_t row;
    uint32_t col;
} idx_t;

int matrix_multiplication(pim_operand A, pim_operand B, pim_operand C){
    if(A.cols != B.rows || C.rows != A.rows || C.cols != B.cols)
        return 1;
    uint16_t loops = B.cols / (SIMD_WIDTH * processing_units);
    uint8_t regs = 8;
    for(int i = 0; i < regs; ++i){
        write_mul_block(i);
    }
    //JUMP 3, loops
    crf[instr_idx++] = CTL_INST(1, 3 * regs, loops - 1);
    //EXIT
    crf[instr_idx++] = CTL_INST(2, 0, 0);

    int16_t dummy;
    uint32_t rowA_idx = 0, colA_idx = 0;
    idx_t A_idx_per_reg[regs];
    if(processing_units > 1){
        // ACTIVATE ALL BANKS MODE
        *(uint8_t *)(pim_region + 4) = 1; // Writing to this address activates the mode for all banks  
    }
    while(rowA_idx * A.cols + colA_idx < A.rows * A.cols){
            for(int i = 0; i < regs; ++i){
                for(int j = 0; j < processing_units; ++j){
                    pu_space[j * PU_SIZE + i] = read_mul_operand(&A, rowA_idx * A.cols + colA_idx);
                }
                A_idx_per_reg[i].row = rowA_idx;
                A_idx_per_reg[i].col = colA_idx;
                ++colA_idx;
                if(colA_idx == A.cols){
                    colA_idx = 0;
                    ++rowA_idx;
                }
            }
            pim_region[0] = 1; // Writing to this address activates PIM mode
            atomic_thread_fence(memory_order_seq_cst);
            int colB_idx = 0;        
            do{
                for(int i = 0; i < regs; ++i){
                    uint32_t current_rowA_idx = A_idx_per_reg[i].row;
                    uint32_t current_colA_idx = A_idx_per_reg[i].col;
                    //printf("Current row of A: %d, current col of A: %d, current col of B: %d\n", current_rowA_idx, current_colA_idx, colB_idx);
                    dummy = read_mul_operand(&C, current_rowA_idx * C.cols + colB_idx * SIMD_WIDTH * processing_units); // Read to C's address
                    dummy = read_mul_operand(&B, current_colA_idx * B.cols + colB_idx * SIMD_WIDTH * processing_units); // Read to B's address to trigger the MAC instruction
                    write_mul_operand(&C, current_rowA_idx * C.cols + colB_idx * SIMD_WIDTH * processing_units, 0); // Write to C's address
                }
                read_mul_operand(&C, 0); // Some memory access to trigger the execution of JUMP
                ++colB_idx;
            }while(colB_idx < loops);
            read_mul_operand(&C, 0); // Some memory access to trigger the execution of EXIT
        }
    return 0;
}


int init_pim(){
    pim_region = mmap(
        (void *)0x10000000,  
        pim_size,
        PROT_READ | PROT_WRITE,
        MAP_PRIVATE | MAP_ANONYMOUS | MAP_FIXED,
        -1,
        0
    );

    if (pim_region == MAP_FAILED) {
        perror("Error al mapear la región PIM");
        return 1;
    }
    crf = (uint32_t *)(pim_region + 8); 
    pu_space = (int16_t *)(crf + 32);
    return 0;
}
