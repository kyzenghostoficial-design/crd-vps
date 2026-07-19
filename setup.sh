#!/bin/bash
export DEBIAN_FRONTEND=noninteractive
echo "=== Instalando XFCE4 + Chrome + CRD ==="
sudo apt-get update -qq
sudo apt-get install -y --no-install-recommends xfce4 xfce4-terminal dbus-x11 wget
wget -q https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb -O /tmp/chrome.deb
sudo apt-get install -y /tmp/chrome.deb || sudo apt-get -f install -y
wget -q https://dl.google.com/linux/direct/chrome-remote-desktop_current_amd64.deb -O /tmp/crd.deb
sudo apt-get install -y /tmp/crd.deb || sudo apt-get -f install -y
echo "exec /usr/bin/xfce4-session" | sudo tee /etc/chrome-remote-desktop-session
if [ -n "$CRD_AUTH_CODE" ]; then
  DISPLAY= /opt/google/chrome-remote-desktop/start-host \
    --code="$CRD_AUTH_CODE" \
    --redirect-url="https://remotedesktop.google.com/_/oauthredirect" \
    --name=$(hostname) && echo "CRD OK!" || echo "Codigo expirado"
fi
echo "=== PRONTO ==="
