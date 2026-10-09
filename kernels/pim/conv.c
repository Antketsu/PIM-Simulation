#include <inttypes.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>

#include "pim.h"

/* Gather input patches directly into the PIM layout used by GEMM's B operand. */
static void im2col_to_pim_layout(const int16_t *input, int16_t *dst,
                                 uint32_t height, uint32_t width,
                                 uint32_t channels, uint32_t kernel_h,
                                 uint32_t kernel_w,
                                 uint32_t padded_positions) {
    uint32_t output_h = height - kernel_h + 1;
    uint32_t output_w = width - kernel_w + 1;
    uint32_t output_positions = output_h * output_w;
    uint32_t kernel_size = kernel_h * kernel_w * channels;
    int16_t *iter = dst;

    for (uint32_t i = 0; i < kernel_size; i += 8) {
        for (uint32_t j = 0; j < padded_positions; j += 128) {
            for (uint32_t b = 0; b < 8; ++b) {
                int16_t *bank_ptr = (int16_t *)
                    (((uintptr_t)iter & ~(0xFULL << 10)) |
                     ((2 * b + 1) << 10));

                for (uint32_t r = 0; r < 8; ++r) {
                    uint32_t kernel_index = i + r;
                    uint32_t ky = kernel_index / (kernel_w * channels);
                    uint32_t kx = (kernel_index / channels) % kernel_w;
                    uint32_t channel = kernel_index % channels;
                    for (uint32_t k = 0; k < 16; ++k) {
                        uint32_t position = j + b * 16 + k;
                        if (position < output_positions) {
                            uint32_t oy = position / output_w;
                            uint32_t ox = position % output_w;
                            bank_ptr[k] = input[
                                ((size_t)(oy + ky) * width + ox + kx) *
                                channels + channel];
                        } else {
                            bank_ptr[k] = 0;
                        }
                    }
                    bank_ptr = increment_iter(bank_ptr);
                }
            }
            for (uint32_t r = 0; r < 8; ++r)
                iter = increment_iter(iter);
        }
    }
}

static void fill_data(int16_t *input, int16_t *filters,
                      size_t input_elems, size_t filter_elems) {
    for (size_t i = 0; i < input_elems; ++i)
        input[i] = (int16_t)((int)(i % 7) - 3);
    for (size_t i = 0; i < filter_elems; ++i)
        filters[i] = (int16_t)((int)(i % 5) - 2);
}

static void print_result(int16_t *result, uint32_t rows,
                         uint32_t cols, uint32_t padded_cols) {
    int16_t *iter = result;
    for (uint32_t i = 0; i < rows; ++i) {
        for (uint32_t j = 0; j < padded_cols; j += 128) {
            for (uint32_t b = 0; b < 8; ++b) {
                iter = (int16_t *)(((uintptr_t)iter & ~(0xFULL << 10)) |
                                   ((2 * b) << 10));
                for (uint32_t k = 0; k < 16; ++k) {
                    uint32_t position = j + b * 16 + k;
                    if (position < cols)
                        printf("C[%" PRIu32 "][%" PRIu32 "] = %d\n", i,
                               position,
                               iter[k]);
                }
            }
            iter = increment_iter(iter);
        }
    }
}

int main(int argc, char *argv[]) {
    if (argc < 7) {
        fprintf(stderr,
                "Usage: %s input_height input_width input_channels "
                "kernel_height kernel_width output_channels [print_result]\n",
                argv[0]);
        return 1;
    }

    uint32_t height = (uint32_t)strtoul(argv[1], NULL, 10);
    uint32_t width = (uint32_t)strtoul(argv[2], NULL, 10);
    uint32_t channels = (uint32_t)strtoul(argv[3], NULL, 10);
    uint32_t kernel_h = (uint32_t)strtoul(argv[4], NULL, 10);
    uint32_t kernel_w = (uint32_t)strtoul(argv[5], NULL, 10);
    uint32_t output_channels = (uint32_t)strtoul(argv[6], NULL, 10);
    int print = argc > 7 ? atoi(argv[7]) : 1;

    if (!height || !width || !channels || !kernel_h || !kernel_w ||
        !output_channels || kernel_h > height || kernel_w > width) {
        fprintf(stderr, "dimensions must be positive and the kernel must fit the input\n");
        return 1;
    }

    uint64_t kernel_size64 = (uint64_t)kernel_h * kernel_w * channels;
    uint64_t output_rows64 = (uint64_t)(height - kernel_h + 1) *
                             (width - kernel_w + 1);
    uint64_t padded_positions64 = output_rows64 <= UINT32_MAX
                                      ? ((output_rows64 + 127) / 128) * 128
                                      : UINT64_MAX;
    uint64_t filter_elems64 = kernel_size64 * output_channels;
    if (kernel_size64 > UINT32_MAX || output_rows64 > UINT32_MAX ||
        padded_positions64 > UINT32_MAX ||
        filter_elems64 > SIZE_MAX / sizeof(int16_t) ||
        kernel_size64 % 8 != 0) {
        fprintf(stderr, "kernel size must fit uint32 and be divisible by 8; "
                        "padded output positions must fit uint32\n");
        return 1;
    }

    uint32_t output_rows = (uint32_t)output_rows64;
    uint32_t padded_positions = (uint32_t)padded_positions64;
    uint32_t kernel_size = (uint32_t)kernel_size64;
    uint64_t input_elems64 = (uint64_t)height * width * channels;
    if (input_elems64 > SIZE_MAX / sizeof(int16_t)) {
        fprintf(stderr, "input buffer is too large\n");
        return 1;
    }
    size_t input_elems = (size_t)input_elems64;
    size_t filter_elems = (size_t)kernel_size * output_channels;

    int16_t *input = malloc(input_elems * sizeof(*input));
    int16_t *filters = malloc(filter_elems * sizeof(*filters));
    if (!input || !filters) {
        fprintf(stderr, "host allocation failed\n");
        free(input);
        free(filters);
        return 1;
    }
    fill_data(input, filters, input_elems, filter_elems);

    if (init_pim() != 0) {
        free(input);
        free(filters);
        return 1;
    }

    int16_t *result;
    if (init_operand(&result) != 0) {
        free(input);
        free(filters);
        return 1;
    }
    int16_t *columns_pim = (int16_t *)((uintptr_t)result + (1 << 10));

    m5_work_begin(0, 0);
    im2col_to_pim_layout(input, columns_pim, height, width, channels,
                         kernel_h, kernel_w, padded_positions);
    matrix_multiplication(filters, columns_pim, result, output_channels,
                          kernel_size, padded_positions);
    m5_work_end(0, 0);

    if (print)
        print_result(result, output_channels, output_rows, padded_positions);

    free(input);
    free(filters);
    return 0;
}
