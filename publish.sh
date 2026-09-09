#!/bin/bash -e

ARCHITECTURES="arm64 amd64"

# Generate package lists
for arch in $ARCHITECTURES; do
  dir="dists/stable/main/binary-$arch"
  mkdir -p "$dir"
  dpkg-scanpackages --multiversion "./$dir" > "$dir/Packages"
  gzip -k -f "$dir/Packages"
done

# Go back to the dists/stable directory
cd dists/stable

# Create Release file
cat > Release <<EOF
Suite: stable
Codename: stable
Architectures: $ARCHITECTURES
Components: main
EOF
apt-ftparchive release . >> Release
gpg --yes --default-key "voyager@univrs.cloud" -abs -o Release.gpg Release
gpg --yes --default-key "voyager@univrs.cloud" --clearsign -o InRelease Release

cd ../../

git add -A
git commit -m update
git push
