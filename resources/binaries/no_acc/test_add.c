#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>

void add(int16_t* A, int16_t* B, int16_t* C, uint32_t rows, uint32_t cols){
    for(int i = 0; i < rows; ++i){
        for (int j = 0; j < cols; j++) {
            C[i * cols + j] = A[i * cols + j] + B[i * cols + j];
        }
    }
}

int main(){
    int16_t *A, *B, *C;
    uint32_t rows = 128, cols = 128;
    A = (int16_t*)malloc(rows * cols * sizeof(int16_t));
    B = (int16_t*)malloc(rows * cols * sizeof(int16_t));
    C = (int16_t*)malloc(rows * cols * sizeof(int16_t));
    for(int i = 0; i < rows; ++i){
        for (int j = 0; j < cols; j++) {
            A[i * cols + j] = i; 
            B[i * cols + j] = j;
        }
    }
    add(A, B, C, rows, cols);
    for(int i = 0; i < rows; ++i){
        for (int j = 0; j < cols; j++) {
            printf("C[%d][%d] = %d\n", i, j, C[i * cols + j]);
        }
    }
    return 0;
}