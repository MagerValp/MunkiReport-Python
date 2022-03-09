#!/bin/bash


set -o errexit


PKGDIR="Python2"
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
		--python-version "$version" \
		--destination "../$FWROOT" \
		> ../relocatable-python.log 2>&1
)
fwpath="$FWROOT/Python.framework"
verpath="$fwpath/Versions/$ver_short"
sppath="$verpath/lib/python$ver_short/site-packages"

# Stub out framework import check for macOS 11+
echo "🔸 Patching PyObjC"
sed -i '' '85s/os.path.exists(f)/True/' "$sppath/objc/_dyld.py"
"$verpath/bin/python" -m compileall "$sppath/objc/_dyld.py"

# Create the symlink
echo "🔹 Creating symlink"
mkdir -p "$PKGDIR/payload/usr/local/munkireport"
ln -s "/Library/MunkiReport/Python.framework/Versions/$ver_short/bin/python" "$PKGDIR/payload/usr/local/munkireport/munkireport-python2"

# Build the package
echo "📦 Building package"
./munki-pkg/munkipkg "$PKGDIR"


echo "✅ Done"

exit 0
