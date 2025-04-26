#!/usr/bin/env bash
set -e

### 1. Instalar paquetes esenciales ###
xbps-install -Suy \
  flatpak git base-devel gnome-software octoxbps \
  sddm kde-plasma kde-baseapps \
  NetworkManager kdegraphics-thumbnailers ffmpegthumbs \
  pipewire pipewire-devel alsa-pipewire \
  wireplumber elogind kdeconnect

### 2. Añadir Flathub a Flatpak ###
flatpak remote-add --if-not-exists flathub \
  https://flathub.org/repo/flathub.flatpakrepo

### 3. Crear y copiar el script de arranque global ###
install -Dm755 ~/.local/bin/start-pipewire /usr/local/bin/start-pipewire

### 4. Crear servicio runit “pipewire-global” ###
mkdir -p /etc/sv/pipewire-global

cat > /etc/sv/pipewire-global/run << 'EOF'
#!/bin/sh
# Servicio runit: inicia PipeWire + WirePlumber + pipewire-pulse
exec 2>&1
exec /usr/local/bin/start-pipewire
EOF
chmod +x /etc/sv/pipewire-global/run

# Logging opcional
mkdir -p /etc/sv/pipewire-global/log
cat > /etc/sv/pipewire-global/log/run << 'EOF'
#!/bin/sh
exec svlogd -tt /var/log/pipewire-global
EOF
chmod +x /etc/sv/pipewire-global/log/run

### 5. Habilitar servicios runit ###
for svc in \
    dbus \
    elogind \
    NetworkManager \
    sddm; do
  ln -sf /etc/sv/$svc /var/service/
done

sudo reboot
