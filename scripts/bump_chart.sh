#!/usr/bin/env bash

set -o errexit
set -o nounset
set -o pipefail

REPOSITORY_ROOT=$(realpath "$(dirname "${BASH_SOURCE[0]}")/..")

# Bump Helm chart version and optinaly publish to OCI repo
chart=$1
version=${2:-$(git describe --tags --abbrev=0 2>/dev/null ||echo "0.0.1")}
oci_repo=${3:-} #oci://ghcr.io/user/charts
chart_dir=${4:-"$REPOSITORY_ROOT"/charts}
chart_file="$chart_dir"/"$chart"/Chart.yaml

gsed -i "s/^version:.*/version: $version/" "$chart_file"
git add "$chart_file"
git commit -m "chore(version): bump chart: $chart to version: $version"

if [[ -n "${oci_repo}" ]]; then
  helm package charts/"$chart"
  helm push "$chart"-"$version".tgz "$oci_repo"
  rm -rf "$chart"-"$version".tgz
fi
