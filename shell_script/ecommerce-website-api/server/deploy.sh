#!/bin/bash

set -e  # Kaluar langsung lamun aya paréntah anu hasilna lain nol

# Fungsi pikeun ngalog pesen
log() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $1"
}

# Fungsi pikeun ménta konfirmasi
confirm_action() {
    read -p "$1 (y/n): " confirm
    if [[ "$confirm" != "y" ]]; then
        log "Aksi dibatalkeun."
        exit 0
    fi
}

# Nyadangkeun gambar heubeul
confirm_action "Naha rék nyadangkeun gambar heubeul? (y/n)"
log "Nyadangkeun gambar heubeul..."
sudo docker save registry.codeoffice.xyz/all-avrist-assurance-ecommerce-website-api > /home/avrist/repo/website-api/backup/ecommerce-website-api_bak_$(date '+%Y%m%d_%H%M%S').tar

# Miceun layanan
confirm_action "Naha rék miceun layanan anu aya? (y/n)"
log "Miceun layanan anu aya..."
sudo docker service rm ecommerce_website-api || log "Layanan teu kapanggih atawa geus dihapus."

# Mupus gambar heubeul
confirm_action "Naha rék mupus gambar heubeul? (y/n)"
log "Mupus gambar heubeul..."
sudo docker rmi registry.codeoffice.xyz/all-avrist-assurance-ecommerce-website-api || log "Gambar teu kapanggih atawa geus dihapus."

# Muat gambar anyar
confirm_action "Naha rék muat gambar anyar? (y/n)"
log "Muat gambar anyar..."
sudo docker load < /home/avrist/repo/website-api/image/ecommerce-website-api.tar

# Ngadeploy
confirm_action "Naha rék ngadeploy stack anyar? (y/n)"
log "Ngadeploy stack anyar..."
sudo docker stack deploy -c /opt/avrist/backup/deploy/avrist/ecommerce/website-api/development.yml ecommerce

log "Deployment réngsé kalayan suksés."