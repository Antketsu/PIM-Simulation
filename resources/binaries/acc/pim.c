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

void write_add_block(uint8_t regs){
    for(int op_idx = 0; op_idx < regs; ++op_idx){
        //MOV GRF_A0, BAN0
        crf[instr_idx++] = DATA_INST(3, 1, 3, 0, op_idx, 0);
        //ADD GRF_B0, GRF_A0, BANK1
        crf[instr_idx++] = ALU_INST(4, 2, 1, 4, 0, op_idx, op_idx, 0);    
    }
    for(int op_idx = 0; op_idx < regs; ++op_idx){
        // MOV BANK0, GRF_B0
        crf[instr_idx++] = DATA_INST(3, 3, 2, 0, 0, op_idx);
    }
}

void add(int16_t* A, int16_t* B, int16_t* C, uint64_t elems){
    m5_work_begin(0,0);
    uint32_t elems_per_pu = elems / PUs;
    uint8_t regs = 8;
    uint16_t loops = elems_per_pu / (SIMD_WIDTH * regs);
    uint8_t loops_per_row = 4;
    uint8_t executions = loops / 256;
    executions += (loops % 256) ? 1 : 0;
    loops = (loops > 256) ? 256 : loops;
    
    write_add_block(regs);
    crf[instr_idx++] = CTL_INST(1, 3 * regs, loops - 1);
    crf[instr_idx++] = CTL_INST(2, 0 , 0);     
    
    *(uint8_t *)(pim_region + 4) = 1; 
    
    int16_t fake_variable; 
    

    volatile int16_t *iterA = (volatile int16_t * volatile)A, *iterB = (volatile int16_t * volatile)B, *iterC = (volatile int16_t * volatile)C;

    for(int e = 0; e < executions; ++e){
        pim_region[0] = 1; // Activate PIM mode
        asm volatile ("dmb ish\n\t"); // Absolute hardware barrier
        for(int i = 0; i < loops; i += loops_per_row){
            for(int j = 0; j < loops_per_row; ++j){
                for(int k = 0; k < regs; ++k){
                    fake_variable = *(iterA); //MOV
                    fake_variable = *(iterB); //ADD
                    iterA += 16; iterB += 16;
                }
                for(int k = 0; k < regs; ++k){
                    fake_variable = *(iterC); //MOV 
                    iterC += 16;
                }
                fake_variable = *(iterC); //JUMP 
            }

            //End of row
            iterA = (int16_t*)((uintptr_t)iterA + BANK_ROW_INCREMENT - 1024);
            iterB = (int16_t*)((uintptr_t)iterB + BANK_ROW_INCREMENT - 1024);
            iterC = (int16_t*)((uintptr_t)iterC + BANK_ROW_INCREMENT - 1024);
        }
        fake_variable = *(iterC); //EXIT
    }
    m5_work_end(0, 0);
}

void write_mul_block(uint8_t regs){
    //MOV GRFB, BANK0 
    crf[instr_idx++] = DATA_INST(3, 2, 3, 0, 0, 0);

    for(int op_idx = 0; op_idx < regs; ++op_idx){
        //MAC GRFB, BANK1, SRFM
        crf[instr_idx++] = ALU_INST(7, 2, 4, 5, 0, 0, 0, op_idx);
    }
    //MOV BANK0 GRFB
    crf[instr_idx++] = DATA_INST(3, 3, 2, 0, 0, 0);
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
    write_mul_block(regs);
    //JUMP 3, loops
    crf[instr_idx++] = CTL_INST(1, regs + 2, loops - 1);
    //EXIT
    crf[instr_idx++] = CTL_INST(2, 0, 0);

    uint32_t rowA_idx = 0, colA_idx = 0;
    *(uint8_t *)(pim_region + 4) = 1; 
    
    volatile int16_t* volatile B_iter = (volatile int16_t* volatile)B;
    volatile int16_t* volatile C_iter = (volatile int16_t* volatile)C;
    volatile int16_t *volatile C_current_row_begin = (volatile int16_t* volatile)C;

    while(rowA_idx * B_rows + colA_idx < A_rows * B_rows){
        if(colA_idx == B_rows){ 
            ++rowA_idx;
            colA_idx = 0;
            B_iter = (volatile int16_t* volatile)B;
            C_current_row_begin = C_iter; 
        }
        else{
            C_iter = C_current_row_begin;  
        }

        for(int i = 0; i < regs; ++i){
            for(int j = 0; j < PUs; ++j){
                pu_space[j * PU_SIZE + i] = A[rowA_idx * B_rows + colA_idx];
            }
            ++colA_idx;
        }

        int16_t fake_variable;

        pim_region[0] = 1; // Activa modo PIM


        for (int colB_idx = 0; colB_idx < loops; ++colB_idx) {
            
            asm volatile ("dmb ish\n\t"); // Barrera de hardware absoluta

            fake_variable = *(C_iter); // MOV
            for(int i = 0; i < regs; ++i){
                fake_variable = *(B_iter); // MAC
                B_iter += 16; 
            }

            fake_variable = *(C_iter); // MOV

            C_iter += 16;    
            (void)*B_iter;  // Trigger JUMP

            if (((uintptr_t)B_iter & BANK_ROW_FULL_MASK) == 0) {
                B_iter = (volatile int16_t*)((uintptr_t)B_iter + BANK_ROW_INCREMENT - 1024);
            }
            
            if (((uintptr_t)C_iter & BANK_ROW_FULL_MASK) == 0) {
                C_iter = (volatile int16_t*)((uintptr_t)C_iter + BANK_ROW_INCREMENT - 1024);
            }
        }
        
        (void)*C_iter; // Trigger EXIT
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
