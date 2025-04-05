#!/bin/bash -e

cd dists/stable/main/binary-arm64
dpkg-scanpackages --multiversion . > Packages
gzip -k -f Packages
cd ../../
cat > Release <<EOF
Suite: stable
Codename: stable
Architectures: arm64
Components: main
EOF
apt-ftparchive release . >> Release
gpg --default-key "voyager@univrs.cloud" -abs -o - Release > Release.gpg
gpg --default-key "voyager@univrs.cloud" --clearsign -o - Release > InRelease
git add -A
git commit -m update
git push
