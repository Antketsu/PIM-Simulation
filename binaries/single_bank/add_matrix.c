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
    uint32_t rows = atoi(argv[1]);
    uint32_t cols = atoi(argv[2]);

    set_processing_units(1);    

    init_operand(&A, rows, cols);
    init_operand(&B, rows, cols);
    init_operand(&C, rows, cols);
    m5_exit(0);

    uint32_t elements = rows * cols;
    uint32_t elems_per_bank = elements / get_processing_units();


    uint8_t col_idx = 0, row_idx = 0;
    for(int i = 0; i < get_processing_units(); ++i){
        for (int j = 0; j < A.bank_rows; j++) {
            for(int k = 0; k < A.banks[i][j].size; ++k){
                A.banks[i][j].elems[k] = col_idx + row_idx;
                B.banks[i][j].elems[k] = 2 * (row_idx + col_idx);
                ++col_idx;
                if(col_idx == cols){
                    col_idx = 0;
                    ++row_idx;
                }
            }
        }
    }

    
    if(add(A, B, C)){
        printf("Add error\n");
        exit(1);
    }
        
    
    printf("Resultado de la suma matricial:\n");
    col_idx = 0; row_idx = 0;
    for(int i = 0; i < get_processing_units(); i++) {
        for(int j = 0; j < C.bank_rows; ++j){
            for(int k = 0; k < C.banks[i][j].size; ++k){
                printf("C[%d][%d] = %d\n", row_idx, col_idx, C.banks[i][j].elems[k]);
                ++col_idx;
                if(col_idx == cols){
                    col_idx = 0;
                    ++row_idx;
                }
            }
        }
    }


}