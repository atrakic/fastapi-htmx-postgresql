#!/usr/bin/env bash

set -o errexit
set -o nounset
set -o pipefail

# bump and optinaly publish Helm chart to GHCR

chart=$1
version=${2:-$(git describe --tags --abbrev=0 2>/dev/null ||echo "0.0.1")}

gsed -i "s/^version:.*/version: $version/" ./charts/"$chart"/Chart.yaml
git add ./charts/"$chart"/Chart.yaml
git commit --allow-empty -m "chore(version): release $version"

oci_repo=${3:-} #oci://ghcr.io/user/charts
if [[ -n "${oci_repo}" ]]; then
  helm package charts/"$chart"
  helm push "$chart"-"$version".tgz "$oci_repo"
  rm -rf "$chart"-"$version".tgz
fi
