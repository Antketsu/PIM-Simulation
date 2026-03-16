#include "pim.h"

uint8_t *pim_region;
uint32_t *crf;
int16_t *srf_m;
uint8_t instr_idx = 0;

size_t pim_size = 0x1000000;  // 16 MB

uint64_t next_addr = 0x20000000;

uint8_t processing_units = 1;



#define ROW_INCREMENT 0x00002000

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
            printf("Mapping bank %d, row %d at virtual address 0x%lx with size %d bytes\n", i, j, ptr, op->banks[i][j].size * 2);
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
    idx = idx * SIMD_WIDTH;
    uint32_t elems = op->rows * op->cols;
    uint32_t elems_per_bank = elems / processing_units;
    uint32_t row_idx = idx / ELEMS_PER_ROW;
    printf("Reading from bank %d, row %d, element %d\n", 0, row_idx, idx);
    return op->banks[0][row_idx].elems[idx % ELEMS_PER_ROW];
}

void write_operand(pim_operand* op, int idx, int16_t value){
    idx = idx * SIMD_WIDTH;
    uint32_t elems = op->rows * op->cols;
    uint32_t elems_per_bank = elems / processing_units;
    uint32_t row_idx = idx / ELEMS_PER_ROW;
    printf("Writing to bank %d, row %d, element %d\n", 0, row_idx, idx);
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
    uint8_t loops = elems_per_pu / (SIMD_WIDTH * regs);
    printf("Loops:%d\n", loops); 
    printf("Regs:%d\n", regs);
    printf("Processing Units:%d\n", processing_units);
    printf("Elems:%lu\n", elems);
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
            printf("Loop %d, Reg %d\n", i, j);
            dummy1 = read_operand(&A, i * regs + j); // Read to A's address to trigger the MOV instruction
            dummy2 = read_operand(&B, i * regs + j); // Read to B's address to trigger the ADD instruction
            write_operand(&C, i * regs + j, 0); // Write to C's address to trigger the MOV instruction to write back the result
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



/*
int matrix_multiplication(pim_operand A, pim_operand B, pim_operand C){
    if(A.cols != B.rows || C.rows != A.rows || C.cols != B.cols)
        return 1;
    uint8_t loops = B.cols / SIMD_WIDTH;
    //MOV GRFB, BANK0 
    crf[instr_idx++] = DATA_INST(3, 2, 3, 0, 0, 0);
    //MAC GRFB, BANK1, SRFM
    crf[instr_idx++] = ALU_INST(7, 2, 3, 4, 0, 0, 0, 0);
    //MOV BANK0 GRFB
    crf[instr_idx++] = DATA_INST(3, 3, 2, 0, 0, 0);
    //JUMP 3, loops
    crf[instr_idx++] = CTL_INST(1, 3, loops - 1);
    //EXIT
    crf[instr_idx++] = CTL_INST(2, 0, 0);

    int16_t dummy;
    for(int k = 0; k < A.rows; ++k){
        for(int i = 0; i < A.cols; ++i){
            srf_m[0] = A.vector[k * A.cols + i];
            pim_region[0] = 1; // Writing to this address activates PIM mode
            int j = 0;        
            do{
                dummy = C.vector[k * C.cols + j * SIMD_WIDTH]; // Read to C's address
                dummy = B.vector[i * B.cols + j * SIMD_WIDTH]; //Read from B
                C.vector[k * C.cols + j * SIMD_WIDTH] = 0; //Write to C
                A.vector[0] = 0; // JUMP
                ++j;
            }while(j < loops);
            A.vector[0] = 0; //EXIT
        }
    }

    return 0;
}
*/

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
    srf_m = (int16_t *)(crf + 32);
    return 0;
}
