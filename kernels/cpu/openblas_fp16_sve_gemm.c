/*
 * Small FP16-input GEMM using the bundled OpenBLAS ARMV8SVE build.
 *
 * cblas_shgemm consumes IEEE binary16 inputs and writes FP32 output. This
 * OpenBLAS build was made with BUILD_HFLOAT16=1, which defines hfloat16 as
 * _Float16 on AArch64. Define the same option before including cblas.h so the
 * caller's prototype and storage type match the library build.
 *
 * Build from the repository root with an AArch64 cross compiler:
 *   aarch64-linux-gnu-gcc -O2 -march=armv8.2-a+sve -Ikernels/cpu/OpenBLAS \
 *     kernels/cpu/openblas_fp16_sve_gemm.c \
 *     -Lkernels/cpu/OpenBLAS \
 *     -Wl,-rpath,'$ORIGIN/OpenBLAS' -lopenblas -lm \
 *     -o kernels/build/openblas_fp16_sve_gemm_cpu
 *
 * Run with matrix dimensions M, N, K:
 *   ./openblas_fp16_sve_gemm M N K
 */

#include <errno.h>
#include <limits.h>
#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <gem5/m5ops.h>

/* cblas.h derives hfloat16 from this build option. */
#ifndef BUILD_HFLOAT16
#define BUILD_HFLOAT16 1
#endif
#include "cblas.h"

_Static_assert(sizeof(hfloat16) == 2,
               "OpenBLAS hfloat16 must be a 16-bit _Float16");
_Static_assert(_Generic((hfloat16)0, _Float16: 1, default: 0),
               "OpenBLAS hfloat16 is not _Float16; check BUILD_HFLOAT16");

static int parse_dimension(const char *text, const char *name, int *value)
{
	char *end;
	long parsed;

	errno = 0;
	parsed = strtol(text, &end, 10);
	if (errno != 0 || *text == '\0' || *end != '\0' ||
	    parsed <= 0 || parsed > INT_MAX) {
		fprintf(stderr, "%s must be a positive integer (got '%s')\n",
		        name, text);
		return 0;
	}
	*value = (int)parsed;
	return 1;
}

int main(int argc, char **argv)
{
	int m, n, k;
	hfloat16 *a;
	hfloat16 *b;
	float *c;
	size_t a_count, b_count, c_count;

	if (argc != 4 || !parse_dimension(argv[1], "M", &m) ||
	    !parse_dimension(argv[2], "N", &n) ||
	    !parse_dimension(argv[3], "K", &k)) {
		fprintf(stderr, "Usage: %s M N K\n", argv[0]);
		fprintf(stderr, "Computes C[MxN] = A[MxK] * B[KxN].\n");
		return 1;
	}

	if ((size_t)m > SIZE_MAX / (size_t)k ||
	    (size_t)k > SIZE_MAX / (size_t)n ||
	    (size_t)m > SIZE_MAX / (size_t)n) {
		fprintf(stderr, "matrix dimensions are too large\n");
		return 1;
	}
	a_count = (size_t)m * (size_t)k;
	b_count = (size_t)k * (size_t)n;
	c_count = (size_t)m * (size_t)n;

	/* Row-major A[MxK] and B[KxN], initialized with dummy FP16 values. */
	a = malloc(a_count * sizeof(*a));
	b = malloc(b_count * sizeof(*b));
	c = calloc(c_count, sizeof(*c));
	if (a == NULL || b == NULL || c == NULL) {
		fprintf(stderr, "matrix allocation failed for %dx%dx%d\n", m, n, k);
		free(a);
		free(b);
		free(c);
		return 1;
	}
	for (size_t i = 0; i < a_count; ++i)
		a[i] = 1.0;
	for (size_t i = 0; i < b_count; ++i)
		b[i] = 1.0;

	m5_work_begin(0, 0);
	/* C := A * B; cblas_shgemm accumulates into FP32 C. */
	cblas_shgemm(CblasRowMajor, CblasNoTrans, CblasNoTrans,
	             m, n, k, 1.0f, a, k, b, n, 0.0f, c, n);
	m5_work_end(0, 0);
	printf("OpenBLAS core: %s\n", openblas_get_corename());
	printf("C[%dx%d] = A[%dx%d] * B[%dx%d], with all inputs equal to 1.0\n",
	       m, n, m, k, k, n);
	printf("C[0] = %8.3f, expected %8.3f\n", c[0], (float)k);

	for (size_t i = 0; i < c_count; ++i) {
		if (c[i] != (float)k) {
			fprintf(stderr, "result mismatch at %zu: got %g, expected %g\n",
			        i, c[i], (float)k);
			free(a);
			free(b);
			free(c);
			return 1;
		}
	}

	free(a);
	free(b);
	free(c);
	return 0;
}
