#include <stdio.h>
#include <stdint.h>
#include <gem5/m5ops.h>
#include <stdlib.h>
#include <arm_neon.h>

// Suma de matrices C = A + B
// M = filas, N = columnas
void add(const int16_t *__restrict__ A,
         const int16_t *__restrict__ B,
         int16_t *__restrict__ C,
         uint32_t M,
         uint32_t N) {
    
    m5_work_begin(0, 0);

    uint32_t total_elements = M * N;
    uint32_t i = 0;

    // BUCLE VECTORIAL PRINCIPAL: Avanza de 8 en 8 elementos (16 bytes)
    for (; i + 8 <= total_elements; i += 8) {
        // 1. Carga 8 elementos (128 bits) de A y B
        int16x8_t a_vec = vld1q_s16(&A[i]);
        int16x8_t b_vec = vld1q_s16(&B[i]);

        // 2. Suma vectorial de 16 bits (8 operaciones simultáneas)
        int16x8_t c_vec = vaddq_s16(a_vec, b_vec);

        // 3. Almacena el resultado de golpe en C
        vst1q_s16(&C[i], c_vec);
    }

    // BUCLE REMANENTE (Limpieza): Para manejar el resto si total_elements no es múltiplo de 8
    for (; i < total_elements; ++i) {
        C[i] = A[i] + B[i];
    }
    
    m5_work_end(0, 0);
}

void init_matrix(int16_t* A, int16_t* B, uint32_t rows, uint32_t cols){
    for(uint32_t i = 0; i < rows; ++i){
        for (uint32_t j = 0; j < cols; j++) {
            A[i * cols + j] = i + j;
            B[i * cols + j] = (i + j) * 2;
        }
    } 
}

void print_matrix(int16_t* C, uint32_t rows, uint32_t cols){
    for(uint32_t i = 0; i < rows; ++i){
        for (uint32_t j = 0; j < cols; j++) {
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
    uint32_t total_elements = rows * cols;
    
    // Asignación con memoria alineada a 16 bytes para maximizar el rendimiento de NEON
    int16_t *A = (int16_t *)aligned_alloc(16, total_elements * sizeof(int16_t));
    int16_t *B = (int16_t *)aligned_alloc(16, total_elements * sizeof(int16_t));
    int16_t *C = (int16_t *)aligned_alloc(16, total_elements * sizeof(int16_t));

    init_matrix(A, B, rows, cols);
    add(A, B, C, rows, cols);
    print_matrix(C, rows, cols);

    free(A);
    free(B);
    free(C);
    return 0;
}