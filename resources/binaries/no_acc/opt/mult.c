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

    for (uint32_t i = 0; i < M; ++i) {
        // NOTA: Sigue asumiendo que 'N' (columnas de B) es múltiplo de 4
        for (uint32_t j = 0; j < N; j += 4) {  
            
            // Acumulador de 32 bits para los 4 elementos de la fila de C
            int32x4_t c_vec_s32 = vdupq_n_s32(0);  

            // k recorre la dimensión interna 'K' (columnas de A / filas de B)
            for (uint32_t k = 0; k < K; ++k) {
                // El salto de fila en A depende de sus propias columnas ('K')
                int16_t a = A[i * K + k];
                int16x4_t a_vec = vdup_n_s16(a);          
                
                // El salto de fila en B depende de sus propias columnas ('N')
                int16x4_t b_vec = vld1_s16(&B[k * N + j]);  

                // Multiplicar y acumular en un solo paso
                c_vec_s32 = vmlal_s16(c_vec_s32, a_vec, b_vec);
            }

            // Estrechar de 32 bits a 16 bits (registro D de 64 bits)
            int16x4_t c_vec = vqmovn_s32(c_vec_s32);

            // El salto de fila en C depende de sus propias columnas ('N')
            vst1_s16(&C[i * N + j], c_vec);
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