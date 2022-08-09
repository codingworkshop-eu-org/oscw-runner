FROM archlinux:latest
MAINTAINER CodingWorkshop <constitutive@codingworkshop.eu.org>

# Update system base
RUN pacman -Syu --noconfirm --noprogressbar --quiet

# Install additional packages
RUN pacman -Syu --noconfirm --noprogressbar --quiet autoconf automake binutils bison cppcheck docker flex gcc git libedit libmd linux-headers mtools parted patch pkgconfig texinfo wget 

# Set locale
RUN echo 'en_US.UTF-8 UTF-8' > /etc/locale.gen && \
	echo 'LANG=en_US.UTF-8' > /etc/locale.conf && \
	locale-gen

# Install Docker-in-Docker
ENV DIND_COMMIT 3b5fac462d21ca164b3778647420016315289034
RUN wget "https://raw.githubusercontent.com/docker/docker/${DIND_COMMIT}/hack/dind" -O /usr/local/bin/dind && \
	chmod a+x /usr/local/bin/dind

# Configure Docker-in-Docker
COPY files/entrypoint.sh /usr/local/bin/
RUN chmod a+x /usr/local/bin/entrypoint.sh
VOLUME /var/lib/docker
EXPOSE 2375

# Install XT toolchain
RUN wget https://github.com/xt-sys/xtchain/releases/download/2.4/xtchain-2.4-linux.tar.zst -O xtchain.tar.zst && \
	mkdir -p /opt/xtchain && \
	tar xapf xtchain.tar.zst -C /opt/xtchain && \
	rm xtchain.tar.zst

# Install GitHub publishing script
COPY files/github_publish /usr/local/bin/
RUN chmod a+x /usr/local/bin/github_publish

# Set system path
ENV PATH="/opt/xtchain:/opt/xtchain/bin:${PATH}"

# Set default entrypoint
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
CMD []
