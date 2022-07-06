FROM python:3.9-alpine3.13
LABEL maintainer="RockSolidOP"
# When running apps in python docker print any o/p to console
ENV PYTHONUNBUFFERED 1

COPY ./requirements.txt /requirements.txt
COPY ./app /app

# moves the base directory to provided
WORKDIR /app

# Port to run django dev server
EXPOSE 8000

# Multiple runs will create more containers all commands can be added in a single run like below

RUN python -m venv /py && \
    /py/bin/pip install --upgrade pip && \
    apk add --update --no-cache postgresql-client && \
    apk add --update --no-cache --virtual .tmp-deps \
        build-base postgresql-dev musl-dev && \
    /py/bin/pip install -r /requirements.txt && \
    apk del .tmp-deps && \
    adduser --disabled-password --no-create-home app && \
    mkdir -p /vol/web/static && \
    mkdir -p /vol/web/media && \
    chown -R app:app /vol && \
    chmod -R 755 /vol    

ENV PATH="/py/bin:$PATH"
#creates a service account for user

USER app