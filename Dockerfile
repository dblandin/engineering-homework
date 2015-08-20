FROM alpine:edge
MAINTAINER Devon Blandin <dblandin@gmail.com>

WORKDIR /code
COPY . /code
VOLUME /code

RUN apk --update add ruby ruby-dev ruby-bundler build-base && \
    bundle install -j 4 && \
    apk del build-base && rm -fr /usr/share/ri

RUN adduser -u 9000 -D app
USER app

CMD ["/usr/src/app/bin/complexity"]
