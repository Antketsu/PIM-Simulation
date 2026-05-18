#include <stdio.h>
#include <stdint.h>
#include <gem5/m5ops.h>
#include <stdlib.h>
#include <arm_neon.h>

void add(int16_t* A, int16_t* B, int16_t* C, uint32_t rows, uint32_t cols){
    m5_work_begin(0, 0);
    for(int i = 0; i < rows; ++i){
        for (int j = 0; j < cols; j++) {
            C[i * cols + j] = A[i * cols + j] + B[i * cols + j];
        }
    }
    m5_work_end(0, 0);
}


void mult(const int16_t *__restrict__ A,
    const int16_t *__restrict__ B,
    int16_t *__restrict__ C,
    uint32_t rows,
    uint32_t cols){
    m5_work_begin(0, 0);
    // Inicializar C a 0
    for (uint32_t i = 0; i < rows; ++i) {
        for (uint32_t j = 0; j < cols; ++j) {
            C[i * cols + j] = 0;
        }
    }

    // Multiplicación de matrices con NEON (acumulación en int32x4_t)
    for (uint32_t i = 0; i < rows; ++i) {
        for (uint32_t j = 0; j < cols; j += 4) {  // Procesar 4 elementos de C a la vez
            int32x4_t c_vec_s32 = vdupq_n_s32(0);  // Acumulador en int32x4_t (inicializado a 0)

            for (uint32_t k = 0; k < cols; ++k) {
                int16_t a = A[i * cols + k];
                int16x4_t a_vec = vdup_n_s16(a);          // Replicar 'a' en 4 elementos
                int16x4_t b_vec = vld1_s16(&B[k * cols + j]);  // Cargar 4 elementos de B

                // Multiplicar y promover a int32_t (vmull_s16 devuelve int32x4_t)
                int32x4_t prod = vmull_s16(a_vec, b_vec);

                // Sumar al acumulador (en int32x4_t)
                c_vec_s32 = vaddq_s32(c_vec_s32, prod);
            }

            // Truncar a int16_t (asumiendo que no hay overflow)
            int16x4_t c_vec = vqmovn_s32(c_vec_s32);

            // Almacenar resultado en C
            vst1_s16(&C[i * cols + j], c_vec);
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
    
    int16_t *A = (int16_t *)aligned_alloc(16, rows_A * cols_A * sizeof(int16_t));
    int16_t *B = (int16_t *)aligned_alloc(16, rows_B * cols_B * sizeof(int16_t));
    int16_t *C = (int16_t *)aligned_alloc(16, rows_C * cols_C * sizeof(int16_t));


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