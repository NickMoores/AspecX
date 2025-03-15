FROM debian:bullseye

ARG S6_OVERLAY_VERSION=3.2.0.2

# Setup demo environment variables
ENV HOME=/root \
    DEBIAN_FRONTEND=noninteractive \
    LANG=en_US.UTF-8 \
    LANGUAGE=en_US.UTF-8 \
    LC_ALL=C.UTF-8 \
    DISPLAY=:0.0 \
    DISPLAY_WIDTH=1920 \
    DISPLAY_HEIGHT=1080 \
    URL=https://www.google.co.uk \
    PULSE_SERVER=unix:/var/run/pulse/native

# Install git, supervisor, VNC, & X11 packages
RUN set -ex; \
    apt-get update; \
    apt-get install -y \
      bash \
      chromium \
      chromium-driver \
      dbus-x11 \
      fonts-liberation \
      fluxbox \
      net-tools \
      novnc \
      python3 \
      python3-pip \
      python3-venv \
      pulseaudio \
      unzip \
      x11vnc \
      xvfb \
      xz-utils \
      && rm -rf /var/lib/apt/lists/*

# Setup PulseAudio
RUN mkdir -p /var/run/pulse /var/lib/pulse /root/.config/pulse && \
    chown -R root:pulse-access /var/run/pulse /var/lib/pulse /root/.config/pulse && \
    echo "enable-shm = no" >> /etc/pulse/daemon.conf && \
    adduser root pulse-access && \
    mkdir -p /var/run/dbus && \
    dbus-uuidgen > /var/lib/dbus/machine-id

# Install s6-overlay
ADD https://github.com/just-containers/s6-overlay/releases/download/v${S6_OVERLAY_VERSION}/s6-overlay-noarch.tar.xz /tmp
RUN tar -C / -Jxpf /tmp/s6-overlay-noarch.tar.xz
ADD https://github.com/just-containers/s6-overlay/releases/download/v${S6_OVERLAY_VERSION}/s6-overlay-x86_64.tar.xz /tmp
RUN tar -C / -Jxpf /tmp/s6-overlay-x86_64.tar.xz

RUN  python3 -m venv /venv \
    && /venv/bin/pip install --upgrade pip \
    && /venv/bin/pip install --no-cache-dir selenium 

COPY ./s6-rc.d /etc/s6-overlay/s6-rc.d
COPY ./init.d /init.d
COPY ./app /app

RUN chmod +x /init.d/pulseaudio-init.sh

ENTRYPOINT ["/init"]

EXPOSE 80