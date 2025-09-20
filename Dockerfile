# Используем актуальный Python 3.11 на Debian 12 (Bookworm)
FROM python:3.11-slim-bookworm

# Установка минимальных зависимостей для GDAL
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    build-essential \
    libgeos-dev \
    libproj-dev \
    libgdal-dev \
    libxml2-dev \
    libxslt1-dev \
    && rm -rf /var/lib/apt/lists/*

# Установка MapProxy с фиксированной версией (стабильнее)
RUN pip install mapproxy==1.16.0

# Настройка окружения
RUN mkdir -p /etc/mapproxy /var/cache/mapproxy
RUN chmod -R 777 /var/cache/mapproxy

# Копируем конфиг
COPY mapproxy.yaml /etc/mapproxy/

EXPOSE 8080

# Запуск с увеличенным лимитом памяти (для Render.com)
CMD ["mapproxy-util", "serve-develop", "/etc/mapproxy/mapproxy.yaml", "--port", "8080", "--threaded", "--log-format", "%(levelname)s %(message)s"]