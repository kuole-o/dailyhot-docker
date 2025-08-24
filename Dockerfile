FROM node:alpine

LABEL version="1.0.7" \
      maintainer="guole.fun@qq.com"

# 设置时区
RUN apk add --no-cache tzdata \
    && cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime \
    && echo "Asia/Shanghai" > /etc/timezone \
    && apk del tzdata

# 启用内存过量使用（解决 Redis 警告）
RUN echo "vm.overcommit_memory = 1" >> /etc/sysctl.conf

# 环境变量
ENV LANG=zh_CN.UTF-8 \
    LANGUAGE=zh_CN.UTF-8 \
    LC_ALL=zh_CN.UTF-8 \
#     APP_ICP=\
#     APP_COPYRIGHT=Example\
#     APP_COPYRIGHT_URL=http://www.example.org\
    USE_LOG_FILE=true\
    ALLOWED_DOMAIN='["www.guole.fun","blog.guole.fun","hot.guole.fun","api.guole.fun","guole.fun","kuole-o.github.io","127.0.0.1"]'

ADD initfs /tmp
RUN sh /tmp/deploy

VOLUME [ "/logs" ]
ENTRYPOINT ["/sbin/entrypoint"]

EXPOSE 80
