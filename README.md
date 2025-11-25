# HDT Dashboard

Docker image for dashboard infrastructure and data visualization with Python and Streamlit.

[https://hub.docker.com/r/hersonpc/hdt-dashboard](https://hub.docker.com/r/hersonpc/hdt-dashboard)

## Packages

Revisao: 2025-11-25

| Pacote | Versao | Descricao |
|--------|--------|-----------|
| streamlit | 1.51.0 | Framework principal para dashboards |
| plotly | 6.5.0 | Graficos interativos |
| altair | 5.5.0 | Graficos declarativos |
| matplotlib | 3.10.7 | Graficos estaticos |
| seaborn | 0.13.2 | Visualizacao estatistica |
| pandas | 2.3.3 | Manipulacao de dados |
| sqlalchemy | 2.0.44 | Conexao com bancos de dados |
| streamlit-extras | 0.7.8 | Componentes extras para Streamlit |
| streamlit-authenticator | 0.4.2 | Autenticacao de usuarios |
| openpyxl | 3.1.5 | Leitura/escrita de arquivos Excel |
| pyarrow | 21.0.0 | Suporte a Parquet e performance |
| wordcloud | 1.9.4 | Geracao de nuvens de palavras |
| httpx | 0.28.1 | Cliente HTTP async |

## Build

```bash
docker build -t hersonpc/hdt-dashboard:latest .
```

## Pull

```bash
docker pull hersonpc/hdt-dashboard:latest
```
