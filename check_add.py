rows = 320
cols = 640
import numpy as np
A = np.array([[i + j for j in range(cols)] for i in range(rows)], dtype=np.int16)
B = np.array([[2 * (i + j) for j in range(cols)] for i in range(rows)], dtype=np.int16)
C = np.zeros((rows, cols), dtype=np.int16)

C = A + B

for i in range(rows):
    for j in range(cols):
        print(f"C[{i}][{j}] = {C[i][j]}")