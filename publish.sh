#!/bin/bash -e

# Generate package lists
dpkg-scanpackages --multiversion . > dists/stable/main/binary-arm64/Packages
gzip -k -f dists/stable/main/binary-arm64/Packages

# Go back to the dists/stable directory
cd dists/stable

# Create Release file
cat > Release <<EOF
Suite: stable
Codename: stable
Architectures: arm64
Components: main
EOF
apt-ftparchive release . >> Release
gpg --yes --default-key "voyager@univrs.cloud" -abs -o Release.gpg Release
gpg --yes --default-key "voyager@univrs.cloud" --clearsign -o InRelease Release

cd ../../

git add -A
git commit -m update
git push
