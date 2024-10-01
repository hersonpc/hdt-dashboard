FROM python:3.12-slim

# Instalar dependências do sistema necessárias para compilar pacotes nativos
RUN apt-get update && apt-get install -y \
    build-essential \
    cmake \
    patchelf \
    git \
    libssl-dev \
    libffi-dev \
    python3-dev \
    ninja-build \
    && rm -rf /var/lib/apt/lists/*

# Definir variáveis de ambiente
ENV PYTHONUNBUFFERED=1
ENV PYTHONDONTWRITEBYTECODE=1

# Definir o diretório de trabalho
WORKDIR /app

# Copiar o arquivo requirements.txt
COPY requirements.txt .

# Instalar dependências Python
RUN pip install --no-cache-dir -r requirements.txt