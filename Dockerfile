# Build Stage
FROM node:20-alpine AS builder

WORKDIR /app

# Copy package files
COPY package*.json ./

# Install dependencies
RUN npm ci --legacy-peer-deps --ignore-scripts

# Copy source code
COPY . .

# Build Nuxt app
RUN npm run build

# Production Stage
FROM node:20-alpine

WORKDIR /app

# Copy built application from builder
COPY --from=builder /app/.output /app/.output

# Expose port
EXPOSE 3004

# Set environment variables
ENV HOST=0.0.0.0
ENV PORT=3004
ENV NODE_ENV=production

# Start the application
CMD ["node", ".output/server/index.mjs"]