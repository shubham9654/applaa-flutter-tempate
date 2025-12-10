# Docker Setup for Applaa Flutter Template

This project includes multiple Docker configurations for building and running the Flutter app in different environments.

## 📦 Available Dockerfiles

1. **`Dockerfile`** - Main multi-stage build for production web
2. **`Dockerfile.android`** - Android APK/AAB builds
3. **`Dockerfile.dev`** - Development environment with hot reload

## 🚀 Quick Start

### Build and Run Web Production Server

```bash
# Build the image
docker build -t applaa-web .

# Run the container
docker run -d -p 8080:80 --name applaa-web applaa-web

# Access the app at http://localhost:8080
```

### Using Docker Compose

```bash
# Production web server
docker-compose up -d

# Development server (with hot reload)
docker-compose -f docker-compose.yml up dev

# Production with custom config
docker-compose -f docker-compose.prod.yml up -d
```

## 🛠️ Build Targets

### Web Server (Production)
```bash
docker build --target web-server -t applaa-web .
docker run -p 8080:80 applaa-web
```

### Android APK
```bash
docker build -f Dockerfile.android --target apk -t applaa-android .
docker run --rm -v $(pwd)/build:/output applaa-android cp /app/build/app/outputs/flutter-apk/app-release.apk /output/
```

### Android App Bundle (AAB)
```bash
docker build -f Dockerfile.android --target aab -t applaa-android .
docker run --rm -v $(pwd)/build:/output applaa-android cp /app/build/app/outputs/bundle/release/app-release.aab /output/
```

## 📝 Development

### Development Server with Hot Reload

```bash
# Build dev image
docker build -f Dockerfile.dev -t applaa-dev .

# Run with volume mount for hot reload
docker run -it \
  -p 8080:8080 \
  -v $(pwd):/app \
  -v flutter_pub_cache:/root/.pub-cache \
  applaa-dev

# Or use docker-compose
docker-compose up dev
```

## 🔧 Configuration

### Environment Variables

```bash
# Web server
NGINX_HOST=localhost
NGINX_PORT=80

# Development
FLUTTER_WEB_USE_SKIA=false
```

### Custom Nginx Configuration

Create `nginx.conf` and mount it:

```dockerfile
volumes:
  - ./nginx.conf:/etc/nginx/conf.d/default.conf:ro
```

## 📊 Multi-Stage Build Stages

The main `Dockerfile` uses multi-stage builds:

1. **build** - Base Flutter environment
2. **web-build** - Flutter web build
3. **android-apk** - Android APK build
4. **android-aab** - Android App Bundle build
5. **web-server** - Production nginx server

## 🐳 Docker Compose Services

### Production (`docker-compose.yml`)
- **web**: Production nginx server on port 8080

### Development (`docker-compose.yml`)
- **dev**: Development server with hot reload

### Production Extended (`docker-compose.prod.yml`)
- **web**: Production server on ports 80/443 with Traefik labels

## 📦 Output Artifacts

### Web Build
- Location: `/app/build/web`
- Served by: nginx on port 80

### Android APK
- Location: `/app/build/app/outputs/flutter-apk/app-release.apk`
- Platform: ARM, ARM64, x64

### Android AAB
- Location: `/app/build/app/outputs/bundle/release/app-release.aab`
- For: Google Play Store upload

## 🔍 Health Checks

The web server includes a health check endpoint:

```bash
curl http://localhost:8080/health
# Returns: healthy
```

## 🚀 Deployment Examples

### Deploy to Cloud

```bash
# Build and tag
docker build -t your-registry/applaa:latest .

# Push to registry
docker push your-registry/applaa:latest

# Deploy
docker pull your-registry/applaa:latest
docker run -d -p 80:80 your-registry/applaa:latest
```

### Build for Multiple Platforms

```bash
# Build for linux/amd64
docker buildx build --platform linux/amd64 -t applaa-web .

# Build for linux/arm64
docker buildx build --platform linux/arm64 -t applaa-web .

# Build for both
docker buildx build --platform linux/amd64,linux/arm64 -t applaa-web .
```

## 🔐 Security

The Dockerfile includes:
- ✅ Non-root user (nginx runs as nginx user)
- ✅ Security headers in nginx config
- ✅ Minimal base images (alpine)
- ✅ No sensitive data in images

## 📚 Troubleshooting

### Build Fails
```bash
# Clean Docker cache
docker system prune -a

# Rebuild without cache
docker build --no-cache -t applaa-web .
```

### Port Already in Use
```bash
# Use different port
docker run -p 8081:80 applaa-web
```

### Hot Reload Not Working
```bash
# Ensure volume mounts are correct
docker run -v $(pwd):/app -v flutter_pub_cache:/root/.pub-cache ...
```

## 📖 Additional Resources

- [Flutter Web Deployment](https://docs.flutter.dev/deployment/web)
- [Docker Multi-stage Builds](https://docs.docker.com/build/building/multi-stage/)
- [Nginx Configuration](https://nginx.org/en/docs/)

