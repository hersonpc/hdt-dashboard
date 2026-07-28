# Etapa build
FROM python:3.14-slim AS builder

# Atualiza pip antes de instalar pacotes
RUN pip install --no-cache-dir --upgrade pip uv

WORKDIR /app

# Instala a partir do arquivo de versoes fixadas (requirements.lock.txt).
# Para atualizar as versoes: make lock, revisar o diff, make build.
COPY requirements.lock.txt .

ENV UV_HTTP_TIMEOUT=120
RUN uv pip install --system --no-cache-dir -r requirements.lock.txt


# Etapa final
FROM python:3.14-slim

# Metadata
LABEL maintainer="hersonpc" \
      version="2.0" \
      description="HDT Dashboard - Streamlit infrastructure"

# Timezone e Locale
ENV TZ=America/Sao_Paulo \
    LANG=pt_BR.UTF-8 \
    LC_ALL=pt_BR.UTF-8

RUN apt-get update && apt-get install -y --no-install-recommends \
    tzdata \
    locales \
    && ln -snf /usr/share/zoneinfo/$TZ /etc/localtime \
    && echo $TZ > /etc/timezone \
    && sed -i '/pt_BR.UTF-8/s/^# //g' /etc/locale.gen \
    && locale-gen \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Variaveis de ambiente para Python
ENV PYTHONUNBUFFERED=1 \
    PYTHONDONTWRITEBYTECODE=1

# Copia as dependencias da imagem de build
COPY --from=builder /usr/local /usr/local

# Cria diretorio da aplicacao
WORKDIR /app
