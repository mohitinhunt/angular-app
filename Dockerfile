# Stage 1: Build the Angular application
FROM node:18-alpine AS builder
WORKDIR /app
COPY package*.json ./
RUN npm ci
COPY . .
RUN npm run build -- --configuration=production

# Stage 2: Serve the application without Nginx
FROM node:18-alpine
WORKDIR /app
# Install a simple, secure production web server
RUN npm install -g http-server
# Copy the built assets from the builder stage
COPY --from=builder /app/dist /app/dist

EXPOSE 4200

# Run http-server targeting your specific build output directory
# -p 4200 sets the port, --proxy handles SPA routing fallback to index.html
CMD ["http-server", "dist/demo-app/browser", "-p", "8080", "-a", "0.0.0.0"]
