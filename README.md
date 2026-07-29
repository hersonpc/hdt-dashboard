# HDT Dashboard

Imagem Docker base para os painéis Streamlit do HDT. Vinte containers em produção usam
esta imagem, então uma mudança aqui alcança todos eles de uma vez.

[https://hub.docker.com/r/hersonpc/hdt-dashboard](https://hub.docker.com/r/hersonpc/hdt-dashboard)

## Base

| Item | Versão |
|------|--------|
| Imagem base | `python:3.14-alpine` |
| Python | 3.14 |
| Timezone | America/Sao_Paulo |
| Locale | C.UTF-8, com datas em português via Babel |

A base é Alpine porque a variante Debian carregava 165 vulnerabilidades sem correção
disponível, sendo 4 críticas e 19 altas, herdadas de `perl-base` e `tar`, pacotes
essenciais que não podem ser removidos.

## Pacotes

Revisão: 2026-07-28

| Pacote | Versão | Descrição |
|--------|--------|-----------|
| streamlit | 1.60.0 | Framework principal para dashboards |
| pandas | 3.0.5 | Manipulação de dados |
| numpy | 2.5.1 | Computação numérica |
| pyarrow | 24.0.0 | Suporte a Parquet e performance |
| plotly | 6.9.0 | Gráficos interativos |
| altair | 6.2.2 | Gráficos declarativos |
| matplotlib | 3.11.1 | Gráficos estáticos |
| seaborn | 0.13.2 | Visualização estatística |
| sqlalchemy | 2.0.51 | Conexão com bancos de dados |
| redis | 8.0.1 | Cliente Redis para cache |
| streamlit-extras | 1.6.0 | Componentes extras para Streamlit |
| streamlit-authenticator | 0.4.2 | Autenticação de usuários |
| openpyxl | 3.1.5 | Leitura e escrita de arquivos Excel |
| wordcloud | 1.9.6 | Geração de nuvens de palavras |
| httpx | 0.28.1 | Cliente HTTP async |
| babel | 2.18.0 | Datas e números em português |
| pytz | 2026.3 | Timezones |

A lista completa, com as 78 dependências resolvidas e suas versões exatas, está em
`requirements.lock.txt`.

## Datas em português

O locale do sistema não traduz nomes de mês em Python, porque o interpretador não chama
`setlocale` por conta própria. Use o Babel, que formata pelo próprio Python e independe
do sistema operacional:

```python
from babel.dates import format_date
format_date(data, "d 'de' MMMM 'de' y", locale="pt_BR")   # 28 de julho de 2026
format_date(data, "EEEE", locale="pt_BR")                 # terça-feira
```

## Como as versões são fixadas

O `requirements.txt` declara a intenção, com os pacotes que o projeto usa de fato. O
`requirements.lock.txt` guarda a resolução completa com versões exatas, e é ele que o
`Dockerfile` instala. Assim, duas construções da mesma revisão produzem a mesma imagem.

## Construir e publicar

```bash
make lock       # regenera requirements.lock.txt a partir do requirements.txt
make build      # constrói hersonpc/hdt-dashboard:latest
make push       # envia para o Docker Hub
make img        # lista as imagens locais
```

Só existe a tag `latest`. Um push para o `main` faz o GitHub Actions construir, verificar
que a imagem sobe e importa os pacotes compilados, e publicar sozinho, então `make push`
é necessário apenas para publicar direto da máquina, sem passar pelo repositório.

## Usar

```bash
docker pull hersonpc/hdt-dashboard:latest
```

Nos `docker-compose.yml` dos painéis:

```yaml
services:
  dashboard:
    image: hersonpc/hdt-dashboard:latest
    volumes:
      - .:/app
    command: streamlit run streamlit_app.py --server.port 8501 --server.address 0.0.0.0
```
