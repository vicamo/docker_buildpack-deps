#
# NOTE: THIS DOCKERFILE IS GENERATED VIA "apply-templates.sh"
#
# PLEASE DO NOT EDIT IT DIRECTLY.
#

ARG BASEIMAGE=buildpack-deps:jammy-curl
FROM ${BASEIMAGE}

RUN set -eux; \
	apt-get update; \
	apt-get install -y --no-install-recommends \
		$(for pkg in \
				mercurial \
				subversion \
		; do \
			if [ -n "$(apt-cache show "${pkg}" 2>/dev/null)" ]; then \
				echo "${pkg}"; \
			fi; \
		done) \
		git \
		openssh-client \
		\
# procps is very common in build systems, and is a reasonably small package
		procps \
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
