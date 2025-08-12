FROM node:18-alpine
RUN apk add --no-cache openssl

EXPOSE 3000

WORKDIR /app

ENV NODE_ENV=production

COPY package.json package-lock.json* ./

# Fix: Remove lock files and install fresh to handle platform-specific binaries
RUN rm -f package-lock.json && \
    npm install --omit=dev && \
    npm cache clean --force

# Remove CLI packages since we don't need them in production by default.
# Remove this line if you want to run CLI commands in your container.
RUN npm remove @shopify/cli

COPY . .

# Fix: Rebuild native dependencies for Alpine Linux before building
RUN npm rebuild && npm run build

CMD ["npm", "start"]