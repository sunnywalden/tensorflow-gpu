FROM tensorflow/tensorflow:1.12.0-gpu-py3

MAINTAINER sunnywalden@gmail.com

USER root

#RUN apt-get -y update && \
#    apt-get -y upgrade && \
#    apt-get -y dist-upgrade && \
#ADD OpenSSL_1_1_1b.tar.gz ./
#ADD Python-3.7.3.tar.xz ./

RUN apt-get install -y lsb-release && \
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
    wget https://www.python.org/ftp/python/3.7.3/Python-3.7.3.tar.xz && \
    tar -Jxf Python-3.7.3.tar.xz && \
    cd Python-3.7.3 && \
    ./configure --prefix=/usr/local/python3 --with-openssl=/usr/local/openssl && \
    make && make install && \
    sed -i 's/\/usr\/bin\/python/\/usr\/bin\/python2.7/g' /usr/bin/lsb_release && \
    rm -rf /usr/bin/python3 && rm -rf /usr/bin/pip3 && rm -rf /usr/bin/pip && \
    ln -s /usr/local/python3/bin/python3.7 /usr/bin/python3 && \
    ln -s /usr/local/python3/bin/pip3.7 /usr/bin/pip3 && \
    ln -s /usr/local/python3/bin/pip3.7 /usr/bin/pip && \
    pip3 install --upgrade pip && \
    cd .. && rm -rf Python-3.7.3*

