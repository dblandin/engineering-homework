FROM alpine:edge
MAINTAINER Devon Blandin <dblandin@gmail.com>

RUN apk --update add ruby ruby-dev ruby-bundler build-base

WORKDIR /usr/src/app
COPY . /usr/src/app

RUN bundle install -j 4
RUN apk del build-base && rm -fr /usr/share/ri

RUN adduser -u 9000 -D app
USER app

CMD ["/usr/src/app/bin/complexity"]
