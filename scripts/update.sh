#!/usr/bin/env bash
set -euo pipefail

PACKAGE_FILE="pkgs/by-name/or/orbit/package.nix"
GITHUB_REPO="expo/orbit"

current_version() {
  sed -n 's/^  version = "\(.*\)";$/\1/p' "$PACKAGE_FILE"
}

latest_release() {
  curl -sSf "https://api.github.com/repos/${GITHUB_REPO}/releases/latest" \
    | jq -r '.tag_name' \
    | sed 's/^expo-orbit-v//'
}

download_hash() {
  local version="$1"
  local url="https://github.com/${GITHUB_REPO}/releases/download/expo-orbit-v${version}/expo-orbit_${version}_amd64.deb"
  local tmp
  tmp=$(mktemp)

  curl -sSfL -o "$tmp" "$url"
  nix hash to-sri --type sha256 "$(nix hash file --type sha256 "$tmp")"
  rm -f "$tmp"
}

main() {
  local current latest new_hash

  current=$(current_version)
  latest=$(latest_release)

  if [ "$current" = "$latest" ]; then
    echo "Already at latest version: ${current}"
    exit 0
  fi

  echo "Updating from ${current} to ${latest}"

  new_hash=$(download_hash "$latest")

  sed -i \
    -e "s/version = \"${current}\"/version = \"${latest}\"/" \
    -e "s/sha256 = \".*\"/sha256 = \"${new_hash}\"/" \
    "$PACKAGE_FILE"

  echo "Updated ${PACKAGE_FILE}"

  nix build ".#orbit" --no-link
  echo "Build succeeded for version ${latest}"
}

main "$@"
