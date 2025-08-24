FROM node:alpine

LABEL version="1.0.1" \
      maintainer="guole.fun@qq.com"

# 设置时区和语言环境，解决中文乱码问题
RUN apk add --no-cache tzdata musl-locales \
    && cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime \
    && echo "Asia/Shanghai" > /etc/timezone \
    && apk del tzdata

# 基础环境变量
ENV LANG=zh_CN.UTF-8 \
    LANGUAGE=zh_CN.UTF-8 \
    LC_ALL=zh_CN.UTF-8 \
    NODE_ENV=production

ENV APP_ICP=\
    APP_COPYRIGHT=Example\
    APP_COPYRIGHT_URL=http://www.example.org\
    USE_LOG_FILE=true\
    ALLOWED_DOMAIN=["www.guole.fun","blog.guole.fun","hot.guole.fun","api.guole.fun","guole.fun","kuole-o.github.io","127.0.0.1"]

ADD initfs /tmp
RUN sh /tmp/deploy

VOLUME [ "/logs" ]
ENTRYPOINT ["/sbin/entrypoint"]

EXPOSE 80
