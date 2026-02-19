FROM mcr.microsoft.com/playwright:v1.58.2-noble

WORKDIR /app

CMD npm install \
    && \
    npx playwright test --ui --ui-port 80 --ui-host 0.0.0.0
