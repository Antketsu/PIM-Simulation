#include <stdio.h>
#include <stdint.h>
#include "pim.h"
#include <stdlib.h>
int main(int argc, char *argv[]) {
    init_pim();
    pim_operand A, B, C;
    if(argc < 3){
        fprintf(stderr, "Usage: %s <rows> <cols>\n", argv[0]);
        return 1;
    }
    uint32_t rows_A = atoi(argv[1]);
    uint32_t cols_A = atoi(argv[2]);
    uint32_t rows_B = atoi(argv[3]);
    uint32_t cols_B = atoi(argv[4]);
    uint32_t rows_C = atoi(argv[5]);
    uint32_t cols_C = atoi(argv[6]);
    uint8_t kernel = atoi(argv[7]);
    uint8_t processing_units = atoi(argv[8]);

    set_processing_units(processing_units);    

    init_operand(&A, rows_A, cols_A);
    init_operand(&B, rows_B, cols_B);
    init_operand(&C, rows_C, cols_C);
    m5_exit(0);

    uint32_t col_idx = 0, row_idx = 0;
    for(int i = 0; i < get_processing_units(); ++i){
        for (int j = 0; j < A.bank_rows; j++) {
            for(int k = 0; k < A.banks[i][j].size; ++k){
                A.banks[i][j].elems[k] = row_idx;
                ++col_idx;
                if(col_idx == cols_A){
                    col_idx = 0;
                    ++row_idx;
                }
            }
        }
        col_idx = 0; row_idx = 0;
        for (int j = 0; j < B.bank_rows; j++) {
            for(int k = 0; k < B.banks[i][j].size; ++k){
                if(row_idx == col_idx){
                    B.banks[i][j].elems[k] = 1;
                }
                else{
                    B.banks[i][j].elems[k] = 0;
                }
                ++col_idx;
                if(col_idx == cols_B){
                    col_idx = 0;
                    ++row_idx;
                }
            }
        }
    }

    if(kernel == 0){
        if(add(A, B, C)){
            printf("Add error\n");
            exit(1);
        }
    }
    else if(kernel == 1){
        if(matrix_multiplication(A, B, C)){
            printf("Matrix multiplication error\n");
            exit(1);
        }
    }
        
    col_idx = 0; row_idx = 0;
    for(int i = 0; i < get_processing_units(); i++) {
        for(int j = 0; j < C.bank_rows; ++j){
            for(int k = 0; k < C.banks[i][j].size; ++k){
                printf("C[%d][%d] = %d\n", row_idx, col_idx, C.banks[i][j].elems[k]);
                ++col_idx;
                if(col_idx == cols_C){
                    col_idx = 0;
                    ++row_idx;
                }
            }
        }
    }


}