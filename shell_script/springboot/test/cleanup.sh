#!/bin/bash

# Direktori yang akan dibersihkan
TARGET_DIR="/home/faisal/jenkins_project/spring-test/source"

# Hapus semua isi direktori
echo "Membersihkan isi direktori $TARGET_DIR..."
rm -rf $TARGET_DIR/*

# Cek apakah pembersihan berhasil
if [ $? -eq 0 ]; then
    echo "Direktori $TARGET_DIR berhasil dibersihkan."
else
    echo "Gagal membersihkan direktori $TARGET_DIR."
    exit 1
fi