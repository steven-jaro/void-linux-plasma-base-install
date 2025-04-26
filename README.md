Void Linux Plasma Base Install
This script automates the setup of a minimal Void Linux (glibc) installation with KDE Plasma, SDDM, PipeWire, and essential tools. It configures PipeWire to start automatically and ensures a "just works" experience for new users.

Features
Installs KDE Plasma, SDDM, and base utilities.
Configures PipeWire (with WirePlumber and PulseAudio integration) for audio.
Sets up Flatpak and Flathub.
Enables critical services (NetworkManager, elogind, dbus).
Automatic reboot after setup.

Prerequisites
A fresh minimal install of Void Linux (glibc).
Active internet connection.
sudo privileges for the user running the script.

Usage:
You will just have to run 5 commands:

sudo xbps-install -S git
git clone https://github.com/steven-jaro/void-linux-plasma-base-install.git
cd void-linux-plasma-base-install
chmod +x void-linux-plasma-base-install
sudo ./void-linux-plasma-base-install
