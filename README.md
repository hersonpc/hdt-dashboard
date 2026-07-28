# HDT Dashboard

Imagem Docker base para os painéis Streamlit do HDT. Vinte containers em produção
usam esta imagem, então uma mudança aqui alcança todos eles de uma vez.

[https://hub.docker.com/r/hersonpc/hdt-dashboard](https://hub.docker.com/r/hersonpc/hdt-dashboard)

## Base

| Item | Versão |
|------|--------|
| Imagem base | `python:3.14-slim` |
| Python | 3.14 |
| Timezone | America/Sao_Paulo |
| Locale | pt_BR.UTF-8 |

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
| pytz | 2026.3 | Timezones. Deixou de vir junto com o pandas 3.0, por isso é declarado |

A lista completa, com as 77 dependências resolvidas e suas versões exatas, está em
`requirements.lock.txt`.

## Como as versões são fixadas

O `requirements.txt` declara a intenção, com os pacotes que o projeto usa de fato.
O `requirements.lock.txt` guarda a resolução completa com versões exatas, e é ele
que o `Dockerfile` instala. Assim, duas construções da mesma revisão produzem a
mesma imagem, e subir de versão passa a ser uma decisão com data marcada.

Para atualizar as versões:

```bash
make lock                        # resolve tudo de novo a partir do requirements.txt
git diff requirements.lock.txt   # revise o que mudou antes de aceitar
make build                       # constrói com tag datada
```

## Construir e publicar

O `make build` gera uma tag datada, por exemplo `2026-07-28-py314`, e **não altera
o `latest`**. Mover o `latest` é um passo separado e explícito, para que nenhuma
construção troque a imagem de produção sem querer.

```bash
make build      # constrói hersonpc/hdt-dashboard:<data>-py314
make promote    # aponta o latest para essa tag
make push       # envia a tag datada e o latest para o Docker Hub
make img        # lista as imagens locais
```

Para construir uma tag específica:

```bash
make build TAG=2026-08-15-py314
```

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

## Voltar atrás

As imagens que já rodaram em produção ficam marcadas com o prefixo `prod-`, então
é possível retornar a qualquer uma delas trocando a tag no `docker-compose.yml` e
subindo de novo:

```bash
docker images hersonpc/hdt-dashboard   # lista as tags disponíveis
```

## Restrição conhecida

O `numpy` a partir da versão 2.4.0 é compilado exigindo o conjunto de instruções
x86-64-v2 (SSE3, SSSE3, SSE4.1, SSE4.2, POPCNT). Máquinas virtuais configuradas
com o modelo de CPU genérico `kvm64` não expõem essas instruções, e nesse caso o
`import numpy` falha em tempo de execução.

Se a imagem for usada num host assim, a saída é ajustar o modelo de CPU da VM,
por exemplo para `x86-64-v2-AES` no Proxmox. Como alternativa, é possível fixar
`numpy>=2.3.5,<2.4` no `requirements.txt` e refazer o lock.
