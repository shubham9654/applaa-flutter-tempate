# Multi-stage Dockerfile for Flutter Web App
# Production build optimized for web deployment

# ============================================
# Stage 1: Flutter Build Environment
# ============================================
# Using Debian base and installing Flutter 3.27.0 (includes Dart 3.6.0+)
FROM debian:bookworm-slim AS build

# Install dependencies
RUN apt-get update && apt-get install -y \
    curl \
    git \
    unzip \
    xz-utils \
    zip \
    libglu1-mesa \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*

# Set working directory
WORKDIR /usr/local

# Install Flutter SDK (version 3.27.0 includes Dart 3.6.0)
RUN git clone https://github.com/flutter/flutter.git -b stable --depth 1 && \
    flutter/bin/flutter --version

# Add Flutter to PATH
ENV PATH="/usr/local/flutter/bin:/usr/local/flutter/bin/cache/dart-sdk/bin:${PATH}"

# Set working directory for app
WORKDIR /app

# Enable web platform
RUN flutter config --enable-web

# Copy dependency files first for better caching
COPY pubspec.yaml pubspec.lock ./

# Get Flutter dependencies
RUN flutter pub get

# Copy application source code
COPY . .

# Verify Flutter setup
RUN flutter doctor -v

# ============================================
# Stage 2A: Web Build
# ============================================
FROM build AS web-build

# Build web app with release optimizations
# Note: --web-renderer flag is deprecated in Flutter 3.27+, renderer is auto-selected
RUN flutter build web \
    --release \
    --dart-define=FLUTTER_WEB_AUTO_DETECT=true

# ============================================
# Stage 3: Web Production Server
# ============================================
FROM nginx:alpine AS web-server

# Install additional nginx modules if needed
RUN apk add --no-cache curl

# Copy built web files from web-build stage
COPY --from=web-build /app/build/web /usr/share/nginx/html

# Create nginx configuration optimized for Flutter web
RUN printf '%s\n' \
    'server {' \
    '    listen 80;' \
    '    server_name _;' \
    '    root /usr/share/nginx/html;' \
    '    index index.html;' \
    '    ' \
    '    # Enable gzip compression' \
    '    gzip on;' \
    '    gzip_vary on;' \
    '    gzip_min_length 1024;' \
    '    gzip_proxied any;' \
    '    gzip_comp_level 6;' \
    '    gzip_types' \
    '        text/plain' \
    '        text/css' \
    '        text/xml' \
    '        text/javascript' \
    '        application/javascript' \
    '        application/json' \
    '        application/xml+rss' \
    '        application/atom+xml' \
    '        image/svg+xml;' \
    '    ' \
    '    # Security headers' \
    '    add_header X-Frame-Options "SAMEORIGIN" always;' \
    '    add_header X-Content-Type-Options "nosniff" always;' \
    '    add_header X-XSS-Protection "1; mode=block" always;' \
    '    add_header Referrer-Policy "no-referrer-when-downgrade" always;' \
    '    ' \
    '    # Handle Flutter web routing (SPA)' \
    '    location / {' \
    '        try_files $uri $uri/ /index.html;' \
    '    }' \
    '    ' \
    '    # Cache static assets' \
    '    location ~* \.(jpg|jpeg|png|gif|ico|css|js|svg|woff|woff2|ttf|eot|wasm)$ {' \
    '        expires 1y;' \
    '        add_header Cache-Control "public, immutable";' \
    '        access_log off;' \
    '    }' \
    '    ' \
    '    # Health check endpoint' \
    '    location /health {' \
    '        access_log off;' \
    '        return 200 "healthy\n";' \
    '        add_header Content-Type text/plain;' \
    '    }' \
    '    ' \
    '    # Disable access to hidden files' \
    '    location ~ /\. {' \
    '        deny all;' \
    '        access_log off;' \
    '        log_not_found off;' \
    '    }' \
    '}' \
    > /etc/nginx/conf.d/default.conf

# Expose port 80
EXPOSE 80

# Health check
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
    CMD curl -f http://localhost/health || exit 1

# Start nginx
CMD ["nginx", "-g", "daemon off;"]
