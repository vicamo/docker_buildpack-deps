#!/usr/bin/env bash
set -Eeuo pipefail

distsSuitesArches=( "$@" )
if [ "${#distsSuitesArches[@]}" -eq 0 ]; then
	distsSuitesArches=( */*/*/ )
	json='{}'
else
	json="$(< versions.json)"
fi
distsSuitesArches=( "${distsSuitesArches[@]%/}" )

travisEnv=
for version in "${distsSuitesArches[@]}"; do
	travisEnv+='\n  - VERSION='"$version"

	arch="$(basename "$version")"
	codename="$(basename "$(dirname "$version")")"
	dist="$(dirname "$(dirname "$version")")"
	doc='{"variants": [ "curl", "scm", "" ]}'
	suite=
	case "$dist" in
		debian)
			# "stable", "oldstable", etc.
			suite="$(
				wget -qO- -o /dev/null "https://deb.debian.org/debian/dists/$codename/Release" \
					| gawk -F ':[[:space:]]+' '$1 == "Suite" { print $2 }'
			)"
			;;
		ubuntu)
			suite="$(
				wget -qO- -o /dev/null "http://archive.ubuntu.com/ubuntu/dists/$codename/Release" \
					| gawk -F ':[[:space:]]+' '$1 == "Version" { print $2 }'
			)"
			;;
	esac
	if [ -n "$suite" ]; then
		export suite
		doc="$(jq <<<"$doc" -c '.suite = env.suite')"
	fi
	export doc version
	json="$(jq <<<"$json" -c --argjson doc "$doc" '.[env.version] = $doc')"
done

jq <<<"$json" -S . > versions.json

travis="$(awk -v 'RS=\n\n' '($1 == "env:") { $0 = substr($0, 0, index($0, "matrix:") + length("matrix:"))"'"$travisEnv"'" } { printf "%s%s", $0, RS }' .travis.yml)"
echo "$travis" > .travis.yml
