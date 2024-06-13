#
# NOTE: THIS DOCKERFILE IS GENERATED VIA "apply-templates.sh"
#
# PLEASE DO NOT EDIT IT DIRECTLY.
#

FROM ubuntu:oracular

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
# https://bugs.debian.org/929417
		tzdata \
	; \
	apt-get dist-clean
