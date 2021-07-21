FROM ubuntu:20.04

ENV TERRAFORM_VERSION=1.0.1

RUN apt-get -y update
RUN apt-get -y install \
    unzip \
    curl \
    ca-certificates \
    apt-transport-https \
    lsb-release \
    gnupg \
    git

RUN curl -O https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip && \
    unzip terraform_${TERRAFORM_VERSION}_linux_amd64.zip -d /usr/local/bin/ && \
    rm -f terraform_${TERRAFORM_VERSION}_linux_amd64.zip && \
    terraform version

### AZ CLI
RUN curl -sL https://packages.microsoft.com/keys/microsoft.asc | \
    gpg --dearmor | \
    tee /etc/apt/trusted.gpg.d/microsoft.gpg > /dev/null
RUN AZ_REPO=$(lsb_release -cs) && \
    echo "deb [arch=amd64] https://packages.microsoft.com/repos/azure-cli/ $AZ_REPO main" | \
    tee /etc/apt/sources.list.d/azure-cli.list
RUN apt-get -y update
RUN apt-get -y install azure-cli

### AZ FUNC
RUN echo "deb [arch=amd64] https://packages.microsoft.com/repos/microsoft-ubuntu-$(lsb_release -cs)-prod $(lsb_release -cs) main" \
    > /etc/apt/sources.list.d/dotnetdev.list
RUN apt-get -y update
RUN apt-get -y install \
    python3-venv \
    azure-functions-core-tools-3

# Without this env variable, `func` fails to run any command.
# More details: https://github.com/Azure/azure-functions-core-tools/issues/2554
ENV DOTNET_SYSTEM_GLOBALIZATION_INVARIANT=true