#include <stdio.h>
#include <stdint.h>
#include "pim.h"
#include <stdlib.h>

int16_t* fill_matrix(int16_t* A, int16_t *B, uint64_t  elems){
    int16_t *iter = A;
    for(int i = 0; i < elems;){
        for(int b = 0; b < 8; ++b){
            int16_t *bank_ptrA = (int16_t*)(((uintptr_t)iter & ~(0xFULL << 10)) | ((2 * b) << 10));
            int16_t *bank_ptrB = (int16_t*)(((uintptr_t)iter & ~(0xFULL << 10)) | ((2 * b + 1) << 10));

            for(int k = 0; k < 16; ++k){
                bank_ptrA[k] = i;
                bank_ptrB[k] = i;
                ++i;
            }
        }
        iter = increment_iter(iter);
    }
    return iter;
}

/*int16_t* fill_matrix(int16_t* A, int16_t *B, uint64_t  elems){
    int16_t *iter = A;
    uint32_t n_rows = elems >> 13;
    for(int i = 0; i < n_rows;++i){
        for(int j = 0; j < 512; ++j){
            for(int b = 0; b < 8; ++b){
                int16_t *bank_ptrA = (int16_t*)(((uintptr_t)iter & ~(0xFULL << 10)) | ((2 * b) << 10));
                int16_t *bank_ptrB = (int16_t*)(((uintptr_t)iter & ~(0xFULL << 10)) | ((2 * b + 1) << 10));
    
                for(int k = 0; k < 16; ++k){
                    bank_ptrA[k] = i;
                    bank_ptrB[k] = i;
                    ++i;
                }
                iter = increment_iter(iter);
            }
            iter += 32;
        }
        iter = (uintptr_t)iter + BANK_ROW_INCREMENT;
        iter = (uintptr_t)iter & ~BANK_ROW_FULL_MASK;
    }
    return iter;
}*/

void print(int16_t *op, uint32_t rows, uint32_t cols){
    int16_t *iter = op;
    for(int i = 0; i < rows; ++i){
        for(int j = 0; j < cols;){
            for(int b = 0; b < 15; b += 2){
                int16_t *bank_ptr = ((uintptr_t)iter & ~(0xF << 10)) | (b << 10);
                for(int k = 0; k < 16; ++k){
                    printf("C[%d][%d] = %d\n", i, j, bank_ptr[k]);
                    ++j;
                }
            }
            iter = increment_iter(iter);
        }
    }
}


int main(int argc, char *argv[]) {
    init_pim();
    
 
    uint32_t rows = atoi(argv[1]);
    uint32_t cols = atoi(argv[2]);

    uint64_t elems = rows * cols;

    int16_t *A, *B, *C;
    init_operand(&A);
    B = (uintptr_t)A + (1 << 10);
    m5_exit(0);
    C = fill_matrix(A, B, elems);
    add(A, B, C, elems);    
    print(C, rows, cols);
    return 0;
}