# Dockerfile
FROM mapproxy/mapproxy:latest

# Копируем конфигурацию
COPY mapproxy.yaml /mapproxy.yaml

# Указываем основной конфиг
ENV MAPPROXY_BASE_CONFIG=/mapproxy.yaml

# Порт, который слушает MapProxy
EXPOSE 8080