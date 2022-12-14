FROM alpine:3.13.6 AS builder

RUN apk add --update --no-cache -t \
      ca-certificates \
      curl \
      python2 \
      py-pip \
      jq \
      git \
      openssh \
      groff \
      less \
      mailcap \
      bash \
    && pip install --upgrade pip \
    && pip install --no-cache-dir awscli==1.18.185 \
    && apk del py-pip \
    && rm -rf /var/cache/apk/* /root/.cache/pip/*

# kubectl
RUN curl -LO https://dl.k8s.io/release/v1.21.0/bin/linux/amd64/kubectl \
    && install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
# gomplate
RUN curl -LO https://github.com/hairyhenderson/gomplate/releases/download/v3.6.0/gomplate_linux-amd64-slim \ 
    && chmod +x ./gomplate_linux-amd64-slim \
    && mv ./gomplate_linux-amd64-slim /usr/local/bin/gomplate
## terraform 0.13.5
RUN  curl -L -O https://releases.hashicorp.com/terraform/0.13.5/terraform_0.13.5_linux_amd64.zip &&  unzip terraform_0.13.5_linux_amd64.zip -d /usr/local/bin
# helm v3.2.4
RUN curl -LO https://get.helm.sh/helm-v3.2.4-linux-amd64.tar.gz \
    && tar -xvf helm-v3.2.4-linux-amd64.tar.gz \
    && mv ./linux-amd64/helm /usr/local/bin/helm
# helm diff
RUN helm plugin install https://github.com/databus23/helm-diff
# git crypt
RUN apk add --update alpine-sdk make libressl-dev
RUN git clone https://github.com/AGWA/git-crypt.git \
    && cd git-crypt \
    && make \
    && make install PREFIX=/usr/local
