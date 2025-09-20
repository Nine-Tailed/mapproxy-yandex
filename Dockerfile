# Dockerfile
FROM ghcr.io/mapproxy/mapproxy:latest

# Настройка кэша
RUN mkdir -p /var/cache/mapproxy && \
    chmod -R 777 /var/cache/mapproxy

# Копируем конфиг
COPY mapproxy.yaml /mapproxy.yaml

# Переменные окружения
ENV MAPPROXY_CACHE_DIR=/var/cache/mapproxy
ENV PROJ_NETWORK=OFF

EXPOSE 8080

# Запуск
CMD ["mapproxy-util", "serve-develop", "/mapproxy.yaml", "--port", "8080"]