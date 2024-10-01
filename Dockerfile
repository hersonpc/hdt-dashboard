FROM python:3.12-slim

# Definir variáveis de ambiente
ENV PYTHONUNBUFFERED=1
ENV PYTHONDONTWRITEBYTECODE=1

# Definir o diretório de trabalho
WORKDIR /app

# Copiar o arquivo requirements.txt
COPY requirements.txt .

# Instalar dependências Python
RUN pip install --no-cache-dir -r requirements.txt
