#!/bin/bash
script_full_path=$(dirname "$0")
cd $script_full_path || exit 1

rm Packages Packages.bz2 Packages.xz Packages.zst Release Release.gpg

echo "[Repository] Generating Packages..."
./RepoUnclutter
zstd -q -c19 Packages > Packages.zst
xz -c9 Packages > Packages.xz
bzip2 -c9 Packages > Packages.bz2

echo "[Repository] Generating Release..."
apt-ftparchive \
		-o APT::FTPArchive::Release::Origin="RepoUnclutter" \
		-o APT::FTPArchive::Release::Label="RepoUnclutter" \
		-o APT::FTPArchive::Release::Suite="stable" \
		-o APT::FTPArchive::Release::Version="2.0" \
		-o APT::FTPArchive::Release::Codename="ios" \
		-o APT::FTPArchive::Release::Architectures="iphoneos-arm" \
		-o APT::FTPArchive::Release::Components="main" \
		-o APT::FTPArchive::Release::Description="Repos but without the clutter" \
		release . > Release

echo "[Repository] Finished"