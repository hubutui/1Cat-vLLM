ARG BASE_IMAGE=pytorch/pytorch:2.10.0-cuda12.8-cudnn9-devel

FROM ${BASE_IMAGE}

ARG WHEEL=1cat_vllm-1.3.0-cp312-cp312-linux_x86_64.whl
ARG WHEEL_URL=https://github.com/1CatAI/1Cat-vLLM/releases/download/v1.3.0/1cat_vllm-1.3.0-cp312-cp312-linux_x86_64.whl

ENV CUDA_HOME=/usr/local/cuda \
    PATH=/usr/local/cuda/bin:${PATH} \
    LD_LIBRARY_PATH=/usr/local/cuda/lib64:${LD_LIBRARY_PATH} \
    PIP_BREAK_SYSTEM_PACKAGES=1 \
    VLLM_SM70_COMPRESSED_TENSORS_TURBOMIND=1 \
    PYTHONUNBUFFERED=1

RUN --mount=type=cache,target=/var/cache/apt,sharing=locked \
    --mount=type=cache,target=/var/lib/apt,sharing=locked \
    apt-get update -y \
    && apt-get install -y --no-install-recommends curl

RUN --mount=type=cache,target=/root/.cache/pip \
    curl -fL "${WHEEL_URL}" -o /tmp/${WHEEL} \
    && pip install /tmp/${WHEEL} \
    && rm -f /tmp/${WHEEL}
