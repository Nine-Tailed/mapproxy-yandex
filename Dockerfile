# Используем образ с предустановленными геопространственными библиотеками
FROM python:3.11-slim-bookworm

# Установка системных зависимостей
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    build-essential \
    libgeos-dev \
    libproj-dev=9.3.0-1 \
    libgdal-dev=3.6.4+dfsg-1 \
    libxml2-dev \
    libxslt1-dev \
    libjpeg-dev \
    zlib1g-dev \
    && rm -rf /var/lib/apt/lists/*

# Установка ПИТОНОВСКИХ зависимостей в правильном порядке
# 1. Сначала устанавливаем pyproj с привязкой к системному PROJ
# 2. Затем устанавливаем GDAL
# 3. И только потом MapProxy
RUN pip install --no-cache-dir \
    pyproj==3.6.1 \
    GDAL==3.6.4 \
    mapproxy==1.16.0

# Настройка окружения
RUN mkdir -p /etc/mapproxy /var/cache/mapproxy
RUN chmod -R 777 /var/cache/mapproxy

# Копируем конфиг
COPY mapproxy.yaml /etc/mapproxy/

EXPOSE 8080

# Запуск с правильными настройками
CMD ["mapproxy-util", "serve-develop", "/etc/mapproxy/mapproxy.yaml", "--port", "8080", "--threaded"]