#include <stdio.h>
#include <stdint.h>
#include "pim.h"
#include <stdlib.h>

void fill_matrix(int16_t* A, int16_t *B, uint32_t rowsA, uint32_t rowsB, uint32_t cols){
    for(int i = 0; i < rowsA; ++i){
        for(int j = 0; j < rowsB; ++j){
            A[i * rowsB + j] = i + 2;
        }
    }

    int16_t *iter = B, *bank_ptr;
    for(int i = 0; i < rowsB; i += 8){
        for(int j = 0; j < cols; j+= 128){
            for(int b = 0; b < 8; ++b){
                int16_t *bank_ptr = (int16_t*)(((uintptr_t)iter & ~(0xFULL << 10)) | ((2 * b + 1) << 10));
                for(int r = 0; r < 8; ++r){
                    for(int k = 0; k < 16; ++k){
                        bank_ptr[k] = ((i + r) == j + b * 16 + k);
                    }
                    bank_ptr = increment_iter(bank_ptr);
                }
            }
            for(int r = 0; r < 8; ++r) {
                iter = increment_iter(iter);
            }
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
    init_pim();
    
 
    uint32_t rows_A = atoi(argv[1]);
    uint32_t rows_B = atoi(argv[2]);
    uint32_t cols_B = atoi(argv[3]);

    int16_t *A, *B, *C;
    A = malloc(rows_A * rows_B * sizeof(int16_t));
    init_operand(&C);
    B = (uintptr_t)C + (1 << 10);
    fill_matrix(A, B, rows_A, rows_B, cols_B);
    matrix_multiplication(A, B, C, rows_A, rows_B, cols_B);    
    print(C, rows_A, cols_B);
    free(A);
    return 0;
}