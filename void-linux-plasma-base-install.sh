#!/usr/bin/env bash
set -e

# Fix slow wifi card

echo "options iwlmvm power_scheme=1" | sudo tee /etc/modprobe.d/iwlmvm.conf

# Update system
xbps-install -Suvy

# Install essential packages
xbps-install -Suy \
  flatpak git base-devel gnome-software octoxbps \
  sddm kde-plasma kde-baseapps \
  NetworkManager kdegraphics-thumbnailers ffmpegthumbs \
  pipewire pipewire-devel alsa-pipewire \
  wireplumber elogind kdeconnect xorg noto-fonts-cjk \
  noto-fonts-emoji dejavu-fonts-ttf nano

xbps-install -Suvy
xbps-remove -Oovy

# Add Flathub
flatpak remote-add --if-not-exists flathub \
  https://flathub.org/repo/flathub.flatpakrepo

# Enable runit services
for svc in dbus elogind NetworkManager sddm; do
  ln -sf /etc/sv/$svc /var/service/
done

# Configure PipeWire autostart
sudo mkdir -p /etc/xdg/autostart/
sudo tee /etc/xdg/autostart/pipewire.desktop > /dev/null <<EOF
[Desktop Entry]
Type=Application
Name=PipeWire
Exec=/usr/local/bin/start-pipewire.sh
Comment=Start PipeWire Services
EOF

sudo tee /usr/local/bin/start-pipewire.sh > /dev/null <<EOF
#!/bin/sh
pipewire &
sleep 1
wireplumber &
sleep 1
pipewire-pulse &
EOF

sudo chmod +x /usr/local/bin/start-pipewire.sh


# Add user to the video and audio groups
usermod -aG audio,video $USER

# Reboot to apply changes
sudo reboot
