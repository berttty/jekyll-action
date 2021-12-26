FROM ruby:2.7-alpine

ARG PLANTUML_VERSION=1.2021.16

LABEL version="2.0.1"
LABEL repository="https://github.com/helaili/jekyll-action"
LABEL homepage="https://github.com/helaili/jekyll-action"
LABEL maintainer="Alain Hélaïli <helaili@github.com>"

RUN apk add --no-cache git build-base
# Allow for timezone setting in _config.yml
RUN apk add --update tzdata
# Use curl to send API requests
RUN apk add --update curl
# add java
RUN apk add openjdk11

# debug
RUN bundle version

COPY LICENSE README.md /

COPY entrypoint.sh /

RUN apk add --virtual planuml-deps --no-cache graphviz ttf-droid ttf-droid-nonlatin curl \
    && mkdir /plantuml \
    && curl -L https://sourceforge.net/projects/plantuml/files/plantuml.${PLANTUML_VERSION}.jar/download -o /plantuml/plantuml.jar

COPY plantuml /plantuml

RUN chmod +x /plantuml/plantuml
ENV PATH="/plantuml/:${PATH}"
RUN ln -s /plantuml/plantuml /bin/plantuml
RUN chmod +x /bin/plantuml


ENTRYPOINT ["/entrypoint.sh"]
