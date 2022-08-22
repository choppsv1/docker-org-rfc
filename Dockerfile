FROM ubuntu:20.04

RUN apt-get update && \
        apt-get upgrade -y
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y build-essential curl gnutls-bin gnutls-dev tidy python3-pip && \
    pip install pyang && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y libncurses-dev libxml2 libxml2-dev libxslt-dev  python3-dev && \
    pip install xml2rfc && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y pkg-config libgnutls28-dev vim && \
    # Add yang models
    mkdir -p /yang /yang-drafts /yang-git /work && \
    (cd /yang-git && curl -L https://github.com/YangModels/yang/tarball/master | tar --strip 1 -xzf -) && \
    find /yang-git/standard -name '*.yang' ! -path '*vendor*' -exec mv {} /yang \; && \
    find /yang-git/experimental -name '*.yang' ! -path '*vendor*' -exec mv {} /yang-drafts \; && \
    rm -rf /yang-git

ENV YANG_MODPATH=/yang:/yang-drafts
ENV SHELL=/bin/bash

ARG EVERSION=27.2
RUN curl -O http://ftp.gnu.org/gnu/emacs/emacs-$EVERSION.tar.gz && \
    tar xf emacs-$EVERSION.tar.gz

WORKDIR emacs-$EVERSION
RUN env CANNOT_DUMP=yes ./configure && make && make install

ARG ORG_RELEASE=9.4.4
RUN mkdir -p /tmp/org-${ORG_RELEASE} && \
    (cd /tmp/org-${ORG_RELEASE} && \
     curl -fL --silent https://git.savannah.gnu.org/cgit/emacs/org-mode.git/snapshot/org-mode-release_${ORG_RELEASE}.tar.gz | \
        tar --strip-components=1 -xzf - && \
     make autoloads lisp)

WORKDIR /work

CMD [ "bash" ]
