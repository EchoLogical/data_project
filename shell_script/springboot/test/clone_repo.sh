#!/bin/bash

# Username dan password untuk autentikasi
USERNAME="jenkins"
PASSWORD="jenkins2025"

# URL repository yang akan di-clone dengan kredensial
REPO_URL="http://$USERNAME:$PASSWORD@192.168.59.128:3000/faisal/test-jenkins.git"

# Direktori tujuan untuk clone repository
DEST_DIR="/home/faisal/jenkins_project/spring-test/source"

# Hapus direktori tujuan jika ada, lalu buat kembali
echo "Menghapus dan membuat ulang $DEST_DIR..."
rm -rf $DEST_DIR
mkdir -p $DEST_DIR

# Clone repository
git clone $REPO_URL $DEST_DIR

# Cek apakah clone berhasil
if [ $? -eq 0 ]; then
    echo "Repository berhasil di-clone ke direktori $DEST_DIR"
else
    echo "Gagal meng-clone repository"
fi