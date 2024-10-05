#!/bin/bash -e

dpkg-scanpackages --multiversion . > Packages
gzip -k -f Packages
apt-ftparchive release . > Release
gpg --default-key "voyager@univrs.cloud" -abs -o - Release > Release.gpg
gpg --default-key "voyager@univrs.cloud" --clearsign -o - Release > InRelease
git add -A
git commit -m update
git push
