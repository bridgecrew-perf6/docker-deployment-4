FROM ubuntu:latest

ENV DEBIAN_FRONTEND "noninteractive"
ENV NVM_DIR         "/usr/local/nvm"
ENV NODE_VERSION    "16.13.2"
ENV NODE_PATH       $NVM_DIR/versions/node/v$NODE_VERSION/lib/node_modules
ENV PATH            $NVM_DIR/versions/node/v$NODE_VERSION/bin:$PATH
ENV TFENV_CURL_OUTPUT 0

SHELL ["/bin/bash", "-c"]

RUN apt update && apt install -y --no-install-recommends curl gnupg software-properties-common && \
    curl -fsSL https://apt.releases.hashicorp.com/gpg | apt-key add - &&\
    apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main" &&\
    apt update && apt upgrade -y && apt install -y --no-install-recommends \
        git \
        jq \
        packer \
        php7.4 \
        php7.4-cli \
        php7.4-common \
        php7.4-json \
        php7.4-mbstring \
        python-is-python3 \
        python3 \
        python3-pip \
        unzip \
        wget \
        zip \
    && apt autoremove &&\
    apt autoclean &&\
    rm -rf /var/lib/apt/lists/* &&\
    php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" &&\
    php composer-setup.php --install-dir=/usr/local/bin --filename=composer &&\
    php --version && composer --version &&\
    curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" &&\
    unzip awscliv2.zip &&\
    ./aws/install -i /usr/local/aws-cli -b /usr/local/bin &&\
    which aws && aws --version &&\
    git clone https://github.com/tfutils/tfenv.git /opt/tfenv &&\
    ln -s /opt/tfenv/bin/* /usr/local/bin &&\
    mkdir -p ${NVM_DIR} &&\
    curl https://raw.githubusercontent.com/creationix/nvm/master/install.sh | bash &&\
    . $NVM_DIR/nvm.sh &&\
    nvm install $NODE_VERSION &&\
    nvm alias default $NODE_VERSION &&\
    nvm use default &&\
    npm config set color false -g &&\
    npm config set color false -g &&\
    npm i -g serverless yarn &&\
    npm cache clean --force
