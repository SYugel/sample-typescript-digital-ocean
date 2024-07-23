FROM node:20-alpine AS builder
WORKDIR /app
COPY . .
RUN yarn install --frozen-lockfile
RUN yarn build

FROM node:20-alpine

# --- START INSTALL chromium for PUPPATEER ---
RUN apk add --no-cache chromium ca-certificates
ENV PUPPETEER_SKIP_CHROMIUM_DOWNLOAD true
ENV PUPPETEER_EXECUTABLE_PATH /usr/bin/chromium-browser
# --- END ---

WORKDIR /app
COPY --from=builder /app/dist /app/dist

COPY views .
COPY package.json .
COPY yarn.lock .
RUN yarn install --frozen-lockfile
EXPOSE 3000

ENTRYPOINT [ "node", "dist/www.js" ]
