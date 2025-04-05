#!/bin/bash -e

# Define the base directory for your repository
repo_base="stable"

# Define the architecture
arch="arm64"

# Define the components
component="main"

# Navigate to the architecture-specific directory
cd "$repo_base/$component/binary-$arch"

# Generate the Packages file
dpkg-scanpackages --multiversion . > Packages
gzip -k -f Packages

# Navigate back to the repository base
cd "../../.."

# Generate the Release file
cat > "$repo_base/Release" <<EOF
Suite: stable
Codename: stable
Architectures: $arch
Components: $component
EOF
apt-ftparchive release "$repo_base" >> "$repo_base/Release"

# Sign the Release file
gpg --default-key "voyager@univrs.cloud" -abs -o "$repo_base/Release.gpg" "$repo_base/Release"
gpg --default-key "voyager@univrs.cloud" --clearsign -o "$repo_base/InRelease" "$repo_base/Release"

# Add, commit, and push changes
git add -A
git commit -m "Update PPA repository"
git push
