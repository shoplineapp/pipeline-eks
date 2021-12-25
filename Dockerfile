FROM ruby:2.5.7 AS builder

RUN apt-get update
RUN apt-get install -y \
      ca-certificates \
      curl \
      python2 \
      python-pip \
      jq \
      git \
      groff \
      less \
      bash \
    && pip install --upgrade pip \
    && pip install --no-cache-dir awscli==1.16.270 \
    && rm -rf /var/cache/apt/* /root/.cache/pip/*

# kubectl
RUN curl -LO https://dl.k8s.io/release/v1.21.0/bin/linux/amd64/kubectl \
    && install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
# gomplate
RUN curl -LO https://github.com/hairyhenderson/gomplate/releases/download/v3.6.0/gomplate_linux-amd64-slim \
    && chmod +x ./gomplate_linux-amd64-slim \
    && mv ./gomplate_linux-amd64-slim /usr/local/bin/gomplate
# helm v3.2.4
RUN curl -LO https://get.helm.sh/helm-v3.2.4-linux-amd64.tar.gz \
    && tar -xvf helm-v3.2.4-linux-amd64.tar.gz \
    && mv ./linux-amd64/helm /usr/local/bin/helm
# helm diff
RUN helm plugin install https://github.com/databus23/helm-diff
# git crypt
RUN git clone https://github.com/AGWA/git-crypt.git \
    && cd git-crypt \
    && make \
    && make install PREFIX=/usr/local
