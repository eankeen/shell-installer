#!/bin/bash

set -Eeuo pipefail
source .env

owner="eankeen"
repo="salamis"
tag="v0.2.3"
# repo="shell-installer"
# tag="v0.1.0"

# file="shell_installer"
gh release create v0.1.0 shell_installer
curl \
		--silent \
		--show-error \
		--header "Authorization: token $GITHUB_TOKEN" \
		"https://api.github.com/repos/$owner/shell-installer/releases"

# echo "$GITHUB_TOKEN"
# repoData="$(
# 	curl \
# 		--silent \
# 		--show-error \
# 		--header "Authorization: token $GITHUB_TOKEN" \
# 		"https://api.github.com/repos/$owner/$repo/releases/tags/$tag"
# )"

# repoData="$(
# 	curl \
# 		--silent \
# 		--show-error \
# 		--header "Authorization: token $GITHUB_TOKEN" \
# 		"https://api.github.com/repos/$owner/$repo/releases/tags/$tag"
# )"

echo "$repoData"

# releaseId="$(<<< "$repoData" jq '.id')"

# [[ -n $releaseId && $releaseId == null ]] && {
# 		  echo "releaseId must not be null or empty. Exiting"
# 		  exit 1
# }

# curl \
# 	--header "Authorization: token $GITHUB_TOKEN" \
# 	--header "Content-Type: application/octet-stream" \
# 	--data-binary @"$file" \
# 	"https://uploads.github.com/repos/$owner/$repo/releases/$releaseId/assets?name=$file"
