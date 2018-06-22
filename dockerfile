FROM debian:9-slim
ADD . /usr/local/src/
WORKDIR /usr/local/src/
RUN rm -rf /etc/apt/sources.list \
    && cp ./sources.list /etc/apt/sources.list \
    && set -x \ 
    && apt-get update \
    && apt-get install --no-install-recommends --no-install-suggests -y gnupg1 apt-transport-https ca-certificates libpcre3-dev libssl-dev openssl zlib1g-dev gcc make \
    && mkdir -p /var/tmp/nginx/client/ && mkdir /var/tmp/nginx/proxy/ && mkdir /var/tmp/nginx/fcgi/ && mkdir /var/tmp/nginx/uwsgi && mkdir /var/tmp/nginx/scgi \
    && cd nginx-1.14.0 \
    && ./configure --prefix=/usr --sbin-path=/usr/sbin/nginx --conf-path=/etc/nginx/nginx.conf --error-log-path=/var/log/nginx/error.log \
       --http-log-path=/var/log/nginx/access.log --pid-path=/var/run/nginx/nginx.pid --lock-path=/var/lock/nginx.lock --user=root --group=root \
       --with-http_ssl_module --with-http_flv_module --with-http_stub_status_module --with-http_gzip_static_module --http-client-body-temp-path=/var/tmp/nginx/client/ \
       --http-proxy-temp-path=/var/tmp/nginx/proxy/ --http-fastcgi-temp-path=/var/tmp/nginx/fcgi/ --http-uwsgi-temp-path=/var/tmp/nginx/uwsgi --http-scgi-temp-path=/var/tmp/nginx/scgi \
       --with-pcre --with-debug --add-module=/usr/local/src/nginx-mogilefs-module-1.0.4 \
    && cp -f ../Makefile ./objs/ \
    && make && make install \
    && apt-get remove --purge --auto-remove -y gnupg1 gcc make && rm -rf /var/lib/apt/lists/* 
RUN ln -sf /dev/stdout /var/log/nginx/access.log \
	&& ln -sf /dev/stderr /var/log/nginx/error.log
CMD ["nginx","-g","daemon off;"]
