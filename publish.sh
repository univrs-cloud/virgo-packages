#!/bin/bash -e

cd dists/stable/main/binary-all
dpkg-scanpackages --multiversion . > Packages
gzip -k -f Packages
cd ../../
cat > Release <<EOF
Architectures: all
Components: main
EOF
apt-ftparchive release . >> Release
gpg --default-key "voyager@univrs.cloud" -abs -o - Release > Release.gpg
gpg --default-key "voyager@univrs.cloud" --clearsign -o - Release > InRelease
git add -A
git commit -m update
git push
