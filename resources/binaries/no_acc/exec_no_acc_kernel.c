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


void mult(int16_t* A, int16_t* B, int16_t* C, uint32_t rows_C, uint32_t cols_C){
    m5_work_begin(0, 0);
    for(int i = 0; i < rows_C; ++i){
        for (int j = 0; j < cols_C; j++) {
            C[i * cols_C + j] = 0;
            for(int k = 0; k < cols_C; ++k){
                C[i * cols_C + j] += A[i * cols_C + k] * B[k * cols_C + j];
            }
        }
    }
    m5_work_end(0, 0);
}

void print_matrix(int16_t* C, uint32_t rows, uint32_t cols){
    for(int i = 0; i < rows; ++i){
        for (int j = 0; j < cols; j++) {
            printf("C[%d][%d] = %d\n", i, j, C[i * cols + j]);
        }
    }
}

void init_matrix_mult(int16_t* A, int16_t* B, uint32_t rows_A, uint32_t cols_A, uint32_t rows_B, uint32_t cols_B){
    for(int i = 0; i < rows_A; ++i){
        for (int j = 0; j < cols_A; j++) {
            A[i * cols_A + j] = i; 
        }
    }
    for(int i = 0; i < rows_B; ++i){
        for (int j = 0; j < cols_B; j++) {
            B[i * cols_B + j] = (i == j) ? 1 : 0;
        }
    }
}

int main(int argc, char *argv[]) {
    int16_t *A, *B, *C;
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
    
    A = (int16_t*)malloc(rows_A * cols_A * sizeof(int16_t));
    B = (int16_t*)malloc(rows_B * cols_B * sizeof(int16_t));
    C = (int16_t*)malloc(rows_C * cols_C * sizeof(int16_t));


    if(kernel == 0){
        init_matrix_mult(A, B, rows_A, cols_A, rows_B, cols_B);
        add(A, B, C, rows_C, cols_C);
        print_matrix(C, rows_C, cols_C);
    }
    else if(kernel == 1){
        init_matrix_mult(A, B, rows_A, cols_A, rows_B, cols_B);
        mult(A, B, C, rows_C, cols_C);
        print_matrix(C, rows_C, cols_C);
    }
    else{
        fprintf(stderr, "Invalid kernel. Use 0 for add and 1 for matrix multiplication.\n");
        return 1;
    }

    free(A);
    free(B);
    free(C);
    return 0;
}