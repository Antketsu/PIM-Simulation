#include <stdio.h>
#include <stdint.h>
#include <gem5/m5ops.h>
#include <stdlib.h>

void mult(int16_t* A, int16_t* B, int16_t* C, uint32_t rows_A, uint32_t cols_A, uint32_t cols_B){
    printf("Starting multiplication...\n");
    //m5_work_begin(0, 0);
    for(int i = 0; i < rows_A; ++i){
        for (int j = 0; j < cols_B; j++) {
            int32_t sum = 0; // Usamos un acumulador temporal local limpia
            for(int k = 0; k < cols_A; ++k){
                // El salto de fila de A es cols_A (rows_B)
                // El salto de fila de B es cols_B
                sum += A[i * cols_A + k] * B[k * cols_B + j];
            }
            C[i * cols_B + j] = (int16_t)sum;
        }
    }
    //m5_work_end(0, 0);
}

void init_matrix(int16_t* A, int16_t* B, uint32_t rows_A, uint32_t rows_B, uint32_t cols_B){
   for(int i = 0; i < rows_A; ++i){
        for (int j = 0; j < rows_B; j++) {
            A[i * rows_B + j] = i + 1; 
        }
    }
    for(int i = 0; i < rows_B; ++i){
        for (int j = 0; j < cols_B; j++) {
            B[i * cols_B + j] = (i == j) ? 1 : 0;
        }
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
    uint32_t rows_A = atoi(argv[1]);
    uint32_t rows_B = atoi(argv[2]);
    uint32_t cols_B = atoi(argv[3]);

    printf("Allocating...\n");
    
    int16_t *A = (int16_t *)aligned_alloc(16, rows_A * rows_B * sizeof(int16_t));
    int16_t *B = (int16_t *)aligned_alloc(16, rows_B * cols_B * sizeof(int16_t));
    int16_t *C = (int16_t *)aligned_alloc(16, rows_A * cols_B * sizeof(int16_t));

    init_matrix(A, B, rows_A, rows_B, cols_B);
    mult(A, B, C, rows_A, rows_B, cols_B);
    print_matrix(C, rows_A, cols_B);


    free(A);
    free(B);
    free(C);
    return 0;
}