#!/usr/bin/env bash

SCRIPT_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && pwd)

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
