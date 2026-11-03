FROM debian:forky-slim
ENV DEBIAN_FRONTEND=noninteractive

ARG DFP_VERSION=2.8.343

RUN apt-get update
RUN apt-get install -y --no-install-recommends \
    ca-certificates \
    ssh             \
    git             \
    curl            \
    udev            \
    libusb-1.0-0        \
    libhidapi-hidraw0   \
    libftdi1-2          \
    libjim-dev          \
    libusb-dev          \
    usbutils            \
    strace          \
    bash            \
    jq              \
    python3         \
    python3-pip     \
    build-essential \
    ninja-build     \
    cmake           \
    cmake-format    \
    avr-libc        \
    gcc-avr         \
    binutils-avr    \
    gdb             \
    gdb-avr         \
    clang-format    \
    clang-tidy      \
    clangd          \
    cppcheck        \
    graphviz        \
    doxygen         \
    unzip           \
    xz-utils
RUN rm -rf /var/lib/apt/lists/*

RUN mkdir -p /opt/Microchip/AVR-Dx_DFP/${DFP_VERSION}

RUN curl -L -o /tmp/xc8.tar.xz "https://ww1.microchip.com/downloads/aemDocuments/documents/DEV/ProductDocuments/SoftwareTools/xc8-v4.00-full-install-linux-x64.tar.xz" \
&& tar -xf /tmp/xc8.tar.xz -C /opt/Microchip \
&& rm /tmp/xc8.tar.xz

RUN curl -L -o /tmp/avr-dx.atpack "https://packs.download.microchip.com/Microchip.AVR-Dx_DFP.${DFP_VERSION}.atpack" && \
unzip -q /tmp/avr-dx.atpack -d /opt/Microchip/AVR-Dx_DFP/${DFP_VERSION} \
&& rm /tmp/avr-dx.atpack

# Snap debugger firmware? Couldn't a link to download it, downloaded by the VSCode MPLAB extension pack.
ADD Snap_TP.tar.xz /opt/Microchip

# For the debugger extension, seems to be no way of specifying a different path
RUN mkdir /root/.mchp_packs && cp -r /opt/Microchip/* /root/.mchp_packs/

WORKDIR /workspace