# Шаг 1: Обновляем систему и устанавливаем минимальные зависимости
RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
    ca-certificates \
    wget \
    && rm -rf /var/lib/apt/lists/*

# Шаг 2: Устанавливаем PROJ напрямую из Debian Bookworm
RUN wget http://deb.debian.org/debian/pool/main/p/proj/libproj-dev_9.3.0-1_amd64.deb && \
    wget http://deb.debian.org/debian/pool/main/p/proj/libproj25_9.3.0-1_amd64.deb && \
    dpkg -i libproj25_9.3.0-1_amd64.deb libproj-dev_9.3.0-1_amd64.deb && \
    rm libproj*.deb

# Шаг 3: Устанавливаем остальные зависимости
RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
    build-essential \
    libgeos-dev \
    libgdal-dev \
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