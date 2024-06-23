#!/bin/bash

set -ouex pipefail

RELEASE="$(rpm -E %fedora)"

## Update Packages before installing

rpm-ostree override replace --experimental --from repo=updates vulkan-loader || true && \
rpm-ostree override replace --experimental --from repo=updates alsa-lib || true && \
rpm-ostree override replace --experimental --from repo=updates gnutils || true && \
rpm-ostree override replace --experimental --from repo=updates glib2 || true && \
rpm-ostree override replace --experimental --from repo=updates gtk3 || true && \
rpm-ostree override replace --experimental --from repo=updates atk || true && \
rpm-ostree override replace --experimental --from repo=updates at-spi2-atk || true && \
rpm-ostree override replace --experimental --from repo=updates libaom || true && \
rpm-ostree override replace \
    --experimental \
    --from repo=updates \
        gstreamer1 \
        gstreamer1-plugins-base \
        gstreamer1-plugins-bad-free-libs \
        gstreamer1-plugins-good-qt \
        gstreamer1-plugins-good \
        gstreamer1-plugins-bad-free \
        gstreamer1-plugin-libav \
        gstreamer1-plugins-ugly-free \
        || true && \
rpm-ostree override replace --experimental --from repo=updates python3 || true && \
rpm-ostree override replace --experimental --from repo=updates python3-libs || true && \
rpm-ostree override replace --experimental --from repo=updates libdecor || true && \
rpm-ostree override replace --experimental --from repo=updates libtirpc || true && \
rpm-ostree override replace --experimental --from repo=updates libuuid || true && \
rpm-ostree override replace --experimental --from repo=updates libblkid || true && \
rpm-ostree override replace --experimental --from repo=updates libmount || true && \
rpm-ostree override replace --experimental --from repo=updates cups-lib || true && \
rpm-ostree override replace --experimental --from repo=updates libinput || true && \
rpm-ostree override replace --experimental --from repo=updates llvm-libs || true && \
rpm-ostree override replace --experimental --from repo=updates fontconfig || true && \
rpm-ostree override replace --experimental --from repo=updates glibc32 || true && \


rpm-ostree override remove mesa-va-drivers-freeworld
rpm-ostree override replace --experimental --from repo=copr:copr.fedorainfracloud.org:kylegospo:bazzite-multilib mesa-filesystem mesa-libxatracker mesa-libglapi mesa-dri-drivers mesa-libgbm mesa-libEGL mesa-vulkan-drivers mesa-libGL pipewire pipewire-alsa pipewire-gstreamer pipewire-jack-audio-connection-kit pipewire-jack-audio-connection-kit-libs pipewire-libs pipewire-pulseaudio pipewire-utils bluez bluez-obexd bluez-cups bluez-libs xorg-x11-server-Xwayland && \
rpm-ostree install mesa-va-drivers-freeworld mesa-vdpau-drivers-freeworld.x86_64 libaacs libbdplus libbluray 
rpm-ostree override replace --experimental --from repo=copr:copr.fedorainfracloud.org:sentry:switcheroo-control_discrete switcheroo-control 
rpm-ostree install @workstation-product-environment
rpm-ostree install screen blender discord firefox ffmpeg steam vlc
