FROM python:3.11-alpine3.18
LABEL maintainer="carlosedu.vianalima@gmail.com"

# Essa variável de ambiente é usada para evitar que o Python escreva arquivos de byte-code (.pyc) em disco
# 1 = Não, 0 = Sim
ENV PYTHONDONTWRITEBYTECODE 1

# Essa variável de ambiente é usada para evitar que o Python armazene o histórico de comandos em disco
# 1 = Não, 0 = Sim
ENV PYTHONUNBUFFERED 1

# Copia as pastas para dentro do Container
COPY ./djangoapp /djangoapp
COPY ./scripts /scripts

# Entra na pasta '/djangoapp' 
WORKDIR /djangoapp

# A porta 8000 estará disponivel para acesso
EXPOSE 8000

RUN python -m venv /venv && \
    /venv/bin/pip install --upgrade pip && \
    /venv/bin/pip install -r /djangoapp/requirements.txt && \
    adduser --disabled-password --no-create-home duser && \
    mkdir -p /data/web/static && \
    mkdir -p /data/web/media && \
    chown -R duser:duser /venv && \
    chown -R duser:duser /data/web/static && \
    chown -R duser:duser /data/web/media && \
    chmod -R 755 /data/web/static && \
    chmod -R 755 /data/web/media && \
    chmod -R +x /scripts

# Adiciona a pasta scripts e venv/bin no $PATH do Container
ENV PATH="/scripts:/venv/bin:$PATH"

# Muda o usuário para duser
USER duser

# Executa o arquivo scripts/commands.sh
CMD ["commands.sh"]