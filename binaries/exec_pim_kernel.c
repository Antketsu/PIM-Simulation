#include <stdio.h>
#include <stdint.h>
#include "pim.h"
#include <stdlib.h>


void fill_matrixs_add(pim_operand* A, pim_operand* B){
    uint32_t col_idx = 0, row_idx = 0;
    for(int i = 0; i < get_processing_units(); ++i){
        for (int j = 0; j < A->bank_rows; j++) {
            for(int k = 0; k < A->banks[i][j].size; ++k){
                A->banks[i][j].elems[k] = row_idx;
                ++col_idx;
                if(col_idx == A->cols){
                    col_idx = 0;
                    ++row_idx;
                }
            }
        }
    }
    col_idx = 0; row_idx = 0;
    for(int i = 0; i < get_processing_units(); ++i){
        for (int j = 0; j < B->bank_rows; j++) {
            for(int k = 0; k < B->banks[i][j].size; ++k){
                if(row_idx == col_idx){
                    B->banks[i][j].elems[k] = 1;
                }
                else{
                    B->banks[i][j].elems[k] = 0;
                }
                ++col_idx;
                if(col_idx == B->cols){
                    col_idx = 0;
                    ++row_idx;
                }
            }
        }
    }
}

void print_add_result(pim_operand* C){
    uint32_t col_idx = 0, row_idx = 0;
    for(int i = 0; i < get_processing_units(); ++i){
        for (int j = 0; j < C->bank_rows; j++) {
            for(int k = 0; k < C->banks[i][j].size; ++k){
                printf("C[%d][%d] = %d\n", row_idx, col_idx, C->banks[i][j].elems[k]);
                ++col_idx;
                if(col_idx == C->cols){
                    col_idx = 0;
                    ++row_idx;
                }
            }
        }
    }
}

void fill_matrixs_mul(pim_operand* A, pim_operand* B){
    int row_idx = 0, elem_idx = 0;
    for(int i = 0; i < A->rows; ++i){
        for(int j = 0; j < A->cols;){
            for(int k = 0; k < get_processing_units(); ++k){
                for(int e = 0; e < SIMD_WIDTH; ++e) {
                    A->banks[k][row_idx].elems[elem_idx + e] = i;
                    ++j;
                }
            }
            elem_idx += SIMD_WIDTH;
            if(elem_idx == A->banks[0][row_idx].size){
                    elem_idx = 0;
                    ++row_idx;
            }
        }
    }

    row_idx = 0; elem_idx = 0;
    for(int i = 0; i < B->rows; ++i){
        for(int j = 0; j < B->cols;){
            for(int k = 0; k < get_processing_units(); ++k){
                for(int e = 0; e < SIMD_WIDTH; ++e){
                    if(i == j){
                        B->banks[k][row_idx].elems[elem_idx + e] = 1;
                    }
                    else{
                        B->banks[k][row_idx].elems[elem_idx + e] = 0;
                    }
                    ++j;
                }
            }
            elem_idx += SIMD_WIDTH;
            if(elem_idx == B->banks[0][row_idx].size){
                elem_idx = 0;
                ++row_idx;
            }
        }
    }
}

void print_mul_result(pim_operand* C){
    int row_idx = 0, elem_idx = 0;
    for(int i = 0; i < C->rows; ++i){
        for(int j = 0; j < C->cols;){
            for(int k = 0; k < get_processing_units(); ++k){
                for(int e = 0; e < SIMD_WIDTH; ++e){
                    printf("C[%d][%d] = %d\n", i, j, C->banks[k][row_idx].elems[elem_idx + e]);
                    ++j;
                }
            }
            elem_idx += SIMD_WIDTH;
            if(elem_idx == C->banks[0][row_idx].size){
                elem_idx = 0;
                ++row_idx;
            }
        }
    }
}

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


    if(kernel == 0){
        fill_matrixs_add(&A, &B);
        if(add(A, B, C)){
            printf("Add error\n");
            exit(1);
        }
        print_add_result(&A);
        print_add_result(&B);
        print_add_result(&C);
    }
    else if(kernel == 1){
        fill_matrixs_mul(&A, &B);
        if(matrix_multiplication(A, B, C)){
            printf("Matrix multiplication error\n");
            exit(1);
        }
        print_mul_result(&C);
    }
    else{
        fprintf(stderr, "Invalid kernel. Use 0 for add and 1 for matrix multiplication.\n");
        return 1;
    }
    return 0;
}