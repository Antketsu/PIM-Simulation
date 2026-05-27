#include <stdio.h>
#include <stdint.h>
#include <gem5/m5ops.h>
#include <stdlib.h>

void add(int16_t* A, int16_t* B, int16_t* C, uint32_t rows, uint32_t cols){
    m5_work_begin(0, 0);
    for(int i = 0; i < rows; ++i){
        for (int j = 0; j < cols; j++) {
            C[i * cols + j] = A[i * cols + j] + B[i * cols + j];
        }
    }
    m5_work_end(0, 0);
}

void init_matrix(int16_t* A, int16_t* B, uint64_t elems){
    for(int i = 0; i < elems; ++i){
        A[i] = i;
        B[i] = i;
    }
}

void print_matrix(int16_t* C, uint32_t rows, uint32_t cols){
    for(int i = 0; i < rows; ++i){
        for (int j = 0; j < cols; j++) {
            printf("C[%d][%d] = %d\n", i, j, C[i * cols + j]);
        }
    }
}


int main(int argc, char *argv[]) {
    if(argc < 3){
        fprintf(stderr, "Usage: %s <rows> <cols>\n", argv[0]);
        return 1;
    }
    uint32_t rows = atoi(argv[1]);
    uint32_t cols = atoi(argv[2]);
    
    int16_t *A = (int16_t *)aligned_alloc(16, rows * cols * sizeof(int16_t));
    int16_t *B = (int16_t *)aligned_alloc(16, rows * cols * sizeof(int16_t));
    int16_t *C = (int16_t *)aligned_alloc(16, rows * cols * sizeof(int16_t));

    init_matrix(A, B, rows * cols);
    add(A, B, C, rows, cols);
    print_matrix(C, rows, cols);


    free(A);
    free(B);
    free(C);
    return 0;
}