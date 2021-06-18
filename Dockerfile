FROM seitk/pipeline-eks AS builder
# gomplate
RUN curl -LO https://github.com/hairyhenderson/gomplate/releases/download/v3.6.0/gomplate_linux-amd64-slim \ 
    && chmod +x ./gomplate_linux-amd64-slim \
    && mv ./gomplate_linux-amd64-slim /usr/local/bin/gomplate
# helm v3.2.4
RUN curl -LO https://get.helm.sh/helm-v3.2.4-linux-amd64.tar.gz \
    && tar -xvf helm-v3.2.4-linux-amd64.tar.gz \
    && mv ./linux-amd64/helm /usr/local/bin/helm3
# git crypt
RUN apk add --update alpine-sdk make libressl-dev
RUN git clone https://github.com/AGWA/git-crypt.git \
    && cd git-crypt \
    && make \
    && make install PREFIX=/usr/local
# aliyun cli v3.0.14
RUN curl -L -O https://github.com/aliyun/aliyun-cli/releases/download/v3.0.14/aliyun-cli-linux-amd64.tar.gz \
    && tar zxvf aliyun-cli-linux-amd64.tar.gz \
    && sudo mv aliyun /usr/local/bin/aliyun
# # terraform 0.13.2
RUN curl -L -O https://releases.hashicorp.com/terraform/0.13.2/terraform_0.13.2_linux_amd64.zip \
    &&  unzip terraform_0.13.2_linux_amd64.zip -d /usr/local/bin
FROM seitk/pipeline-eks
# git crypt require duplicity (gpg)
RUN apk add duplicity zip
COPY --from=builder /usr/local/bin/gomplate /usr/local/bin/gomplate
COPY --from=builder /usr/local/bin/helm3 /usr/local/bin/helm3
COPY --from=builder /usr/local/bin/git-crypt /usr/local/bin/git-crypt
COPY --from=builder /usr/local/bin/aliyun /usr/local/bin/aliyun
COPY --from=builder /usr/local/bin/terraform /usr/local/bin/terraform
# helm diff
RUN helm3 plugin install https://github.com/databus23/helm-diff
