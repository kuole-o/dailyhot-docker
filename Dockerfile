FROM node:alpine

LABEL version="1.0.10" \
      maintainer="guole.fun@qq.com"

# 设置时区
RUN apk add --no-cache tzdata \
    && cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime \
    && echo "Asia/Shanghai" > /etc/timezone \
    && apk del tzdata

# 启用内存过量使用（解决 Redis 警告）
RUN echo "vm.overcommit_memory = 1" >> /etc/sysctl.conf

# 复制package.json并提取版本号
COPY package.json /tmp/package.json
RUN APP_VERSION=$(node -p "require('/tmp/package.json').version") && \
    echo "export app_version=$APP_VERSION" > /tmp/app_version

# 环境变量
ENV LANG=en_US.UTF-8 \
    LANGUAGE=en_US.UTF-8 \
    LC_ALL=en_US.UTF-8 \
#     APP_ICP=\
#     APP_COPYRIGHT=Example\
#     APP_COPYRIGHT_URL=http://www.example.org\
    USE_LOG_FILE=true \
    ALLOWED_DOMAIN='["www.guole.fun","blog.guole.fun","hot.guole.fun","api.guole.fun","guole.fun","kuole-o.github.io","127.0.0.1"]' \
    GAODE_KEY='' \
    UMAMI_USER_NAME='admin' \
    UMAMI_USER_PASSWORD='password' \
    UMAMI_TOKEN='' \
    LEANCLOUD_APPID='' \
    LEANCLOUD_APPKEY=''


ADD initfs /tmp
RUN sh /tmp/deploy

# 设置app_version环境变量
RUN cat /tmp/app_version >> /etc/profile && \
    echo "app_version=$(node -p "require('/tmp/package.json').version")" >> /etc/environment

VOLUME [ "/logs" ]
ENTRYPOINT ["/sbin/entrypoint"]

EXPOSE 80
