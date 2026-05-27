#include "pim.h"
#include <stdatomic.h>
uint8_t *pim_region;
uint32_t *crf;
int16_t *pu_space;
uint8_t instr_idx = 0;

size_t pim_size = 0x1000000;  // 16 MB

uint64_t next_addr = 0x20000000;


#define ROW_INCREMENT 0x00002000

#define SRF_ETNRIES 16

#define GRF_ENTRIES 16

#define PU_SIZE (SRF_ETNRIES + GRF_ENTRIES * 16)// How many elements of 16 bits

#define PUs 8

int init_operand(int16_t **op){ 
    uint32_t ptr = next_addr;

    *op = mmap(
                (void *)ptr,  
                0xFFFFFFF,
                PROT_READ | PROT_WRITE,
                MAP_PRIVATE | MAP_ANONYMOUS | MAP_FIXED,
                -1,
                0
            );
    if (*op == MAP_FAILED) {
        perror("Mapping error \n");
        return 1;
    }

    return 0;
}

/*

uint16_t read_operand(pim_operand* op, int idx){
    uint32_t elems = op->rows * op->cols;
    uint32_t elems_per_bank = elems / PUs;
    uint32_t row_idx = idx / ELEMS_PER_ROW;
    return op->banks[0][row_idx].elems[idx % ELEMS_PER_ROW];
}

void write_operand(pim_operand* op, int idx, int16_t value){
    uint32_t elems = op->rows * op->cols;
    uint32_t elems_per_bank = elems / PUs;
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

    uint32_t elems_per_pu = elems / PUs;
    uint8_t regs = 8;
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
    if(PUs > 1){
        // ACTIVATE ALL BANKS MODE
        *(uint8_t *)(pim_region + 4) = 1; // Writing to this address activates the mode for all banks  
    }
    
    int16_t dummy1, dummy2; //For fake memory access
    uint8_t executions = loops / 256;
    executions += (loops % 256) ? 1 : 0;
    printf("Loops: %d, Executions: %d\n", loops, executions);
    loops = (loops > 256) ? 256 : loops;
    printf("Loops after adjustment: %d\n", loops);
    for(int e = 0; e < executions; ++e){
        // ACTIVATE PIM MODE
        pim_region[0] = 1; // Writing to this address activates PIM mode
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
    }
    if(PUs > 1){
        // DEACTIVATE ALL BANKS MODE
        *(uint8_t *)(pim_region + 4) = 0; // Writing to this address deactivates the mode for all banks  
    }
    m5_work_end(0, 0);
    return 0;
}

*/

void write_add_block(uint8_t op_idx){
    //MOV GRF_A0, BAN0
    crf[instr_idx++] = DATA_INST(3, 1, 3, 0, op_idx, 0);
    //ADD GRF_B0, GRF_A0, BANK1
    crf[instr_idx++] = ALU_INST(4, 2, 1, 4, 0, op_idx, op_idx, 0);
    // MOV BANK0, GRF_B0
    crf[instr_idx++] = DATA_INST(3, 3, 2, 0, 0, op_idx);
}

void add(int16_t* A, int16_t* B, int16_t* C, uint64_t elems){
    m5_work_begin(0,0);
    uint32_t elems_per_pu = elems / PUs;
    uint8_t regs = 8;
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
    *(uint8_t *)(pim_region + 4) = 1; // Writing to this address activates the mode for all banks  
    
    int16_t dummy; //For fake memory access
    uint8_t executions = loops / 256;
    executions += (loops % 256) ? 1 : 0;
    printf("Loops: %d, Executions: %d\n", loops, executions);
    loops = (loops > 256) ? 256 : loops;
    printf("Loops after adjustment: %d\n", loops);
    int16_t *iterA = A, *iterB = B, *iterC = C;
    uint32_t n_rows = elems >> 13;
    for(int e = 0; e < executions; ++e){
        // ACTIVATE PIM MODE
        pim_region[0] = 1; // Writing to this address activates PIM mode
        for(int i = 0; i < loops; ++i){
            for(int j = 0; j < regs; ++j){
                dummy = *(iterA); // Read to A's address to trigger the MOV instruction
                dummy = *(iterB); // Read to B's address to trigger the ADD instruction
                *(iterC) = dummy; // Write to C's address to trigger the MOV instruction to write back the result
                iterA = increment_iter(iterA);
                iterB = increment_iter(iterB);
                iterC = increment_iter(iterC);
            }
            if(loops > 1)
                dummy = *(iterC); // Some memory access to trigger the execution of JUMP
        }
        dummy = *(iterC); // Some memory access to trigger the execution of EXIT
    }
    m5_work_end(0, 0);
}

