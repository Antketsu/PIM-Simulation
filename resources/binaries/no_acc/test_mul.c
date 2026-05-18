#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>
#include <arm_neon.h>

void mul_neon_int16(
    const int16_t *__restrict__ A,
    const int16_t *__restrict__ B,
    int16_t *__restrict__ C,
    uint32_t rows,
    uint32_t cols
) {
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
}

int main() {
    uint32_t rows = 128, cols = 128;

    // Asignar memoria alineada a 16 bytes
    int16_t *A = (int16_t *)aligned_alloc(16, rows * cols * sizeof(int16_t));
    int16_t *B = (int16_t *)aligned_alloc(16, rows * cols * sizeof(int16_t));
    int16_t *C = (int16_t *)aligned_alloc(16, rows * cols * sizeof(int16_t));

    if (!A || !B || !C) {
        perror("aligned_alloc failed");
        return EXIT_FAILURE;
    }

    // Inicializar matrices A y B
    for (uint32_t i = 0; i < rows; ++i) {
        for (uint32_t j = 0; j < cols; ++j) {
            A[i * cols + j] = (int16_t)i;
            B[i * cols + j] = (int16_t)j;
        }
    }

    // Multiplicación de matrices
    mul_neon_int16(A, B, C, rows, cols);

    // Imprimir algunos resultados para verificación
    for (uint32_t i = 0; i < 2; ++i) {
        for (uint32_t j = 0; j < 2; ++j) {
            printf("C[%d][%d] = %d\n", i, j, C[i * cols + j]);
        }
    }

    // Liberar memoria
    free(A);
    free(B);
    free(C);

    return 0;
}