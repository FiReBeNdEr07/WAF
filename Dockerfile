FROM ubuntu:xenial-20210416
RUN apt-get clean && \
  rm -rf /var/lib/apt/souces.list && \
  apt-get update && \
  apt-get install -y apt-utils && \
  apt-get install -y wget && \
  wget http://nginx.org/keys/nginx_signing.key && \
  apt-key add nginx_signing.key && \
  echo "deb http://nginx.org/packages/mainline/ubuntu/ xenial nginx">> /etc/apt/sources.list.d/nginx.list && \
  echo "deb-src http://nginx.org/packages/mainline/ubuntu/ xenial nginx">> /etc/apt/sources.list.d/nginx.list && \
  apt-get update && \
  apt-get install -y nginx

RUN apt-get install -y autoconf \
  automake \
  build-essential \
  git \
  libcurl4-openssl-dev \
  libgeoip-dev \
  liblmdb-dev \
  libpcre++-dev \
  libtool \
  libxml2-dev \
  libyajl-dev \
  pkgconf \
  wget \
  zlib1g-dev

RUN git clone --depth 1 -b v3/master --single-branch https://github.com/SpiderLabs/ModSecurity && \
  cd ModSecurity && \
  git submodule init && \
  git submodule update && \
  ./build.sh && \
  ./configure && \
  make && \
  make install

RUN nginx -v | echo && \
  git clone --depth 1 https://github.com/SpiderLabs/ModSecurity-nginx.git && \
  wget http://nginx.org/download/nginx-1.13.11.tar.gz && \
  tar zxvf nginx-1.13.11.tar.gz

RUN cd nginx-1.13.11 && \
  ./configure --with-compat --add-dynamic-module=../ModSecurity-nginx && \
  make modules && \
  cp objs/ngx_http_modsecurity_module.so /etc/nginx/modules

RUN sed -i '1 i\load_module modules/ngx_http_modsecurity_module.so;' /etc/nginx/nginx.conf

RUN nginx -t

RUN wget https://github.com/SpiderLabs/owasp-modsecurity-crs/archive/v3.0.2.tar.gz && \
  tar -xzvf v3.0.2.tar.gz && \
  mv owasp-modsecurity-crs-3.0.2 /usr/local && \
  cd /usr/local/owasp-modsecurity-crs-3.0.2 && \
  cp crs-setup.conf.example crs-setup.conf

RUN mkdir /etc/nginx/modsec && \
  rm /etc/nginx/conf.d/default.conf && \
  wget https://pastebin.com/raw/Vimidh0E -O /etc/nginx/conf.d/default.conf && \
  wget https://pastebin.com/raw/jwJ7419v -O /etc/nginx/conf.d/proxy.conf && \
  wget https://pastebin.com/raw/v0WLC10a -O /etc/nginx/modsec/modsecurity.conf && \
  wget https://pastebin.com/raw/zgVZvXMk -O /etc/nginx/modsec/main.conf && \
  echo "1"

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]




