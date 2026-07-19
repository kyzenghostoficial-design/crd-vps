#!/bin/bash
# CRD-VPS Setup Script
# This runs when you open the terminal for the first time
set -e
export DEBIAN_FRONTEND=noninteractive

echo ""
echo "============================================"
echo "  CRD-VPS: Instalando tudo automaticamente"
echo "============================================"
echo ""

sudo apt-get update -qq

echo "[1/4] Instalando XFCE4..."
sudo apt-get install -y --no-install-recommends xfce4 xfce4-terminal dbus-x11 wget 2>/dev/null

echo "[2/4] Instalando Google Chrome..."
wget -q https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb -O /tmp/chrome.deb
sudo apt-get install -y /tmp/chrome.deb 2>/dev/null || sudo apt-get -f install -y 2>/dev/null

echo "[3/4] Instalando Chrome Remote Desktop..."
wget -q https://dl.google.com/linux/direct/chrome-remote-desktop_current_amd64.deb -O /tmp/crd.deb
sudo apt-get install -y /tmp/crd.deb 2>/dev/null || sudo apt-get -f install -y 2>/dev/null

echo "[4/4] Configurando sessao XFCE..."
echo "exec /usr/bin/xfce4-session" | sudo tee /etc/chrome-remote-desktop-session

# If CRD_AUTH_CODE secret is set, configure automatically
if [ -n "$CRD_AUTH_CODE" ]; then
  echo ""
  echo "Configurando Chrome Remote Desktop com seu codigo..."
  DISPLAY= /opt/google/chrome-remote-desktop/start-host \
    --code="$CRD_AUTH_CODE" \
    --redirect-url="https://remotedesktop.google.com/_/oauthredirect" \
    --name=$(hostname) && echo "CRD configurado!" || echo "Codigo expirado - use setup-crd NOVO_CODIGO"
fi

# Mark as done so it doesn't run again
touch /tmp/.crd_setup_done

echo ""
echo "============================================"
echo "  PRONTO! Abra o app Chrome Remote Desktop"
echo "  no celular e conecte com seu PIN!"
echo "============================================"
