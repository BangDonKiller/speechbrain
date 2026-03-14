# ============================================================
# SpeechBrain Docker Image
# Base: PyTorch 2.1.0 + CUDA 11.8 + cuDNN 8 (for GPU training)
# If you only need CPU, replace the FROM line with:
#   FROM python:3.10-slim
# ============================================================
FROM pytorch/pytorch:2.5.1-cuda12.1-cudnn9-runtime

# ---------- 系統套件 ----------
RUN apt-get update && apt-get install -y --no-install-recommends \
    git \
    ffmpeg \
    libsndfile1 \
    && rm -rf /var/lib/apt/lists/*

# ---------- 工作目錄 ----------
WORKDIR /app

# ---------- 安裝 Python 依賴 ----------
# 先複製 requirements，利用 Docker layer cache 加速重建
COPY requirements.txt lint-requirements.txt pyproject.toml ./

RUN pip install --no-cache-dir --upgrade pip \
    && pip install --no-cache-dir -r requirements.txt

# ---------- 複製整個專案 ----------
COPY . .

# ---------- 以 editable 模式安裝 SpeechBrain 本體 ----------
RUN pip install --no-cache-dir -e .

# ---------- 預設環境變數 ----------
ENV PYTHONUNBUFFERED=1 \
    PYTHONDONTWRITEBYTECODE=1 \
    # 預設資料集掛載路徑（可透過 docker run -e 覆寫）
    DATA_FOLDER=/data/VoxCeleb2 \
    RESULTS_FOLDER=/app/results

# ---------- 開放 Jupyter / TensorBoard 常用 port ----------
EXPOSE 8888 6006

# ---------- 預設啟動指令（可在 docker run 後覆寫） ----------
CMD ["/bin/bash"]
