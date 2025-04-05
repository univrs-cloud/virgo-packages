#!/bin/bash -e

cd dists/stable/main/binary-arm64
dpkg-scanpackages --multiversion . > Packages
gzip -k -f Packages
cd ../../../.. # Navigate back to the root of the repository

cat > dists/stable/Release <<EOF
Suite: stable
Codename: stable
Architectures: arm64
Components: main
EOF
apt-ftparchive release dists/stable >> dists/stable/Release
gpg --default-key "voyager@univrs.cloud" -abs -o dists/stable/Release.gpg dists/stable/Release
gpg --default-key "voyager@univrs.cloud" --clearsign -o dists/stable/InRelease dists/stable/Release

git add -A
git commit -m update
git push
