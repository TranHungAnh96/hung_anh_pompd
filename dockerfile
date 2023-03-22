FROM tensorflow/tensorflow:2.11.0-gpu

USER root

ENV PYTHON_VERSION 3.8.16

ARG APP_DIR=/usr/src/app

RUN apt-get -y update && \
    apt-get -y upgrade && \
    apt-get -y dist-upgrade && \
    apt-get install -y lsb-release && \
    apt-get install -y wget && \
    wget https://github.com/openssl/openssl/archive/OpenSSL_1_1_1b.tar.gz && \
    tar -zxf OpenSSL_1_1_1b.tar.gz && \
    cd openssl-OpenSSL_1_1_1b && \
    ./config --prefix=/usr/local/openssl --openssldir=/usr/local/openssl shared zlib && \
    make && make install && \
    if [ -f '/usr/bin/openssl' ];then mv /usr/bin/openssl /usr/bin/openssl.bak;fi && \
    if [-d '/usr/include/openssl' ];then mv /usr/include/openssl/ /usr/include/openssl.bak;fi && \
    ln -s /usr/local/openssl/include/openssl /usr/include/openssl && \
    ln -s /usr/local/openssl/bin/openssl /usr/bin/openssl && \
    mkdir -p /usr/lib64/ && \
    ln -s /usr/local/openssl/lib/libssl.so.1.1 /usr/lib64/libssl.so.1.1 && \
    ln -s /usr/local/openssl/lib/libcrypto.so.1.1 /usr/lib64/libcrypto.so.1.1 && \
    echo 'pathmunge /usr/local/openssl/bin' > /etc/profile.d/openssl.sh && \
    echo '/usr/local/openssl/lib' > /etc/ld.so.conf.d/openssl-1.1.1b.conf && \
    ldconfig -v && \
    cd .. && rm -rf *OpenSSL_1_1_1b* && \
    apt-get install -y build-essential python-dev python-setuptools python-pip python-smbus libncursesw5-dev libgdbm-dev libc6-dev zlib1g-dev libsqlite3-dev tk-dev libffi-dev && \
    wget https://www.python.org/ftp/python/$PYTHON_VERSION/Python-$PYTHON_VERSION.tar.xz && \
    tar -Jxf Python-$PYTHON_VERSION.tar.xz && \
    cd Python-$PYTHON_VERSION && \
    ./configure --prefix=/usr/local/python3 --with-openssl=/usr/local/openssl && \
    make && make install && \
    sed -i 's/\/usr\/bin\/python/\/usr\/bin\/python2.7/g' /usr/bin/lsb_release && \
    rm -rf /usr/bin/python3 && rm -rf /usr/bin/python && rm -rf /usr/bin/pip3 && rm -rf /usr/bin/pip && \
    ln -s /usr/local/python3/bin/python3.7 /usr/bin/python3 && \
    ln -s /usr/local/python3/bin/python3.7 /usr/bin/python && \
    ln -s /usr/local/python3/bin/pip3.7 /usr/bin/pip3 && \
    ln -s /usr/local/python3/bin/pip3.7 /usr/bin/pip && \
    export PATH=/usr/local/python3/bin:$PATH && \
    pip3 install --upgrade pip && \
    cd .. && rm -rf Python-$PYTHON_VERSION* && \
    apt-get install -yq gconf-service libasound2 libatk1.0-0 libc6 libcairo2 libcups2 libdbus-1-3 libexpat1 libfontconfig1 libgcc1 libgconf-2-4 libgdk-pixbuf2.0-0 libglib2.0-0 libgtk-3-0 libnspr4 libpango-1.0-0 libpangocairo-1.0-0 libstdc++6 libx11-6 libx11-xcb1 libxcb1 libxcomposite1 libxcursor1 libxdamage1 libxext6 libxfixes3 libxi6 libxrandr2 libxrender1 libxss1 libxtst6 ca-certificates fonts-liberation libappindicator1 libnss3 lsb-release xdg-utils

WORKDIR ${APP_DIR}/POMDP-SERVICE-MIGRATION-MASTER
COPY . . 

ARG CUPY_NVCC_GENERATE_CODE

