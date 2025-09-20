# Dockerfile
FROM python:3.9-slim-bookworm

# Обновляем источники пакетов для работы с архивными репозиториями
RUN sed -i 's|deb.debian.org|archive.debian.org|g' /etc/apt/sources.list && \
    sed -i '/security/d' /etc/apt/sources.list && \
    echo "Acquire::Check-Valid-Until false;" > /etc/apt/apt.conf.d/99no-check-valid-until

# Установка зависимостей
RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
    build-essential \
    libxml2-dev \
    libxslt1-dev \
    libffi-dev \
    libssl-dev \
    libgeos-dev \
    libproj-dev \
    gdal-bin \
    libgdal-dev \
    libjpeg-dev \
    zlib1g-dev \
    && rm -rf /var/lib/apt/lists/*

# Установка MapProxy
RUN pip install mapproxy

# Настройка директорий
RUN mkdir -p /etc/mapproxy /var/cache/mapproxy

# Копируем конфиг
COPY mapproxy.yaml /etc/mapproxy/

# Права на кэш
RUN chmod -R 777 /var/cache/mapproxy

EXPOSE 8080

CMD ["mapproxy-util", "serve-develop", "/etc/mapproxy/mapproxy.yaml", "--port", "8080"]