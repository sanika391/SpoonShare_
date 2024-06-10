# Build Stage
FROM ubuntu:20.04 AS build

RUN apt-get update && apt-get install -y curl git unzip xz-utils libglu1-mesa

RUN git clone https://github.com/flutter/flutter.git /opt/flutter
ENV PATH="/opt/flutter/bin:${PATH}"

RUN flutter config --enable-web

COPY . /app
WORKDIR /app

RUN flutter pub get

RUN flutter build web

# Release Stage
FROM nginx:stable-alpine AS release

COPY --from=build /app/build/web /usr/share/nginx/html

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]