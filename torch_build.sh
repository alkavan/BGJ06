#!/usr/bin/env bash

cd torch
TORCH_NVCC_FLAGS="-D__CUDA_NO_HALF_OPERATORS__" TORCH_LUA_VERSION=LUA53 ./install.sh
