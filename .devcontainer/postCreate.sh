#!/bin/bash
# Always exit 0 so container never enters recovery mode
set +e
export DEBIAN_FRONTEND=noninteractive
LOG=/tmp/crd-setup.log

echo "=== CRD-VPS Setup ===" | tee $LOG
sudo apt-get update -qq >> $LOG 2>&1 || true

echo "Installing XFCE4..." | tee -a $LOG
sudo apt-get install -y --no-install-recommends xfce4 xfce4-terminal dbus-x11 wget >> $LOG 2>&1 || true

echo "Installing Google Chrome..." | tee -a $LOG
wget -q https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb -O /tmp/chrome.deb >> $LOG 2>&1 || true
sudo apt-get install -y /tmp/chrome.deb >> $LOG 2>&1 || sudo apt-get -f install -y >> $LOG 2>&1 || true

echo "Installing Chrome Remote Desktop..." | tee -a $LOG
wget -q https://dl.google.com/linux/direct/chrome-remote-desktop_current_amd64.deb -O /tmp/crd.deb >> $LOG 2>&1 || true
sudo apt-get install -y /tmp/crd.deb >> $LOG 2>&1 || sudo apt-get -f install -y >> $LOG 2>&1 || true

echo "exec /usr/bin/xfce4-session" | sudo tee /etc/chrome-remote-desktop-session >> $LOG 2>&1 || true

sudo tee /usr/local/bin/setup-crd > /dev/null << 'EOF'
#!/bin/bash
DISPLAY= /opt/google/chrome-remote-desktop/start-host \
  --code="$1" \
  --redirect-url="https://remotedesktop.google.com/_/oauthredirect" \
  --name=$(hostname) && echo "Conecte pelo app Chrome Remote Desktop no celular!"
EOF
sudo chmod +x /usr/local/bin/setup-crd || true

if [ -n "$CRD_AUTH_CODE" ]; then
  echo "Auto-configure CRD..." | tee -a $LOG
  DISPLAY= /opt/google/chrome-remote-desktop/start-host \
    --code="$CRD_AUTH_CODE" \
    --redirect-url="https://remotedesktop.google.com/_/oauthredirect" \
    --name=$(hostname) >> $LOG 2>&1 || echo "Code expired" | tee -a $LOG
fi

echo "=== DONE ===" | tee -a $LOG
exit 0
