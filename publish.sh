#!/bin/bash -e

repo_base="stable"
arch="arm64"
component="main"
binary_dir="binary-$arch"

cd "$repo_base/$component/$binary_dir"
dpkg-scanpackages --multiversion . > Packages
gzip -k -f Packages
cd "../../.."
cat > "$repo_base/Release" <<EOF
Suite: stable
Codename: stable
Architectures: $arch
Components: $component
EOF
apt-ftparchive release "$repo_base" >> "$repo_base/Release"
gpg --default-key "voyager@univrs.cloud" -abs -o "$repo_base/Release.gpg" "$repo_base/Release"
gpg --default-key "voyager@univrs.cloud" --clearsign -o "$repo_base/InRelease" "$repo_base/Release"
git add -A
git commit -m update
git push
