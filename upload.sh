#!/bin/bash

set -Eeuo pipefail
source .env

owner="eankeen"
repo="shell-installer"
tag="v0.1.0"
file="shell_installer"

repoData="$(
	curl \
		--silent \
		--show-error \
		--header "Authorization: token $GITHUB_TOKEN" \
		"https://api.github.com/repos/eankeen/$repo/releases/tags/$tag"
)"

releaseId="$(jq '.id' <<< $repoData)"
: ${releaseId:?"releaseId must be valid. Exiting"}

curl \
	--header "Authorization: token $GITHUB_TOKEN" \
	--header "Content-Type: application/octet-stream" \
	--data-binary @"$file" \
	"https://uploads.github.com/repos/$owner/$repo/releases/$releaseId/assets?name=$file"
