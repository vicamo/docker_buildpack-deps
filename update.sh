#!/bin/bash
set -eo pipefail

cd "$(dirname "$(readlink -f "$BASH_SOURCE")")"

versions=( "$@" )
if [ ${#versions[@]} -eq 0 ]; then
	versions=( */*/*/ )
fi
versions=( "${versions[@]%/}" )

travisEnv=
for version in "${versions[@]}"; do
	suite=${version%/*}
	dist=${suite%/*}
	suite=${suite#*/}
	arch=${version##*/}
	echo "$version"
	for variant in curl scm ''; do
		src="Dockerfile${variant:+-$variant}.template"
		trg="$version${variant:+/$variant}/Dockerfile"
		mkdir -p "$(dirname "$trg")"
		if ! grep -q '^# GENERATED' $version/Dockerfile; then
			if [ "$arch" != "amd64" ]; then
				echo >&2 "error: inherit generic repo from '$version'"
				exit 1
			fi
			echo "FROM buildpack-deps:${suite}${variant:+-$variant}" > "$trg"
		else
			sed \
				-e 's!DIST!'"$dist"'!g' \
				-e 's!SUITE!'"${suite}"'!g' \
				-e 's!ARCH!'"${arch}"'!g' \
				"$src" > "$trg"
		fi

		if [ "$dist" = 'debian' ]; then
			# remove "bzr" from buster and later
			case "$suite" in
				jessie|stretch) echo ' - how bizarre (still includes "bzr")' ;;
				*)
					sed -i '/bzr/d' "$version/scm/Dockerfile"
					;;
			esac
		fi
	done
	travisEnv+='\n  - VERSION='"$version"
done

travis="$(awk -v 'RS=\n\n' '($1 == "env:") { $0 = substr($0, 0, index($0, "matrix:") + length("matrix:"))"'"$travisEnv"'" } { printf "%s%s", $0, RS }' .travis.yml)"
echo "$travis" > .travis.yml
