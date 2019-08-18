ARG base_image=jenkins/jenkins:2.180-alpine
# ARG base_image=jenkins/jenkins:2.189-alpine

FROM ${base_image}

# ENV DOCKER_PACKAGE_VERSION="19.03.1"
ENV DOCKER_PACKAGE_VERSION="18.09.8-r0"
ENV KUBECTL_VERSION="1.11.5"

ENV JAVA_OPTS="-Djenkins.install.runSetupWizard=false"

USER root

RUN apk update \
    && apk add docker=${DOCKER_PACKAGE_VERSION} gettext --update-cache \
    && curl -Lo /usr/bin/kubectl https://storage.googleapis.com/kubernetes-release/release/v{$KUBECTL_VERSION}/bin/linux/amd64/kubectl \
    && chmod +x /usr/bin/kubectl

# COPY jenkins/ /usr/share/jenkins/

# RUN /usr/local/bin/install-plugins.sh < /usr/share/jenkins/ref/plugins.txt