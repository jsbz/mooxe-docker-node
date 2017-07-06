FROM mooxe/base:dev

MAINTAINER FooTearth "footearth@gmail.com"

WORKDIR /root

# update
RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get autoremove -y

RUN apt-get install -y make g++

# nvm
RUN curl https://raw.githubusercontent.com/creationix/nvm/v0.31.1/install.sh | bash && \

    # nvm - zsh support
    echo ". ~/.nvm/nvm.sh" >> ~/.zshrc && \

    # nvm - fish support
    git clone https://github.com/passcod/nvm-fish-wrapper.git ~/.config/fish/nvm-wrapper && \
    echo ". ~/.config/fish/nvm-wrapper/nvm.fish" >> ~/.config/fish/config.fish

ENV NODE_VERSION 8.1.3

# npm
RUN cp -f ~/.nvm/nvm.sh ~/.nvm/nvm-tmp.sh && \
    echo "nvm install v$NODE_VERSION" >> ~/.nvm/nvm-tmp.sh && \
    echo "nvm alias 8 $NODE_VERSION" >> ~/.nvm/nvm-tmp.sh && \
    echo "nvm alias default 8" >> ~/.nvm/nvm-tmp.sh && \
    echo "nvm use default" >> ~/.nvm/nvm-tmp.sh && \
    sh ~/.nvm/nvm-tmp.sh && \
    rm ~/.nvm/nvm-tmp.sh && \

    cp /etc/profile /etc/profile.bak && \
    echo '. /root/.nvm/nvm.sh' >> /etc/profile

RUN \
  bash -lc "curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -" && \
  bash -lc "echo 'deb https://dl.yarnpkg.com/debian/ stable main' | tee /etc/apt/sources.list.d/yarn.list" && \
  apt-get install -y apt-transport-https

RUN apt-get update && apt-get install -y yarn
# RUN /bin/bash -lc 'npm install -g yarn'
RUN yarn config set registry https://registry.npm.taobao.org

# global package
RUN /bin/bash -lc 'npm install -g cnpm \
      --registry=https://registry.npm.taobao.org'

RUN yarn global add node-gyp
# RUN yarn global add node-inspector
RUN yarn global add pnpm npm-check
RUN bash -lc "npm install -g coffeescript@next"
RUN yarn global add babel-cli
RUN yarn global add gulp-cli http-server
RUN yarn global add supervisor nodemon forever pm2
# RUN yarn global add harp
