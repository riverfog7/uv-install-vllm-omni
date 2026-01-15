## How to install
- Run `configure.sh` to download torch, vllm, vllm omni, and model weights.
- Model weights downloading functionality can be turned off by setting the `DOWNLOAD_MODEL` environment variable to `0` before running `configure.sh`:
```bash
DOWNLOAD_MODEL=0 ./configure.sh
```

## Run vllm-omni
- Use the `uv run` command to start vllm-omni:
```bash
uv run vllm-omni
```
