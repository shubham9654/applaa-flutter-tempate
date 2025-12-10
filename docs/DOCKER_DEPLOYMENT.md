# Docker Deployment Guide

## 🐳 Building and Pushing Docker Images

### Prerequisites

1. **Install Docker Desktop**
   - Download from: https://www.docker.com/products/docker-desktop
   - Ensure Docker is running

2. **Login to Docker Hub**
   ```bash
   docker login
   # Enter your Docker Hub username and password
   ```

### Quick Build and Push

#### Option 1: Using the Script (Recommended)

**Windows:**
```bash
scripts\build-and-push-docker.bat latest
```

**Linux/Mac:**
```bash
chmod +x scripts/build-and-push-docker.sh
./scripts/build-and-push-docker.sh latest
```

#### Option 2: Manual Commands (Simplified)

```bash
# 1. Build the image
docker build -t shubham9654/applaa-template:latest -f Dockerfile --target web-server .

# 2. Push to Docker Hub
docker push shubham9654/applaa-template:latest
```

#### Option 2: Manual Commands

```bash
# 1. Build the image
docker build -t shubham9654/applaa-template:latest -f Dockerfile --target web-server .

# 2. Tag with version (optional)
docker tag shubham9654/applaa-template:latest shubham9654/applaa-template:v1.0.0

# 3. Push to Docker Hub
docker push shubham9654/applaa-template:latest
docker push shubham9654/applaa-template:v1.0.0
```

### Available Tags

- `latest` - Latest stable build
- `v1.0.0` - Version-specific tag
- `dev` - Development build
- `beta` - Beta release

### Pull and Run

```bash
# Pull the image
docker pull shubham9654/applaa-template:latest

# Run the container
docker run -d -p 8080:80 --name applaa-web shubham9654/applaa-template:latest

# Access at http://localhost:8080
```

### Docker Hub Repository

**Repository:** https://hub.docker.com/r/shubham9654/applaa-template

**Pull Command:**
```bash
docker pull shubham9654/applaa-template:latest
```

### CI/CD Integration

#### GitHub Actions Example

```yaml
name: Build and Push Docker Image

on:
  push:
    tags:
      - 'v*'

jobs:
  build-and-push:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      
      - name: Set up Docker Buildx
        uses: docker/setup-buildx-action@v2
      
      - name: Login to Docker Hub
        uses: docker/login-action@v2
        with:
          username: ${{ secrets.DOCKER_USERNAME }}
          password: ${{ secrets.DOCKER_PASSWORD }}
      
      - name: Extract version tag
        id: tag
        run: echo "TAG=${GITHUB_REF#refs/tags/}" >> $GITHUB_OUTPUT
      
      - name: Build and push
        uses: docker/build-push-action@v4
        with:
          context: .
          file: ./Dockerfile
          target: web-server
          push: true
          tags: |
            shubham9654/applaa-template:${{ steps.tag.outputs.TAG }}
            shubham9654/applaa-template:latest
```

### Multi-Platform Builds

Build for multiple architectures:

```bash
# Create buildx builder
docker buildx create --name multiplatform --use

# Build for multiple platforms
docker buildx build \
  --platform linux/amd64,linux/arm64 \
  -t shubham9654/applaa-template:latest \
  -f Dockerfile \
  --target web-server \
  --push .
```

### Verification

After pushing, verify the image:

```bash
# Check image details
docker inspect shubham9654/applaa-template:latest

# Test locally
docker run -d -p 8080:80 shubham9654/applaa-template:latest
curl http://localhost:8080/health
```

### Troubleshooting

**Build fails:**
```bash
# Clean Docker cache
docker system prune -a

# Rebuild without cache
docker build --no-cache -t shubham9654/applaa-template:latest .
```

**Push fails:**
```bash
# Verify login
docker login

# Check image exists
docker images | grep applaa-template
```

**Permission denied:**
```bash
# Ensure you're logged in with correct account
docker logout
docker login
```

### Image Size Optimization

The current image uses multi-stage builds to minimize size:
- Base: ~200MB (Flutter SDK)
- Final: ~50MB (nginx alpine)

### Security Best Practices

1. ✅ Use specific tags (not just `latest`)
2. ✅ Scan images for vulnerabilities
3. ✅ Use non-root user (already configured)
4. ✅ Keep base images updated
5. ✅ Don't include secrets in images

### Automated Builds

Set up automated builds on Docker Hub:
1. Go to Docker Hub → Create Repository
2. Connect GitHub repository
3. Configure build rules
4. Enable automated builds

---

**Quick Reference:**
- Build: `docker build -t shubham9654/applaa-template:latest .`
- Push: `docker push shubham9654/applaa-template:latest`
- Pull: `docker pull shubham9654/applaa-template:latest`
- Run: `docker run -d -p 8080:80 shubham9654/applaa-template:latest`

