#!/usr/bin/env bash

SCRIPT_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && pwd)
DOWNLOAD_MODEL=${DOWNLOAD_MODEL:-"1"}
MODEL_DIR=${MODEL_DIR:-"$SCRIPT_DIR/model"}

cd "$SCRIPT_DIR" || exit 1

if [ "$(uname)" != "Linux" ]; then
    echo "Unsupported OS: $(uname). This script supports only Linux and macOS."
    exit 1
fi

if ! command -v ffmpeg &> /dev/null; then
    if ! command -v sudo &> /dev/null; then
        apt update && apt install -y sudo
    fi
    sudo apt install -y ffmpeg
fi

if ! command -v uv &> /dev/null; then
    curl -LsSf https://astral.sh/uv/install.sh | sh
    source "$HOME/.local/bin/env"
fi

DETECTED_CUDA=""

if command -v nvcc &> /dev/null; then
    DETECTED_CUDA=$(nvcc --version | sed -n 's/^.*release \([0-9]\+\.[0-9]\+\).*$/\1/p')
    echo "Detected NVCC: $DETECTED_CUDA"

elif command -v nvidia-smi &> /dev/null; then
    DETECTED_CUDA=$(nvidia-smi | grep "CUDA Version" | awk '{print $9}')
    echo "Detected NVIDIA Driver (Max CUDA): $DETECTED_CUDA"
fi


echo "Running: uv sync"
cd "$SCRIPT_DIR" || exit 1
uv sync --frozen --no-dev


if [ "$DOWNLOAD_MODEL" == "1" ]; then
    echo "Downloading models to ${MODEL_DIR}"
    mkdir -p "${MODEL_DIR}"
    uv tool run --with hf_transfer hf download cybermotaz/Qwen3-Omni-30B-A3B-Instruct-NVFP4 --local-dir "${MODEL_DIR}"
fi
