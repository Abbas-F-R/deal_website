# Build Stage
FROM node:20-alpine AS builder

WORKDIR /app

# Copy package files
COPY package*.json ./

# Install dependencies
RUN npm ci --legacy-peer-deps --ignore-scripts

# Copy source code
COPY . .

# Build Vite/Vue app
RUN npm run build

# Production Stage
FROM node:20-alpine

WORKDIR /app

# Copy built application from builder
COPY --from=builder /app/dist /app/dist

# Install simple static file server with SPA routing support
RUN npm install -g sirv-cli

# Expose port
EXPOSE 3005

# Start the application using sirv
CMD ["sirv", "dist", "--port", "3005", "--host", "0.0.0.0", "--single"]