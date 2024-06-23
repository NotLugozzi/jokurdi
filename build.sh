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

mkdir -p /tmp/linux-firmware-neptune && \
    curl -Lo /tmp/linux-firmware-neptune/cs35l41-dsp1-spk-cali.bin https://gitlab.com/evlaV/linux-firmware-neptune/-/raw/jupiter-20240605.1/cs35l41-dsp1-spk-cali.bin && \
    curl -Lo /tmp/linux-firmware-neptune/cs35l41-dsp1-spk-cali.wmfw https://gitlab.com/evlaV/linux-firmware-neptune/-/raw/jupiter-20240605.1/cs35l41-dsp1-spk-cali.wmfw && \
    curl -Lo /tmp/linux-firmware-neptune/cs35l41-dsp1-spk-prot.bin https://gitlab.com/evlaV/linux-firmware-neptune/-/raw/jupiter-20240605.1/cs35l41-dsp1-spk-prot.bin && \
    curl -Lo /tmp/linux-firmware-neptune/cs35l41-dsp1-spk-prot.wmfw https://gitlab.com/evlaV/linux-firmware-neptune/-/raw/jupiter-20240605.1/cs35l41-dsp1-spk-prot.wmfw && \
    xz --check=crc32 /tmp/linux-firmware-neptune/cs35l41-dsp1-spk-{cali.bin,cali.wmfw,prot.bin,prot.wmfw} && \
    mv -vf /tmp/linux-firmware-neptune/* /usr/lib/firmware/cirrus/ && \
    rm -rf /tmp/linux-firmware-neptune && \
    mkdir -p /tmp/linux-firmware-galileo && \
    curl https://gitlab.com/evlaV/linux-firmware-neptune/-/archive/jupiter-20240605.1/linux-firmware-neptune-jupiter-20240605.1.tar.gz?path=ath11k/QCA206X -o /tmp/linux-firmware-galileo/ath11k.tar.gz && \
    tar --strip-components 1 --no-same-owner --no-same-permissions --no-overwrite-dir -xvf /tmp/linux-firmware-galileo/ath11k.tar.gz -C /tmp/linux-firmware-galileo && \
    xz --check=crc32 /tmp/linux-firmware-galileo/ath11k/QCA206X/hw2.1/* && \
    mv -vf /tmp/linux-firmware-galileo/ath11k/QCA206X /usr/lib/firmware/ath11k/QCA206X && \
    rm -rf /tmp/linux-firmware-galileo/ath11k && \
    rm -rf /tmp/linux-firmware-galileo/ath11k.tar.gz && \
    ln -s QCA206X /usr/lib/firmware/ath11k/QCA2066 && \
    curl -Lo /tmp/linux-firmware-galileo/hpbtfw21.tlv https://gitlab.com/evlaV/linux-firmware-neptune/-/raw/jupiter-20240605.1/qca/hpbtfw21.tlv && \
    curl -Lo /tmp/linux-firmware-galileo/hpnv21.309 https://gitlab.com/evlaV/linux-firmware-neptune/-/raw/jupiter-20240605.1/qca/hpnv21.309 && \
    curl -Lo /tmp/linux-firmware-galileo/hpnv21.bin https://gitlab.com/evlaV/linux-firmware-neptune/-/raw/jupiter-20240605.1/qca/hpnv21.bin && \
    curl -Lo /tmp/linux-firmware-galileo/hpnv21g.309 https://gitlab.com/evlaV/linux-firmware-neptune/-/raw/jupiter-20240605.1/qca/hpnv21g.309 && \
    curl -Lo /tmp/linux-firmware-galileo/hpnv21g.bin https://gitlab.com/evlaV/linux-firmware-neptune/-/raw/jupiter-20240605.1/qca/hpnv21g.bin && \
    xz --check=crc32 /tmp/linux-firmware-galileo/* && \
    mv -vf /tmp/linux-firmware-galileo/* /usr/lib/firmware/qca/ && \
    rm -rf /tmp/linux-firmware-galileo && \
    rm -rf /usr/share/alsa/ucm2/conf.d/acp5x/Valve-Jupiter-1.conf && \
    if [[ "${IMAGE_FLAVOR}" =~ "asus" ]]; then \
        curl -Lo /etc/yum.repos.d/_copr_lukenukem-asus-linux.repo https://copr.fedorainfracloud.org/coprs/lukenukem/asus-linux/repo/fedora-$(rpm -E %fedora)/lukenukem-asus-linux-fedora-$(rpm -E %fedora).repo && \
        rpm-ostree install asusctl asusctl-rog-gui && \
        git clone https://gitlab.com/asus-linux/firmware.git --depth 1 /tmp/asus-firmware && \
        cp -rf /tmp/asus-firmware/* /usr/lib/firmware/ && \
        rm -rf /tmp/asus-firmware \
    ; fi && \


rpm-ostree override remove mesa-va-drivers-freeworld
rpm-ostree override replace --experimental --from repo=copr:copr.fedorainfracloud.org:kylegospo:bazzite-multilib mesa-filesystem mesa-libxatracker mesa-libglapi mesa-dri-drivers mesa-libgbm mesa-libEGL mesa-vulkan-drivers mesa-libGL pipewire pipewire-alsa pipewire-gstreamer pipewire-jack-audio-connection-kit pipewire-jack-audio-connection-kit-libs pipewire-libs pipewire-pulseaudio pipewire-utils bluez bluez-obexd bluez-cups bluez-libs xorg-x11-server-Xwayland && \
rpm-ostree install mesa-va-drivers-freeworld mesa-vdpau-drivers-freeworld.x86_64 libaacs libbdplus libbluray 
rpm-ostree override replace --experimental --from repo=copr:copr.fedorainfracloud.org:sentry:switcheroo-control_discrete switcheroo-control 
rpm-ostree install @workstation-product-environment
rpm-ostree install screen blender discord firefox ffmpeg steam vlc