void write_mul_block(uint8_t op_idx){
    //MOV GRFB, BANK0 
    crf[instr_idx++] = DATA_INST(3, 2, 3, 0, op_idx, 0);
    //MAC GRFB, BANK1, SRFM
    crf[instr_idx++] = ALU_INST(7, 2, 4, 5, 0, op_idx, 0, op_idx);
    //MOV BANK0 GRFB
    crf[instr_idx++] = DATA_INST(3, 3, 2, 0, 0, op_idx);
}

int16_t* increment_iter(int16_t *iter){
    if (((uintptr_t)iter & BANK_ROW_FULL_MASK) + 32 > BANK_ROW_FULL_MASK) {
        iter = (uintptr_t)iter + BANK_ROW_INCREMENT;
        iter = (uintptr_t)iter & ~BANK_ROW_FULL_MASK;
    }
    else{
        iter = (uintptr_t)iter + 32;
    }
    return iter;
}

int matrix_multiplication(int16_t* A, int16_t* B, int16_t* C, uint32_t A_rows, uint32_t B_rows, uint32_t B_cols){
    m5_work_begin(0, 0);
    uint16_t loops = B_cols / (SIMD_WIDTH * PUs);
    uint8_t regs = 8;
    for(int i = 0; i < regs; ++i){
        write_mul_block(i);
    }
    //JUMP 3, loops
    crf[instr_idx++] = CTL_INST(1, 3 * regs, loops - 1);
    //EXIT
    crf[instr_idx++] = CTL_INST(2, 0, 0);

    uint32_t rowA_idx = 0, colA_idx = 0;
    *(uint8_t *)(pim_region + 4) = 1; 
    int16_t *B_iter = B, *C_iter = C, *C_current_row_begin = C;
    int16_t dummy;
    while(rowA_idx * B_rows + colA_idx < A_rows * B_rows){
        if(colA_idx == B_rows){ //This could have happend in previous iter
            ++rowA_idx;
            colA_idx = 0;
            B_iter = B;
            C_current_row_begin = C_iter; //Mantain the C increment in previous loop and update the row begin checkpoint
        }
        else{
            C_iter = C_current_row_begin;  //Back to row begin
        }
        for(int i = 0; i < regs; ++i){
            for(int j = 0; j < PUs; ++j){
                pu_space[j * PU_SIZE + i] = A[rowA_idx * B_rows + colA_idx];
            }
            ++colA_idx;
        }
        pim_region[0] = 1; // Writing to this address activates PIM mode
        int colB_idx = 0;        
        do{
            for(int i = 0; i < regs; ++i){
                __sync_synchronize();
                dummy = *(C_iter); // Read to C's address
                dummy = *(B_iter); // Read to B's address to trigger the MAC instruction 
                *(C_iter) = dummy; // Write to C's address
                B_iter = increment_iter(B_iter);
            }
            C_iter = increment_iter(C_iter);
            dummy = *(C_iter); // Some memory access to trigger the execution of JUMP
            ++colB_idx;
        }while(colB_idx < loops);
        dummy = *(C_iter); // Some memory access to trigger the execution of EXIT
    }
    m5_work_end(0, 0);
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
