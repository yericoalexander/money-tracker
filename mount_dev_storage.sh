#!/bin/bash
# Script untuk me-mount DevStorage APFS sparse image dari SSD Eksternal jika belum ter-mount

IMAGE_PATH="/Volumes/PS210/DevStorage.sparseimage"
MOUNT_POINT="/Volumes/DevStorage"

if [ -d "$MOUNT_POINT" ]; then
    echo "✅ DevStorage sudah ter-mount di $MOUNT_POINT"
else
    if [ -f "$IMAGE_PATH" ]; then
        echo "🔄 Me-mount DevStorage dari $IMAGE_PATH..."
        hdiutil attach "$IMAGE_PATH"
        echo "✅ Berhasil me-mount DevStorage!"
    else
        echo "❌ File $IMAGE_PATH tidak ditemukan. Pastikan SSD Eksternal terhubung."
        exit 1
    fi
fi
