FROM ruby:2.7-alpine

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

RUN mkdir -p /.plantuml/
RUN curl https://github.com/plantuml/plantuml/releases/download/v1.2021.16/plantuml-1.2021.16.jar -o /.plantuml/plantuml.jar -s -L
RUN echo "#!/bin/sh" > /.plantuml/plantuml
RUN echo "java -jar /.plantuml/plantuml.jar \"\$1\" \"\$2\"" >> /.plantuml/plantuml
RUN chmod +x /.plantuml/plantuml
ENV PATH="/.plantuml/:${PATH}"
RUN ln -s /.plantuml/plantuml /bin/plantuml
RUN chmod +x /bin/plantuml


ENTRYPOINT ["/entrypoint.sh"]
