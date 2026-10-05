/*
 * Elementwise FP16 addition baseline for resources/binaries/acc/add.c.
 * Uses ARM SVE FP16 vectors directly, without OpenBLAS.
 *
 * Build from resources/binaries/no_acc with:
 *   make add
 *
 * Run with matrix dimensions rows and cols:
 *   ./add rows cols [print_result]
 */

#include <errno.h>
#include <limits.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <arm_sve.h>
#include <gem5/m5ops.h>

_Static_assert(sizeof(float16_t) == 2, "FP16 must be 16 bits");

static int parse_dimension(const char *text, const char *name, uint32_t *value)
{
	char *end;
	unsigned long parsed;

	errno = 0;
	parsed = strtoul(text, &end, 10);
	if (errno != 0 || *text == '\0' || *end != '\0' || parsed == 0 ||
	    parsed > INT_MAX) {
		fprintf(stderr, "%s must be a positive integer (got '%s')\n",
		        name, text);
		return 0;
	}
	*value = (uint32_t)parsed;
	return 1;
}

static void add_fp16_sve(const float16_t *a, const float16_t *b,
			 float16_t *c, size_t count)
{
	size_t i = 0;
	while (i < count) {
		svbool_t pg = svwhilelt_b16(i, count);
		svfloat16_t va = svld1_f16(pg, a + i);
		svfloat16_t vb = svld1_f16(pg, b + i);
		svfloat16_t vc = svadd_f16_x(pg, va, vb);
		svst1_f16(pg, c + i, vc);
		i += svcnth();
	}
}

int main(int argc, char **argv)
{
	uint32_t rows, cols;
	int print_result = 1;
	size_t count;
	float16_t *a, *b, *c;

	if ((argc != 3 && argc != 4) ||
	    !parse_dimension(argv[1], "rows", &rows) ||
	    !parse_dimension(argv[2], "cols", &cols)) {
		fprintf(stderr, "Usage: %s rows cols [print_result]\n", argv[0]);
		return 1;
	}
	if (argc == 4)
		print_result = atoi(argv[3]) != 0;
	if ((size_t)rows > SIZE_MAX / (size_t)cols) {
		fprintf(stderr, "matrix dimensions are too large\n");
		return 1;
	}
	count = (size_t)rows * cols;
	if (count > SIZE_MAX / sizeof(*a)) {
		fprintf(stderr, "matrix buffers are too large\n");
		return 1;
	}

	a = malloc(count * sizeof(*a));
	b = malloc(count * sizeof(*b));
	c = malloc(count * sizeof(*c));
	if (a == NULL || b == NULL || c == NULL) {
		fprintf(stderr, "matrix allocation failed for %ux%u\n", rows, cols);
		free(a);
		free(b);
		free(c);
		return 1;
	}

	for (size_t i = 0; i < count; ++i) {
		a[i] = (float16_t)(i % 1000);
		b[i] = (float16_t)(i % 1000);
	}

	m5_work_begin(0, 0);
	add_fp16_sve(a, b, c, count);
	m5_work_end(0, 0);

	printf("SVE FP16 addition: C[%ux%u] = A + B\n", rows, cols);
	if (print_result) {
		for (uint32_t row = 0; row < rows; ++row) {
			for (uint32_t col = 0; col < cols; ++col) {
				size_t i = (size_t)row * cols + col;
				printf("C[%u][%u] = %.0f\n", row, col, (double)c[i]);
			}
		}
	}

	for (size_t i = 0; i < count; ++i) {
		float16_t expected = a[i] + b[i];
		if (c[i] != expected) {
			fprintf(stderr, "result mismatch at %zu: got %.0f, expected %.0f\n",
			        i, (double)c[i], (double)expected);
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
