FROM debian:stretch

LABEL version="1.1" \
      maintainer="igoticecream@gmail.com" \
      description="Docker image for Nintendo Switch development"

ENV DEBIAN_FRONTEND=noninteractive
ENV HOME=/home/nx
ENV DEVKITPRO=/opt/devkitpro
ENV DEVKITARM=$DEVKITPRO/devkitARM
ENV DEVKITA64=$DEVKITPRO/devkitA64
ENV LIBNX=$DEVKITPRO/libnx
ENV PORTLIBS=$DEVKITPRO/portlibs/switch
ENV SWITCHTOOLS=$DEVKITPRO/tools
ENV PACMAN=$DEVKITPRO/pacman
ENV PATH=$PATH:$DEVKITARM/bin
ENV PATH=$PATH:$DEVKITA64/bin
ENV PATH=$PATH:$PORTLIBS/bin
ENV PATH=$PATH:$SWITCHTOOLS/bin
ENV PATH=$PATH:$PACMAN/bin

RUN apt-get update -y && \
    apt-get install -y apt-utils && \
    apt-get install -y --no-install-recommends sudo ca-certificates pkg-config curl wget bzip2 xz-utils make git bsdtar doxygen gnupg unzip zip && \
    apt-get clean -y

RUN wget https://github.com/devkitPro/pacman/releases/download/devkitpro-pacman-1.0.1/devkitpro-pacman.deb && \
    dpkg -i devkitpro-pacman.deb && \
    rm devkitpro-pacman.deb && \
    dkp-pacman -Scc --noconfirm

RUN dkp-pacman -Syyu --noconfirm switch-dev && \
    dkp-pacman -S --needed --noconfirm `dkp-pacman -Slq dkp-libs | grep '^switch-'` && \
    dkp-pacman -Scc --noconfirm

RUN dkp-pacman -Sy --noconfirm devkitARM && \
    dkp-pacman -Scc --noconfirm

RUN echo -e '#!/bin/bash\ndkp-pacman -Syyu --noconfirm && dkp-pacman -Scc --noconfirm' > /usr/local/bin/update && \
    chmod +x /usr/local/bin/update

WORKDIR /nx
VOLUME /nx
