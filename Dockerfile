# Используем базовый образ
FROM python:3.11-slim-bookworm

# Установка минимальных зависимостей
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    libgeos-dev libproj-dev libgdal-dev && \
    rm -rf /var/lib/apt/lists/*

# Установка MapProxy
RUN pip install pyproj==3.6.1 GDAL==3.6.4 mapproxy==1.16.0

# Настройка директорий
RUN mkdir -p /etc/mapproxy /var/cache/mapproxy
RUN chmod -R 777 /var/cache/mapproxy

# Копируем конфиг
COPY mapproxy.yaml /etc/mapproxy/

EXPOSE 8080

# Запуск
CMD ["mapproxy-util", "serve-develop", "/etc/mapproxy/mapproxy.yaml", "--port", "8080"]