import sys
import torch

def ls_to_int(ls: list[str]):
    return list(map(lambda x: int(x), ls))

ls = []
input_X_dimC, input_X_dimH, input_X_dimW = 0, 0, 0
strideH, strideW = 0, 0
kernelH, kernelW = 0, 0

# read parameters and random list
with open("Bonus/rand_input.txt", "r") as rand_file:
    it = rand_file.readlines()
    input_X_dimC, input_X_dimH, input_X_dimW = ls_to_int(it[0].strip().split())
    strideH, strideW = ls_to_int(it[1].strip().split())
    kernelH, kernelW = ls_to_int(it[2].strip().split())
    ls = ls_to_int(eval(it[3]))

if len(sys.argv) > 1 and sys.argv[1] == '-d':
    print("In Python script, fetch random input:")
    print("shape:", input_X_dimC, input_X_dimH, input_X_dimW)
    print("stride:", strideH, strideW)
    print("kernel:", kernelH, kernelW)

# run maxpool algorithm
ls = torch.tensor(ls).reshape((input_X_dimC, input_X_dimH, input_X_dimW))
if len(sys.argv) > 1 and sys.argv[1] == '-d':
    print(ls)
maxpool = torch.nn.MaxPool2d(kernel_size=(kernelH, kernelW), stride=(strideH, strideW))
ls: torch.Tensor = maxpool.forward((ls))
ls = torch.flatten(ls)
if len(sys.argv) > 1 and sys.argv[1] == '-d':
    print(ls)

# write result to file
with open("Bonus/py_output.txt", "w") as f:
    for n in ls.numpy():
        f.write(f"{n}\n")
