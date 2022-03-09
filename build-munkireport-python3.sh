#!/bin/bash


set -o errexit


PKGDIR="Python3"
version=$( grep '"version":' "$PKGDIR/build-info.json" | cut -d\" -f4 )
ver_short=$( echo "$version" | cut -d. -f1,2 )

rm -rf "$PKGDIR/payload"/*

FWROOT="$PKGDIR/payload/Library/MunkiReport"
mkdir -p "$FWROOT"

# Build a relocatable Python framework
echo "🔶 Creating relocatable Python $version framework"
echo "Logging output to relocatable-python.log"
(
	cd relocatable-python
	./make_relocatable_python_framework.py \
		--upgrade-pip \
		--pip-requirements="../$PKGDIR/requirements.txt" \
		--os-version=11 \
		--python-version "$version" \
		--destination "../$FWROOT" \
		> ../relocatable-python.log 2>&1
)

# Create the symlink
echo "🔹 Creating symlink"
mkdir -p "$PKGDIR/payload/usr/local/munkireport"
LINKPATH="$PKGDIR/payload/usr/local/munkireport/munkireport-python3"
ln -s "/Library/MunkiReport/Python.framework/Versions/$ver_short/bin/python3" "$LINKPATH"
if [[ ! -x "$LINKPATH" ]]; then
	echo "$LINKPATH not executable" 1>&2
	exit 70
fi


# Build the package
echo "📦 Building package"
./munki-pkg/munkipkg "$PKGDIR"


echo "✅ Done"

exit 0
