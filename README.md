# Usage

The Dockerfile base on https://hub.docker.com/r/seitk/pipeline-eks and include gomplate, git-crypt, helm3 and aliyun cli 3.0.14

1. docker build -t <docker_hub>/pipeline-eks:<image_tag> .

2. docker push <docker_hub>/pipeline-eks:<image_tag>

## Docker Image

willischou/pipeline-eks-gomplate-gitcrypt:0.7
