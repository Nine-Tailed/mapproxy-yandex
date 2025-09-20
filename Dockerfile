# Используем образ с предустановленными геозависимостями
FROM python:3.11-slim-bookworm

# Шаг 1: Устанавливаем ТОЛЬКО необходимые системные зависимости
RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
    libgeos-dev \
    libproj-dev \
    libgdal-dev=3.6.4+dfsg-1 \
    && rm -rf /var/lib/apt/lists/*

# Шаг 2: Устанавливаем Python-пакеты СРАЗУ ПОСЛЕ установки системных зависимостей
# КРИТИЧЕСКИ ВАЖНО: не удаляем build-essential до установки GDAL!
RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends build-essential && \
    \
    # Указываем пути к заголовочным файлам GDAL
    export CPLUS_INCLUDE_PATH=/usr/include/gdal && \
    export C_INCLUDE_PATH=/usr/include/gdal && \
    \
    # Устанавливаем пакеты в правильном порядке
    pip install --no-cache-dir \
        pyproj==3.6.1 \
        "GDAL==3.6.4" \
        mapproxy==1.16.0 && \
    \
    # Удаляем компилятор ПОСЛЕ установки GDAL
    apt-get remove -y build-essential && \
    apt-get autoremove -y && \
    rm -rf /var/lib/apt/lists/*

# Шаг 3: Настройка окружения
RUN mkdir -p /etc/mapproxy /var/cache/mapproxy
RUN chmod -R 777 /var/cache/mapproxy

# Копируем конфиг
COPY mapproxy.yaml /etc/mapproxy/

EXPOSE 8080

# Запуск с оптимизациями для Render.com
CMD ["mapproxy-util", "serve-develop", "/etc/mapproxy/mapproxy.yaml", "--port", "8080", "--threaded"]