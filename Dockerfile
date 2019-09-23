FROM ubuntu:18.04
RUN apt-get update && \
        apt-get upgrade -y && \
        apt-get install -y build-essential curl tidy python-pip && \
        pip install pyang && \
    apt-get install -y gnutls-bin gnutls-dev libncurses-dev libxml2 libxml2-dev libxslt-dev  python-dev

ENV SHELL=/bin/bash
ARG EVERSION=26.3

RUN curl -O http://ftp.gnu.org/gnu/emacs/emacs-$EVERSION.tar.gz && \
    tar xf emacs-$EVERSION.tar.gz
WORKDIR emacs-$EVERSION
RUN env CANNOT_DUMP=yes ./configure
RUN make
RUN make install

ARG ORG_RELEASE=9.2.2
RUN mkdir -p /tmp/org-${ORG_RELEASE} && \
    (cd /tmp/org-${ORG_RELEASE} && \
     curl -fL --silent https://code.orgmode.org/bzg/org-mode/archive/release_${ORG_RELEASE}.tar.gz | tar --strip-components=1 -xzf - && \
     make autoloads lisp)

WORKDIR /
CMD [ "bash" ]
