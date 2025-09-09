# Multi-stage build for Botpress v12
FROM node:12-alpine AS base

# Install dependencies
FROM base AS deps
RUN apk add --no-cache libc6-compat python3 make g++
WORKDIR /app

# Copy package files
COPY package.json yarn.lock ./
COPY packages ./packages
COPY build ./build

# Install dependencies
RUN yarn install --frozen-lockfile --production=false

# Build stage
FROM base AS builder
WORKDIR /app
COPY --from=deps /app/node_modules ./node_modules
COPY . .

# Build the application
RUN yarn build

# Production stage
FROM base AS runner
WORKDIR /app

ENV NODE_ENV production
ENV BP_HOST 0.0.0.0
ENV PORT 3000

RUN addgroup --system --gid 1001 botpress
RUN adduser --system --uid 1001 botpress

# Copy built application
COPY --from=builder --chown=botpress:botpress /app/build ./build
COPY --from=builder --chown=botpress:botpress /app/packages ./packages
COPY --from=builder --chown=botpress:botpress /app/node_modules ./node_modules
COPY --from=builder --chown=botpress:botpress /app/package.json ./

# Create data directory for botpress
RUN mkdir -p /app/data && chown botpress:botpress /app/data

USER botpress

EXPOSE 3000

VOLUME ["/app/data"]

CMD ["yarn", "start"]
