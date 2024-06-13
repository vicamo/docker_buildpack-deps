#
# NOTE: THIS DOCKERFILE IS GENERATED VIA "apply-templates.sh"
#
# PLEASE DO NOT EDIT IT DIRECTLY.
#

FROM debian:sid

RUN set -eux; \
	apt-get update; \
	apt-get install -y --no-install-recommends \
		ca-certificates \
		curl \
		gnupg \
		netbase \
# we want versions of "sq" that contain https://gitlab.com/sequoia-pgp/sequoia/-/commit/b41e1504cd29097328cb21f95808c9972188499e (and thus "sq keyserver" subcommands; 0.26+)
		$( \
			ver=$( (apt-cache show sq 2>/dev/null | grep -m1 ^Version: | awk '{print $2}') || true); \
			if dpkg --compare-versions "$ver" ge 0.26; then \
				echo "sq"; \
			fi \
		) \
		wget \
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
