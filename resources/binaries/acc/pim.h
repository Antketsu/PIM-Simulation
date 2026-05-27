#include <stdint.h>
#include <stdio.h>
#include <sys/mman.h>
#include <string.h>
#include <stdlib.h>
#include <gem5/m5ops.h>

#define ELEMS_PER_ROW 512
#define SIMD_WIDTH 16
#define CTL_INST(opcode, imm0, imm1) \
    (opcode << 28) | (imm0 << 11) | (imm1)  
#define DATA_INST(opcode, dst, src, relu, dst_idx, src_idx) \
    (opcode << 28) | (dst << 25) | (src << 22) | (relu << 12) | (dst_idx << 8) | (src_idx << 4) | (0)  
#define ALU_INST(opcode, dst, src0, src1, src2, dst_idx, src0_idx, src1_idx) \
    (opcode << 28) | (dst << 25) | (src0 << 22) | (src1 << 19) | (dst_idx << 8) | (src0_idx << 4) | (src1_idx)
    
#define BANK_ROW_FULL_MASK 0x3FF
#define BANK_ROW_INCREMENT (1 << 14)

typedef struct{
    int16_t *elems;
    uint32_t size;
} row_t;

typedef row_t* bank_t;

typedef struct{
    bank_t banks[8]; // Pointers to the start of the operand in each bank
    uint32_t rows;
    uint32_t cols;
    uint32_t bank_rows;
} pim_operand;

typedef struct{
    int16_t *elems;
    uint32_t rows;
    uint32_t cols;
} pim_operand_test;


int init_pim();
int init_operand(int16_t **op);
void add(int16_t* A, int16_t* B, int16_t* C, uint64_t elems);
int16_t* increment_iter(int16_t *iter);
int matrix_multiplication(int16_t* A, int16_t* B, int16_t* C, uint32_t A_rows, uint32_t B_rows, uint32_t B_cols);