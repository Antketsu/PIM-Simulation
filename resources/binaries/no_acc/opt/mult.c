#include <stdio.h>
#include <stdint.h>
#include <gem5/m5ops.h>
#include <stdlib.h>
#include <arm_neon.h>

// M = filas_A, K = columnas_A (o filas_B), N = columnas_B
void mult(const int16_t *__restrict__ A,
          const int16_t *__restrict__ B,
          int16_t *__restrict__ C,
          uint32_t M,
          uint32_t K,
          uint32_t N) {
    
    m5_work_begin(0, 0);

    // Inicializar la matriz C a cero si el algoritmo va a acumular sobre ella de forma dispersa
    // (Asumiendo que C entra limpio o lo limpiamos antes)
    
    for (uint32_t i = 0; i < M; ++i) {
        for (uint32_t k = 0; k < K; ++k) {
            
            // 1. CARGA OPTIMIZADA DE A: Se hace una sola vez para TODO el barrido de columnas de B.
            // Duplicamos el elemento en un vector de 8 elementos de 16 bits (128 bits completos).
            int16x8_t a_vec = vdupq_n_s16(A[i * K + k]);

            // 2. BUCLE INTERNO ULTRA-RÁPIDO: Avanza de 8 en 8 elementos (16 bytes por paso)
            // Esto es 100% contiguo en memoria tanto para B como para C.
            for (uint32_t j = 0; j < N; j += 8) {  
                
                // Carga los 8 elementos actuales acumulados en C
                int16x8_t c_vec = vld1q_s16(&C[i * N + j]);
                
                // Carga los 8 elementos de la fila de B
                int16x8_t b_vec = vld1q_s16(&B[k * N + j]);  

                // Multiplicación y acumulación en 16 bits (NEON realiza la operación)
                // Nota: Usamos vmlaq_s16 para mantener todo en 16 bits si no hay riesgo de desbordamiento,
                // o expandimos a 32 bits si es estrictamente necesario por precisión.
                c_vec = vmlaq_s16(c_vec, a_vec, b_vec);

                // Almacena los 8 elementos de golpe en la memoria/caché
                vst1q_s16(&C[i * N + j], c_vec);
            }
        }
    }
    
    m5_work_end(0, 0);
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