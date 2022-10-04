FROM alpine:latest

ARG WORKDIR=/app
ARG BINARY_DIRECTORY=${WORKDIR}/.bin
ARG EXPOSE_PORT=8080

ENV APP_PORT=$EXPOSE_PORT

WORKDIR ${WORKDIR}

# First we install required dependencies git, openssl and wget etc...
RUN apk update \                                                                                                                                                                                                                        
    && apk --no-cache add ca-certificates wget \                                                                                                                                                                                                      
    && update-ca-certificates make libc6-compat \
    && rm -rf /tmp/*

RUN apk fix \
    && apk --no-cache --update add git supervisor \
    && rm -rf /tmp/*

# Create supervisor logs directory
RUN mkdir -p /var/log/supervisor \
    && mkdir -p /etc/supervisor/conf.d

RUN apk add --no-cache go  \
    && rm -rf /tmp/*

# Install & Build webhooks binary
RUN git clone https://github.com/adnanh/webhook.git webhook \
    && mkdir $BINARY_DIRECTORY \
    && cd webhook && go build -o $BINARY_DIRECTORY github.com/adnanh/webhook \
    && ln -s "$BINARY_DIRECTORY/webhook" /usr/local/bin/webhook


# Prepare webhook directory
RUN mkdir /etc/webhooks \
    # Create webhook logs directory
    && mkdir /etc/webhooks/logs/
    # Grant ownership to the specified command user
    # && chown -R  /etc/webhooks

# Prepare webhooks hello world script
RUN mkdir -p /etc/webhooks/hooks
COPY ./hooks/* /etc/webhooks/hooks

COPY ./docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh
RUN chmod +x /usr/local/bin/docker-entrypoint.sh

EXPOSE $EXPOSE_PORT

ENTRYPOINT ["docker-entrypoint.sh"]