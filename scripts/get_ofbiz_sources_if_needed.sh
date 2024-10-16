#!/bin/bash
set -e

SCRIPT_DIR=$(cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
OFBIZ_TARGET_DIR="$SCRIPT_DIR/../ofbiz/apache-ofbiz"
SOURCES_ZIP_URL="https://github.com/apache/ofbiz-framework/archive/refs/tags/release18.12.15.zip"
SOURCES_ZIP_FILE="$SCRIPT_DIR/../ofbiz/release18.12.15.zip"

if [ -d "$OFBIZ_TARGET_DIR" ]; then
    echo "OFBiz sources already exist. Skipping download: $OFBIZ_TARGET_DIR"
    exit
fi


if [ ! -f "$SOURCES_ZIP_FILE" ]; then
    echo "Downloading OFBiz sources from $SOURCES_ZIP_URL"
    wget -O "$SOURCES_ZIP_FILE" "$SOURCES_ZIP_URL"
else 
    echo "OFBiz sources already exist. Skipping download: $SOURCES_ZIP_FILE"
fi

ZIP_TEMPDIR=$(mktemp -d "$SCRIPT_DIR/../ofbiz/ofbiz-sources-XXXXXXXXXXXX")
echo "Extracting OFBIZ sources to $ZIP_TEMPDIR"
unzip "$SOURCES_ZIP_FILE" -d "$ZIP_TEMPDIR"
ZIP_ROOT_DIR=$(zipinfo -1 "$SOURCES_ZIP_FILE" | head --lines=1)

echo "Moving OFBiz sources from $ZIP_TEMPDIR/$ZIP_ROOT_DIR to $OFBIZ_TARGET_DIR"
mv "$ZIP_TEMPDIR/$ZIP_ROOT_DIR" "$OFBIZ_TARGET_DIR"

echo "Removing temporary directory $ZIP_TEMPDIR"
rm -r "$ZIP_TEMPDIR"