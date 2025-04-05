#!/bin/bash -e

# Go to the directory with the .deb files
#cd dists/stable/main/binary-arm64

# Generate package lists
dpkg-scanpackages --multiversion dists/stable/main/binary-arm64 > Packages
gzip -k -f Packages

cd dists/stable/
# Create Release file
cat > Release <<EOF
Suite: stable
Codename: stable
Architectures: arm64
Components: main
EOF
apt-ftparchive release . >> Release
gpg --default-key "voyager@univrs.cloud" -abs -o Release.gpg Release
gpg --default-key "voyager@univrs.cloud" --clearsign -o InRelease Release

cd ../../
git add -A
git commit -m update
git push
