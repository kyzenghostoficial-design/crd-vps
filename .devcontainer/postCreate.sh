#!/bin/bash
set -e
export DEBIAN_FRONTEND=noninteractive
echo "📦 Atualizando pacotes..."
sudo apt-get update -qq 2>/dev/null
echo "🖥️ Instalando XFCE4..."
sudo apt-get install -y --no-install-recommends xfce4 xfce4-goodies xfce4-terminal dbus-x11 wget 2>/dev/null
echo "🌐 Instalando Google Chrome..."
wget -q https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb -O /tmp/chrome.deb
sudo apt-get install -y /tmp/chrome.deb 2>/dev/null || sudo apt-get -f install -y
echo "📥 Instalando Chrome Remote Desktop..."
wget -q https://dl.google.com/linux/direct/chrome-remote-desktop_current_amd64.deb -O /tmp/crd.deb
sudo apt-get install -y /tmp/crd.deb 2>/dev/null || sudo apt-get -f install -y
echo "exec /usr/bin/xfce4-session" | sudo tee /etc/chrome-remote-desktop-session
sudo tee /usr/local/bin/setup-crd > /dev/null <<'EOF'
#!/bin/bash
DISPLAY= /opt/google/chrome-remote-desktop/start-host \
  --code="$1" \
  --redirect-url="https://remotedesktop.google.com/_/oauthredirect" \
  --name=$(hostname)
echo "✅ Chrome Remote Desktop ativado!"
EOF
sudo chmod +x /usr/local/bin/setup-crd
if [ -n "$CRD_AUTH_CODE" ]; then
  echo "🚀 Configurando CRD automaticamente..."
  DISPLAY= /opt/google/chrome-remote-desktop/start-host \
    --code="$CRD_AUTH_CODE" \
    --redirect-url="https://remotedesktop.google.com/_/oauthredirect" \
    --name=$(hostname) && echo "✅ CRD configurado!" || echo "⚠️ Código expirado."
fi
echo "✅ Tudo instalado: XFCE4 + Google Chrome + Chrome Remote Desktop!"