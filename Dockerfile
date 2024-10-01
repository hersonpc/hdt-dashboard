FROM python:3.12-slim

ENV PYTHONUNBUFFERED 1
ENV PYTHONDONTWRITEBYTECODE 1

WORKDIR /app

RUN pip install --no-cache-dir streamlit \
	pandas \
	pyarrow \
	rich \
	plotly \
	mathplotlib \
	seaborn \
	Unidecode \
	httpx \
	loguru
