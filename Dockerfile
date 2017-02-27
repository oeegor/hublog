FROM phusion/baseimage:0.9.19

ENV HOME=/root \
    APP_ROOT=/home/ubuntu/hublog \
    APP_USER=www-data


CMD ["/sbin/my_init"]
WORKDIR $APP_ROOT

RUN set -xe \
    && echo 'v3' \
    && export DEBIAN_FRONTEND=noninteractive \
    && sed -i -e 's/archive.ubuntu.com/mirror.yandex.ru/' /etc/apt/sources.list \
    && apt-get update -q \
    # && apt-get upgrade -qqy \
    && apt-get install -qy --no-install-recommends \
        wget \
        nginx-light \
        zsh \

    && wget "https://github.com/spf13/hugo/releases/download/v0.19/hugo_0.19-64bit.deb" \
    && dpkg -i *.deb \
    && locale-gen en_US.UTF-8 ru_RU.UTF-8 \

    # cleanup
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
    && rm /var/log/alternatives.log /var/log/apt/history.log /var/log/apt/term.log /var/log/dpkg.log

COPY etc/ /etc/
COPY hugo $APP_ROOT

RUN chmod 644 /etc/logrotate.d/* \
    && mkdir -p /var/log/nginx \
    && chown -R $APP_USER. $APP_ROOT /var/log/nginx $APP_ROOT \
    && nginx -t \
    && ls && hugo