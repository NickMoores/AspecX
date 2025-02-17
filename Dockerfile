FROM debian:bullseye

# Setup demo environment variables
ENV HOME=/root \
    DEBIAN_FRONTEND=noninteractive \
    LANG=en_US.UTF-8 \
    LANGUAGE=en_US.UTF-8 \
    LC_ALL=C.UTF-8 \
    DISPLAY=:0.0 \
    DISPLAY_WIDTH=1920 \
    DISPLAY_HEIGHT=1080 \
    URL=https://www.google.co.uk

# Install git, supervisor, VNC, & X11 packages
RUN set -ex; \
    apt-get update; \
    apt-get install -y \
      bash \
      git \
      net-tools \
      novnc \
      supervisor \
      unzip \
      x11vnc \
      xvfb

RUN wget -O /tmp/google-chrome.deb https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb \
    && apt-get update \
    && apt-get install -y --no-install-recommends /tmp/google-chrome.deb \
    && rm /tmp/google-chrome.deb \
    && rm -rf /var/lib/apt/lists/*

RUN wget -O /tmp/chromedriver_linux64.zip https://storage.googleapis.com/chrome-for-testing-public/133.0.6943.98/linux64/chromedriver-linux64.zip \
    && unzip -j /tmp/chromedriver_linux64.zip -d /usr/local/bin/ \
    && chmod +x /usr/local/bin/chromedriver \
    && rm /tmp/chromedriver_linux64.zip

RUN  python3 -m venv /venv \
    && /venv/bin/pip install --upgrade pip \
    && /venv/bin/pip install --no-cache-dir selenium 
    
COPY . /app

ENTRYPOINT ["/app/entrypoint.sh"]

EXPOSE 80
