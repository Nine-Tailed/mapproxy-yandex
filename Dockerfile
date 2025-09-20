# Используем базовый образ Python
FROM python:3.11-slim-bookworm

# Установка системных зависимостей и Python-пакетов в ОДНОМ слое
# КРИТИЧЕСКИ ВАЖНО: не разделяем установку build-essential и GDAL
RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
    build-essential \
    libgeos-dev \
    libproj-dev \
    libgdal-dev \
    libxml2-dev \
    libxslt1-dev \
    libjpeg-dev \
    zlib1g-dev \
    && \
    \
    # Указываем пути к заголовкам GDAL
    export CPLUS_INCLUDE_PATH=/usr/include/gdal && \
    export C_INCLUDE_PATH=/usr/include/gdal && \
    \
    # Устанавливаем Python-пакеты СРАЗУ после установки системных зависимостей
    pip install --no-cache-dir \
        pyproj==3.6.1 \
        GDAL==3.6.4 \
        mapproxy==1.16.0 && \
    \
    # Удаляем компилятор ПОСЛЕ установки GDAL
    apt-get remove -y build-essential && \
    apt-get autoremove -y && \
    rm -rf /var/lib/apt/lists/*

# Настройка окружения
RUN mkdir -p /etc/mapproxy /var/cache/mapproxy
RUN chmod -R 777 /var/cache/mapproxy

# Копируем конфиг
COPY mapproxy.yaml /etc/mapproxy/

EXPOSE 8080

# Запуск с оптимизациями для Render.com
CMD ["mapproxy-util", "serve-develop", "/etc/mapproxy/mapproxy.yaml", "--port", "8080", "--threaded"]