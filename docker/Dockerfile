FROM ubuntu:13.10
MAINTAINER Johannes 'fish' Ziemke <docker@freigeist.org>

RUN apt-get update && apt-get -y -q upgrade && apt-get -y -q install software-properties-common

RUN apt-get -y -q install python-software-properties python g++ make && \
    add-apt-repository ppa:chris-lea/node.js && \
    apt-get update

RUN apt-get -y -q install nodejs python python-pygments curl git

RUN curl -L https://bitbucket.org/ariya/phantomjs/downloads/phantomjs-1.9.7-linux-x86_64.tar.bz2 | \
    tar -C /usr/local -xjf - && ln -sf ../phantomjs-1.9.7-linux-x86_64/bin/phantomjs /usr/local/bin/

RUN git clone git://github.com/n1k0/casperjs.git /usr/local/casperjs && \
    ln -sf ../casperjs/bin/casperjs /usr/local/bin

RUN mkdir /ghost && chown nobody /ghost

USER nobody
ENV  HOME /ghost

RUN git clone https://github.com/TryGhost/Ghost.git /ghost

WORKDIR /ghost

RUN npm install grunt-cli && npm install && npm install pg && ./node_modules/.bin/grunt init

ENV NODE_ENV production
RUN ./node_modules/.bin/grunt prod
ADD config.js /ghost/

USER root
RUN chown root:root /ghost/ -R

EXPOSE     8080
ENTRYPOINT [ "npm" ]
CMD        [ "start" ]
VOLUME  [ "/ghost/content" ]
