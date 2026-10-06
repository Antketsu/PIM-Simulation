/*
 * FP16-input convolution baseline using the bundled OpenBLAS ARMV8SVE build.
 * The deterministic input/filter values and valid, stride-1 HWC convolution
 * match kernels/pim/conv.c. The convolution is lowered to GEMM
 * inside the measured region.
 */
#include <errno.h>
#include <limits.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <gem5/m5ops.h>

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
	int height, width, channels, kernel_h, kernel_w, output_channels;
	int print_result = 1;
	int output_h, output_w;
	size_t input_count, filter_count, columns_count, result_count;
	hfloat16 *input = NULL, *filters = NULL, *columns = NULL;
	float *result = NULL;

	if ((argc != 7 && argc != 8) ||
	    !parse_dimension(argv[1], "input_height", &height) ||
	    !parse_dimension(argv[2], "input_width", &width) ||
	    !parse_dimension(argv[3], "input_channels", &channels) ||
	    !parse_dimension(argv[4], "kernel_height", &kernel_h) ||
	    !parse_dimension(argv[5], "kernel_width", &kernel_w) ||
	    !parse_dimension(argv[6], "output_channels", &output_channels)) {
		fprintf(stderr,
		        "Usage: %s input_height input_width input_channels "
		        "kernel_height kernel_width output_channels [print_result]\n",
		        argv[0]);
		return 1;
	}
	if (argc == 8)
		print_result = atoi(argv[7]) != 0;
	if (kernel_h > height || kernel_w > width) {
		fprintf(stderr, "kernel dimensions must fit inside the input\n");
		return 1;
	}

	output_h = height - kernel_h + 1;
	output_w = width - kernel_w + 1;
	if (kernel_h > INT_MAX / kernel_w ||
	    kernel_h * kernel_w > INT_MAX / channels ||
	    output_h > INT_MAX / output_w) {
		fprintf(stderr, "convolution dimensions are too large\n");
		return 1;
	}
	int kernel_size = kernel_h * kernel_w * channels;
	int positions = output_h * output_w;
	if ((size_t)height > SIZE_MAX / (size_t)width ||
	    (size_t)height * (size_t)width > SIZE_MAX / (size_t)channels ||
	    (size_t)output_channels > SIZE_MAX / (size_t)kernel_size ||
	    (size_t)kernel_size > SIZE_MAX / (size_t)positions ||
	    (size_t)output_channels > SIZE_MAX / (size_t)positions) {
		fprintf(stderr, "convolution buffers are too large\n");
		return 1;
	}
	input_count = (size_t)height * width * channels;
	filter_count = (size_t)output_channels * kernel_size;
	columns_count = (size_t)kernel_size * positions;
	result_count = (size_t)output_channels * positions;
	if (input_count > SIZE_MAX / sizeof(*input) ||
	    filter_count > SIZE_MAX / sizeof(*filters) ||
	    columns_count > SIZE_MAX / sizeof(*columns) ||
	    result_count > SIZE_MAX / sizeof(*result)) {
		fprintf(stderr, "convolution buffers are too large\n");
		return 1;
	}

	input = malloc(input_count * sizeof(*input));
	filters = malloc(filter_count * sizeof(*filters));
	columns = malloc(columns_count * sizeof(*columns));
	result = malloc(result_count * sizeof(*result));
	if (input == NULL || filters == NULL || columns == NULL || result == NULL) {
		fprintf(stderr, "convolution buffer allocation failed\n");
		goto cleanup;
	}

	/* Same flat initialization formulas as fill_data() in conv.c. */
	for (size_t i = 0; i < input_count; ++i)
		input[i] = (hfloat16)((int)(i % 7) - 3);
	for (size_t i = 0; i < filter_count; ++i)
		filters[i] = (hfloat16)((int)(i % 5) - 2);

	m5_work_begin(0, 0);
	/* B[KxN]: each column is one output position's flattened input patch. */
	for (int oy = 0; oy < output_h; ++oy) {
		for (int ox = 0; ox < output_w; ++ox) {
			int position = oy * output_w + ox;
			for (int ky = 0; ky < kernel_h; ++ky) {
				for (int kx = 0; kx < kernel_w; ++kx) {
					for (int channel = 0; channel < channels; ++channel) {
						int k = (ky * kernel_w + kx) * channels + channel;
						size_t input_index =
							((size_t)(oy + ky) * width + ox + kx) * channels +
							channel;
						columns[(size_t)k * positions + position] =
							input[input_index];
					}
				}
			}
		}
	}

	/* C[output_channels x positions] = filters[OC x K] * columns[K x N]. */
	cblas_shgemm(CblasRowMajor, CblasNoTrans, CblasNoTrans,
	             output_channels, positions, kernel_size, 1.0f,
	             filters, kernel_size, columns, positions,
	             0.0f, result, positions);
	m5_work_end(0, 0);

	printf("OpenBLAS core: %s\n", openblas_get_corename());
	printf("Valid stride-1 convolution: input %dx%dx%d, kernel %dx%dx%d, "
	       "output %dx%dx%d\n",
	       height, width, channels, kernel_h, kernel_w, channels,
	       output_h, output_w, output_channels);
	if (print_result) {
		for (int oc = 0; oc < output_channels; ++oc)
			for (int position = 0; position < positions; ++position)
				printf("C[%d][%d] = %.0f\n", oc, position,
				       result[(size_t)oc * positions + position]);
	}

	free(input);
	free(filters);
	free(columns);
	free(result);
	return 0;

cleanup:
	free(input);
	free(filters);
	free(columns);
	free(result);
	return 1;
}
