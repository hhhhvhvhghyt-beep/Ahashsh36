#!/usr/bin/env bash
# نصب و دیپلوی خودکار پنل v2ray (3x-ui) با همه پیش‌نیازها
set -e
[ "$EUID" -ne 0 ] && echo "با root اجرا کنید: sudo bash install.sh" && exit 1

echo ">>> نصب پیش‌نیازها"
apt-get update -y
apt-get install -y curl wget unzip ca-certificates ufw

if ! command -v docker >/dev/null 2>&1; then
  echo ">>> نصب Docker"
  curl -fsSL https://get.docker.com | sh
  systemctl enable --now docker
fi

echo ">>> باز کردن پورت‌ها"
ufw allow 22/tcp || true
ufw allow 2053/tcp || true
ufw allow 443/tcp || true
ufw --force enable || true

echo ">>> بیلد و اجرای پنل"
cd "$(dirname "$0")"
docker compose up -d --build

IP=$(curl -s ifconfig.me || hostname -I | awk '{print $1}')
echo "=============================================="
echo "پنل آماده است:  http://$IP:2053"
echo "یوزر/پس: admin / admin  (حتماً فوراً تغییر دهید)"
echo "=============================================="
