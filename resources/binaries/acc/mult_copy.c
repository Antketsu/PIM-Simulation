#include <stdio.h>
#include <stdint.h>
#include "pim.h"
#include <stdlib.h>

/* Initialize A and a conventional row-major B[rowsB][cols] matrix. */
static void fill_regular_matrices(int16_t *A, int16_t *B,
                                  uint32_t rowsA, uint32_t rowsB,
                                  uint32_t cols){
    for(int i = 0; i < rowsA; ++i){
        for(int j = 0; j < rowsB; ++j){
            A[i * rowsB + j] = (i + j) % 32768;
        }
    }

    for (uint32_t i = 0; i < rowsB; ++i) {
        for (uint32_t j = 0; j < cols; ++j) {
            B[(size_t)i * cols + j] = (i == j);
        }
    }
}

/* Copy row-major B into the bank layout expected by the PIM kernel. */
static void convert_to_pim_layout(const int16_t *src, int16_t *dst,
                                  uint32_t rows, uint32_t cols){
    int16_t *iter = dst;

    for (uint32_t i = 0; i < rows; i += 8) {
        for (uint32_t j = 0; j < cols; j += 128) {
            for (uint32_t b = 0; b < 8; ++b) {
                int16_t *bank_ptr = (int16_t *)
                    (((uintptr_t)iter & ~(0xFULL << 10)) |
                     ((2 * b + 1) << 10));

                for (uint32_t r = 0; r < 8; ++r) {
                    for (uint32_t k = 0; k < 16; ++k) {
                        bank_ptr[k] = src[(size_t)(i + r) * cols +
                                          j + b * 16 + k];
                    }
                    bank_ptr = increment_iter(bank_ptr);
                }
            }
            for (uint32_t r = 0; r < 8; ++r)
                iter = increment_iter(iter);
        }
    }
}

void print(int16_t *op, uint32_t rows, uint32_t cols){
    int16_t *iter = op;
    for(int i = 0; i < rows; ++i){
        for(int j = 0; j < cols;){
            for(int b = 0; b < 15; b += 2){
                iter = ((uintptr_t)iter & ~(0xF << 10)) | (b << 10);
                for(int k = 0; k < 16; ++k){
                    printf("C[%d][%d] = %d\n", i, j, iter[k]);
                    ++j;
                }
            }
            iter = increment_iter(iter);
        }
    }
}


int main(int argc, char *argv[]) {
    if (argc < 4) {
        fprintf(stderr, "Usage: %s rows_A rows_B cols_B [print_result]\n", argv[0]);
        return 1;
    }

    uint32_t rows_A = atoi(argv[1]);
    uint32_t rows_B = atoi(argv[2]);
    uint32_t cols_B = atoi(argv[3]);
    uint8_t print_result = argc > 4 ? atoi(argv[4]) : 1;

    if (rows_B % 8 != 0 || cols_B % 128 != 0) {
        fprintf(stderr, "rows_B must be divisible by 8 and cols_B by 128\n");
        return 1;
    }

    if (init_pim() != 0) return 1;

    int16_t *A, *B_regular, *B, *C;
    A = malloc((size_t)rows_A * rows_B * sizeof(int16_t));
    B_regular = malloc((size_t)rows_B * cols_B * sizeof(int16_t));
    if (A == NULL || B_regular == NULL) {
        fprintf(stderr, "matrix allocation failed\n");
        free(A);
        free(B_regular);
        return 1;
    }
    if (init_operand(&C) != 0) {
        free(A);
        free(B_regular);
        return 1;
    }
    B = (uintptr_t)C + (1 << 10);
    fill_regular_matrices(A, B_regular, rows_A, rows_B, cols_B);
    m5_exit(0);
    /* Measure the regular-to-PIM layout copy as its own work region. */
    m5_work_begin(0, 0);
    convert_to_pim_layout(B_regular, B, rows_B, cols_B);
    matrix_multiplication(A, B, C, rows_A, rows_B, cols_B); 
    m5_work_end(0, 0);
    if(!print_result){
        m5_exit(0);
    }   
    print(C, rows_A, cols_B);
    free(A);
    free(B_regular);
    return 0;
}
