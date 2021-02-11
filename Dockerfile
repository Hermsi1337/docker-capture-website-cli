ARG         NODE_VERSION="15"
FROM        quay.io/bitnami/node:${NODE_VERSION}

ADD         https://github.com/Yelp/dumb-init/releases/download/v1.2.2/dumb-init_1.2.2_amd64 /usr/local/bin/dumb-init

ENV         PUPPETEER_SKIP_CHROMIUM_DOWNLOAD="true" \
            PUPPETEER_EXECUTABLE_PATH="/usr/bin/google-chrome-stable"

RUN         set -x && apt-get update \
            && apt-get install -y wget gnupg \
            && wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add - \
            && sh -c 'echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google.list' \
            && apt-get update \
            && apt-get install -y google-chrome-stable fonts-ipafont-gothic fonts-wqy-zenhei fonts-thai-tlwg fonts-kacst fonts-freefont-ttf libxss1 \
              --no-install-recommends \
            && chmod +x /usr/local/bin/dumb-init \
            && yarn global add capture-website-cli \
            && groupadd -r pptruser && useradd -r -g pptruser -G audio,video pptruser \
            && mkdir -p /home/pptruser/Downloads \
            && chown -R pptruser:pptruser /home/pptruser \
            && chown -R pptruser:pptruser /usr/local/share/.config/yarn/global \
            && apt-get autoremove -y && apt-get -y autoclean \
            && rm -rf /var/lib/apt/lists/* /tmp/* /var/cache/*

USER        pptruser

ENTRYPOINT  ["dumb-init", "--"]
