FROM ruby:2.3.4

ENV APP shipping
ENV NVM_DIR /usr/local/nvm
ENV NODE_VERSION 6.11.2

RUN mkdir -p /$APP /var/log/$APP /var/$APP/
ADD . /$APP
WORKDIR /$APP

# replace shell with bash so we can source files
RUN rm /bin/sh && ln -s /bin/bash /bin/sh

# Update the repository sources list and install dependencies
RUN apt-get update \
    && apt-get install -y --no-install-recommends libjemalloc1 cron

# Install and configure nodejs
RUN curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.33.8/install.sh | bash
RUN source $NVM_DIR/nvm.sh \
    && nvm install $NODE_VERSION \
    && nvm alias default $NODE_VERSION \
    && nvm use default

# Add node and npm to path so the commands are available
ENV NODE_PATH $NVM_DIR/v$NODE_VERSION/lib/node_modules
ENV PATH $NVM_DIR/versions/node/v$NODE_VERSION/bin:$PATH
ENV LD_PRELOAD "/usr/lib/x86_64-linux-gnu/libjemalloc.so.1"

RUN node -v
RUN npm -v

RUN npm install -g yarn
RUN bundle install --jobs 20 --retry 5 --without development test
RUN yarn install

RUN apt purge -y curl wget \
    && apt-get -y autoclean \
    && apt-get autoremove -y \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

COPY entrypoint.sh /usr/local/bin/
RUN ln -s usr/local/bin/entrypoint.sh /
RUN chmod +x /usr/local/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]

EXPOSE 9494

#CMD bundle exec puma -C config/puma/aws-production.rb
#CMD bundle exec sidekiq -C config/sidekiq/aws-production.yml
