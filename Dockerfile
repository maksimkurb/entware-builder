# https://github.com/openwrt/buildbot/blob/master/docker/buildworker/Dockerfile

FROM	debian:11
MAINTAINER	Entware team

ARG	DEBIAN_FRONTEND=noninteractive

RUN \
    apt-get update && \
    apt-get install -y \
	build-essential \
	ccache \
	curl \
	gawk \
	g++-multilib \
	gcc-multilib \
	genisoimage \
	git-core \
	gosu \
	libdw-dev \
	libelf-dev \
	libncurses5-dev \
 	libssl-dev \
	locales \
	mc \
	pv \
	pwgen \
	python \
	python3 \
	python3-pip \
	qemu-utils \
	rsync \
	signify-openbsd \
	subversion \
	sudo \
	swig \
	unzip \
	wget \
	zstd && \
    apt-get clean && \
    localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8

RUN pip3 install -U pip
RUN pip3 install \
	pyelftools \
	pyOpenSSL \
	service_identity

ENV LANG=en_US.utf8

# Clone and build Entware
RUN git clone --depth 1 https://github.com/Entware/Entware.git /opt/entware \
    && cd /opt/entware \
    && make package/symlinks

RUN echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers
RUN useradd -c "OpenWrt Builder" -m -d /opt/entware -G sudo -s /bin/bash entware

USER entware
WORKDIR /opt/entware
ENV HOME=/opt/entware

ARG ENTWARE_ARCH=mipsel-3.4
ENV ENTWARE_ARCH=$ENTWARE_ARCH

RUN cd /opt/entware \
    && cp -v configs/$ENTWARE_ARCH.config .config \
		&& make -j$(nproc) toolchain/install

# Default command
CMD ["/bin/bash"]