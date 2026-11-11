#!/bin/bash -e

ARCHITECTURES="arm64 amd64"

# Generate package lists
for arch in $ARCHITECTURES; do
  dir="dists/stable/main/binary-$arch"
  mkdir -p "$dir"
  dpkg-scanpackages --multiversion "./$dir" > "$dir/Packages"
  rm -f "$dir/Packages.gz"
done

# Publish each package's changelog where apt-get changelog looks for it
rm -rf changelogs
for deb in dists/stable/main/binary-*/*.deb; do
  pkg=$(dpkg-deb -f "$deb" Package)
  version=$(dpkg-deb -f "$deb" Version)
  dir="changelogs/main/${pkg:0:1}/$pkg"
  file="$dir/${pkg}_${version#*:}_changelog"
  if [ -f "$file" ]; then
    continue
  fi
  mkdir -p "$dir"
  for name in changelog.Debian.gz changelog.gz; do
    if dpkg-deb --fsys-tarfile "$deb" | tar -xO "./usr/share/doc/$pkg/$name" 2>/dev/null | gunzip > "$file" && [ -s "$file" ]; then
      break
    fi
    rm -f "$file"
  done
done

# Go back to the dists/stable directory
cd dists/stable

# Create Release file
cat > Release <<EOF
Suite: stable
Codename: stable
Architectures: $ARCHITECTURES
Components: main
Changelogs: https://packages.univrs.cloud/changelogs/@CHANGEPATH@_changelog
EOF
apt-ftparchive release . >> Release
gpg --yes --default-key "voyager@univrs.cloud" -abs -o Release.gpg Release
gpg --yes --default-key "voyager@univrs.cloud" --clearsign -o InRelease Release

cd ../../

git add -A
git commit -m update
git push
