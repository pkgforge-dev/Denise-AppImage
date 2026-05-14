#!/bin/sh

set -eu

ARCH=$(uname -m)

echo "Installing package dependencies..."
echo "---------------------------------------------------------------"
pacman -Syu --noconfirm cmake openal

echo "Installing debloated packages..."
echo "---------------------------------------------------------------"
get-debloated-pkgs --add-common --prefer-nano

echo "Building stable version of Denise..."
echo "---------------------------------------------------------------"
REPO="https://github.com/piciji/denise"
VERSION="$(git ls-remote --tags --refs --sort="v:refname" "$REPO" | sed 's|.*refs/tags/||' | grep -E '^v?[0-9]+(\.[0-9]+)*$' | tail -n1 | sed 's/^v//')"
git clone --depth 1 --branch v"$VERSION" "$REPO" ./denise
echo "$VERSION" > ~/version

cmake -B build -S ./denise -DCMAKE_INSTALL_PREFIX=/usr -DCMAKE_BUILD_TYPE=Release
cmake --build build -j$(nproc)
cmake --install build
