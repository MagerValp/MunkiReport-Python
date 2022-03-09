#!/bin/bash


set -o errexit


PKGDIR="MunkiPython3"

# Create the symlink
echo "🔹 Creating symlink"
mkdir -p "$PKGDIR/payload/usr/local/munkireport"
LINKPATH="$PKGDIR/payload/usr/local/munkireport/munkireport-python3"
ln -s "/usr/local/munki/munki-python" "$LINKPATH"


# Build the package
echo "📦 Building package"
./munki-pkg/munkipkg "$PKGDIR"


echo "✅ Done"

exit 0
