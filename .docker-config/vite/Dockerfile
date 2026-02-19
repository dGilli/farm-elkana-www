FROM node:22

WORKDIR /app

COPY .docker-config/vite/vite.config.ts /usr/vite/
COPY client/package*.json /usr/vite/

RUN cd /usr/vite && npm install

CMD npm install --no-package-lock \
    && \
    npm run dev -- --config /usr/vite/vite.config.ts
