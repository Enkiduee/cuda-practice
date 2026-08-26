#!/bin/bash

# ---------------------------
# CUDA
# ---------------------------

if [ -d /usr/local/cuda ]; then
    export CUDA_HOME=/usr/local/cuda
else
    CUDA_DIR=$(ls -d /usr/local/cuda-* 2>/dev/null | sort -V | tail -1)
    if [ -n "$CUDA_DIR" ]; then
        export CUDA_HOME="$CUDA_DIR"
    fi
fi

if [ -n "$CUDA_HOME" ]; then
    export PATH="$CUDA_HOME/bin:$PATH"
fi


# ---------------------------
# NVIDIA / CUDA libraries
# ---------------------------

for LIB_DIR in \
    /usr/lib64-nvidia \
    /usr/local/nvidia/lib64 \
    "$CUDA_HOME/lib64"
do
    if [ -d "$LIB_DIR" ]; then
        case ":${LD_LIBRARY_PATH:-}:" in
            *":$LIB_DIR:"*)
                ;;
            *)
                export LD_LIBRARY_PATH="$LIB_DIR${LD_LIBRARY_PATH:+:$LD_LIBRARY_PATH}"
                ;;
        esac
    fi
done


echo "CUDA environment loaded."

if command -v nvcc >/dev/null 2>&1; then
    echo "nvcc: $(command -v nvcc)"
else
    echo "WARNING: nvcc not found"
fi

if command -v nvidia-smi >/dev/null 2>&1; then
    echo "nvidia-smi: $(command -v nvidia-smi)"
else
    echo "WARNING: nvidia-smi not found"
fi
