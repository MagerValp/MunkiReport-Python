#!/bin/bash


set -o errexit


rm -rf payload/*

FWROOT="payload/Library/MunkiReport"
mkdir -p "$FWROOT"

# Build a relocatable Python framework
echo "🔶 Creating relocatable Python 2.7.18 framework"
echo "Logging output to relocatable-python.log"
(
	cd relocatable-python
	./make_relocatable_python_framework.py \
		--upgrade-pip \
		--pip-requirements=../requirements.txt \
		--python-version 2.7.18 \
		--destination "../$FWROOT" \
		> ../relocatable-python.log 2>&1
)
fwpath="$FWROOT/Python.framework"
verpath="$fwpath/Versions/2.7"
sppath="$verpath/lib/python2.7/site-packages"

# Stub out framework import check for macOS 11+
echo "🔸 Patching PyObjC"
sed -i '' '85s/os.path.exists(f)/True/' "$sppath/objc/_dyld.py"
"$verpath/bin/python" -m compileall "$sppath/objc/_dyld.py"

# Create the symlink
echo "🔹 Creating symlink"
mkdir -p payload/usr/local/munkireport
ln -s /Library/MunkiReport/Python.framework/Versions/2.7/bin/python payload/usr/local/munkireport/munkireport-python2


# Build the package
echo "📦 Building package"
./munki-pkg/munkipkg .


echo "✅ Done"

exit 0
