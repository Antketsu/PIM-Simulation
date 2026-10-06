#!/usr/bin/env python3
"""Compute a CPU reference for the deterministic convolution in conv.c."""

import argparse

import numpy as np
from scipy.signal import correlate2d


def main():
    parser = argparse.ArgumentParser(
        description="Reference valid, stride-1 HWC convolution used by conv.c."
    )
    parser.add_argument("input_height", type=int)
    parser.add_argument("input_width", type=int)
    parser.add_argument("input_channels", type=int)
    parser.add_argument("kernel_height", type=int)
    parser.add_argument("kernel_width", type=int)
    parser.add_argument("output_channels", type=int)
    args = parser.parse_args()

    h, w, channels = (
        args.input_height,
        args.input_width,
        args.input_channels,
    )
    kh, kw, output_channels = (
        args.kernel_height,
        args.kernel_width,
        args.output_channels,
    )
    if min(h, w, channels, kh, kw, output_channels) <= 0:
        parser.error("all dimensions must be positive")
    if kh > h or kw > w:
        parser.error("kernel dimensions must fit inside the input")

    output_h = h - kh + 1
    output_w = w - kw + 1
    positions = output_h * output_w
    kernel_size = kh * kw * channels

    # Match fill_data() in conv.c exactly; input uses HWC order and filters
    # use output-channel-major, then kernel-y, kernel-x, input-channel order.
    input_data = (np.arange(h * w * channels) % 7 - 3).reshape(
        h, w, channels
    )
    filters = (np.arange(output_channels * kernel_size) % 5 - 2).reshape(
        output_channels, kh, kw, channels
    )

    # conv.c multiplies each patch by the filter in stored order (cross-
    # correlation), so correlate2d matches its valid, stride-1 operation.
    result = np.zeros((output_channels, output_h, output_w), dtype=np.int64)
    for oc in range(output_channels):
        for channel in range(channels):
            result[oc] += correlate2d(
                input_data[:, :, channel].astype(np.int64),
                filters[oc, :, :, channel].astype(np.int64),
                mode="valid",
            )
    result = result.reshape(output_channels, positions)

    for oc in range(output_channels):
        for position in range(positions):
            print(f"C[{oc}][{position}] = {result[oc, position]}")


if __name__ == "__main__":
    main()
