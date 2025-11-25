# Etapa build
FROM python:3.12-slim AS builder

RUN pip install --no-cache-dir uv

WORKDIR /app
COPY requirements.txt .

# Instala as dependências globalmente
ENV UV_HTTP_TIMEOUT=120
RUN uv pip install --system --no-cache-dir -r requirements.txt


# Etapa final
FROM python:3.12-slim

# Variáveis de ambiente para melhor comportamento do Python
ENV PYTHONUNBUFFERED=1 \
    PYTHONDONTWRITEBYTECODE=1

# Copia as dependências da imagem de build
COPY --from=builder /usr/local /usr/local

# Cria diretório da aplicação
WORKDIR /app