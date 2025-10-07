#!/bin/bash

# Pindah ke direktori proyek
cd /home/faisal/jenkins_project/spring-test/source

# Jalankan mvn clean install
echo "Menjalankan mvn clean install..."
mvn clean install

# Cek apakah mvn clean install berhasil
if [ $? -eq 0 ]; then
    echo "mvn clean install berhasil."
else
    echo "mvn clean install gagal."
    exit 1
fi

# Jalankan mvn clean package
echo "Menjalankan mvn clean package..."
mvn clean package

# Cek apakah mvn clean package berhasil
if [ $? -eq 0 ]; then
    echo "mvn clean package berhasil."
else
    echo "mvn clean package gagal."
    exit 1
fi