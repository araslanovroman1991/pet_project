FROM python:3.12-slim-bullseye
# ENV PYTHONUNBUFFERED 1
ENV TZ=Europe/Moscow

# Создание и установка зависимостей в отдельном каталоге
RUN pip install poetry
WORKDIR /project
COPY . /project
# Установка зависимостей через Poetry глобально
RUN poetry config virtualenvs.create false \
    && poetry install --no-dev --no-interaction --no-ansi

RUN apt-get update \
    && apt-get install -y build-essential libpq-dev telnet netcat \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*
    
RUN sed -i 's/\r$//g' /project/start
RUN chmod +x /project/start

ENTRYPOINT ["/project/start"]