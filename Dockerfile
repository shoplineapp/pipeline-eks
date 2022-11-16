FROM alpine:3.13.6 AS builder

RUN apk add --update --no-cache -t \
      ca-certificates \
      curl \
      python2 \
      jq \
      git \
      openssh \
      unzip \
      groff \
      less \
      mailcap \
      bash \
    && curl -sL -o /etc/apk/keys/sgerrand.rsa.pub https://alpine-pkgs.sgerrand.com/sgerrand.rsa.pub \
    && curl -sL -o glibc-2.28-r0.apk https://github.com/sgerrand/alpine-pkg-glibc/releases/download/2.28-r0/glibc-2.28-r0.apk \
    && apk add glibc-2.28-r0.apk \
    && curl -sL -o glibc-bin-2.28-r0.apk https://github.com/sgerrand/alpine-pkg-glibc/releases/download/2.28-r0/glibc-bin-2.28-r0.apk \
    && apk add glibc-bin-2.28-r0.apk \
    && curl -sL -o awscliv2.zip https://awscli.amazonaws.com/awscli-exe-linux-x86_64-2.7.33.zip \
    && unzip awscliv2.zip \
    && ./aws/install \
    && rm -Rf aws/ awscliv2.zip glibc-2.28-r0.apk glibc-bin-2.28-r0.apk \
    && rm -rf /var/cache/apk/* /root/.cache/pip/* \
    && aws --version

# kubectl
RUN curl -LO https://dl.k8s.io/release/v1.21.0/bin/linux/amd64/kubectl \
    && install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
# argo rollout plugin
RUN curl -LO https://github.com/argoproj/argo-rollouts/releases/latest/download/kubectl-argo-rollouts-linux-amd64 \
    && chmod +x ./kubectl-argo-rollouts-linux-amd64 \
    && mv ./kubectl-argo-rollouts-linux-amd64 /usr/local/bin/kubectl-argo-rollouts
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
RUN apk add --update alpine-sdk make libressl-dev
RUN git clone https://github.com/AGWA/git-crypt.git \
    && cd git-crypt \
    && make \
    && make install PREFIX=/usr/local
