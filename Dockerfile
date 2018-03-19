# Pull base image
FROM alpine:3.6

# Base packages
# Build dependencies
RUN ln -s /lib /lib64 \
    && \
        apk --upgrade add --no-cache \
            bash \
            sudo \
            curl \
            zip \
            jq \
            xmlsec \
            yaml \
            libc6-compat \
            python3 \
            libxml2 \
            py-lxml \
            py-pip \
            openssl \
            ca-certificates \
            openssh-client \
            rsync \
            git \
            bind-tools \
            python-dev \
    && \
        apk --upgrade add --no-cache --virtual \
            build-dependencies \
            build-base \
            python3-dev \
            libffi-dev \
            openssl-dev \
            linux-headers \
            libxml2-dev

# FIAAS installation
ADD requirements.txt /opt/
RUN pip install --upgrade --no-cache-dir -r /opt/requirements.txt
RUN pip3 install --upgrade --no-cache-dir -r /opt/requirements.txt

RUN apk del \
        build-dependencies \
        build-base \
        python3-dev \
        libffi-dev \
        openssl-dev \
        linux-headers \
        libxml2-dev \
    && \
        rm -rf /var/cache/apk/*

# install resource assets
COPY assets/ /opt/resource/
