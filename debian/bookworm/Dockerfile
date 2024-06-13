#
# NOTE: THIS DOCKERFILE IS GENERATED VIA "apply-templates.sh"
#
# PLEASE DO NOT EDIT IT DIRECTLY.
#

FROM buildpack-deps:bookworm-scm

RUN set -ex; \
	apt-get update; \
	apt-get install -y --no-install-recommends \
		autoconf \
		automake \
		bzip2 \
		default-libmysqlclient-dev \
		dpkg-dev \
		file \
		g++ \
		gcc \
		imagemagick \
		libbz2-dev \
		libc6-dev \
		libcurl4-openssl-dev \
		libdb-dev \
		libevent-dev \
		libffi-dev \
		libgdbm-dev \
		libglib2.0-dev \
		libgmp-dev \
		libjpeg-dev \
		libkrb5-dev \
		liblzma-dev \
		libmagickcore-dev \
		libmagickwand-dev \
		libmaxminddb-dev \
		libncurses5-dev \
		libncursesw5-dev \
		libpng-dev \
		libpq-dev \
		libreadline-dev \
		libsqlite3-dev \
		libssl-dev \
		libtool \
		libwebp-dev \
		libxml2-dev \
		libxslt-dev \
		libyaml-dev \
		make \
		patch \
		unzip \
		xz-utils \
		zlib1g-dev \
	; \
# only suites with APT 2.7.8+ have "apt-get dist-clean"
# https://tracker.debian.org/news/1492892/accepted-apt-278-source-into-unstable/
	$( \
		ver=$( (apt-cache show apt 2>/dev/null | grep -m1 ^Version: | awk '{print $2}') || true); \
		if dpkg --compare-versions "$ver" ge 2.7.8; then \
			echo "apt-get dist-clean"; \
		else \
			echo "rm -rf /var/lib/apt/lists/*"; \
		fi \
	)
