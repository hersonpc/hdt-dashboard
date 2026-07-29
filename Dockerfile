# Base Alpine. A base Debian carregava 165 vulnerabilidades sem correcao
# disponivel, sendo 4 criticas e 19 altas, herdadas de perl-base e tar, que sao
# pacotes essenciais e nao removiveis. A base Alpine nao apresenta nenhuma.

FROM python:3.14-alpine AS builder

# O uv fica so nesta etapa. A etapa final recebe apenas o ambiente virtual.
RUN pip install --no-cache-dir uv

ENV UV_HTTP_TIMEOUT=120

# O --seed instala pip e setuptools dentro do venv, cerca de 7 MB, para permitir
# instalar um pacote em tempo de execucao durante uma investigacao, sem precisar
# reconstruir a imagem. O uv em si continua fora da imagem final.
RUN uv venv --seed /opt/venv
ENV VIRTUAL_ENV=/opt/venv \
    PATH="/opt/venv/bin:$PATH"

COPY requirements.lock.txt .
RUN uv pip install --no-cache -r requirements.lock.txt


FROM python:3.14-alpine

ARG VERSION=dev
ARG BUILD_DATE
ARG VCS_REF

LABEL org.opencontainers.image.title="HDT Dashboard" \
      org.opencontainers.image.description="Imagem base para os paineis Streamlit do HDT" \
      org.opencontainers.image.authors="hersonpc" \
      org.opencontainers.image.source="https://github.com/hersonpc/hdt-dashboard" \
      org.opencontainers.image.url="https://hub.docker.com/r/hersonpc/hdt-dashboard" \
      org.opencontainers.image.licenses="MIT" \
      org.opencontainers.image.version="$VERSION" \
      org.opencontainers.image.created="$BUILD_DATE" \
      org.opencontainers.image.revision="$VCS_REF"

# O musl nao oferece locales no formato do glibc. Nenhum painel chama
# locale.setlocale, entao C.UTF-8 basta para manter a leitura de arquivos
# em UTF-8. O fuso horario continua vindo do tzdata.
ENV TZ=America/Sao_Paulo \
    LANG=C.UTF-8 \
    LC_ALL=C.UTF-8

RUN apk add --no-cache tzdata \
    && cp /usr/share/zoneinfo/$TZ /etc/localtime \
    && echo $TZ > /etc/timezone

ENV PYTHONUNBUFFERED=1 \
    PYTHONDONTWRITEBYTECODE=1

COPY --from=builder /opt/venv /opt/venv
ENV VIRTUAL_ENV=/opt/venv \
    PATH="/opt/venv/bin:$PATH"

WORKDIR /app
