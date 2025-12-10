# Scripts Directory

This directory contains utility scripts for building, deploying, and managing the application.

## 📜 Available Scripts

### Docker Scripts

#### `build-and-push-docker.bat` / `build-and-push-docker.sh`
Builds and pushes Docker images to Docker Hub.

**Usage:**
```bash
# Windows
scripts\build-and-push-docker.bat [tag]

# Linux/Mac
chmod +x scripts/build-and-push-docker.sh
./scripts/build-and-push-docker.sh [tag]
```

**Examples:**
```bash
# Build and push with 'latest' tag
scripts\build-and-push-docker.bat latest

# Build and push with version tag
scripts\build-and-push-docker.bat v1.0.0
```

**What it does:**
1. Builds the Docker image
2. Tags it appropriately
3. Pushes to Docker Hub (shubham9654/applaa-template)

**Prerequisites:**
- Docker installed and running
- Logged in to Docker Hub (`docker login`)

---

#### `check-docker-installation.bat`
Checks if Docker is installed and provides installation guidance if not.

**Usage:**
```bash
scripts\check-docker-installation.bat
```

**What it does:**
- Checks if Docker is installed
- Verifies Docker daemon is running
- Provides installation instructions if Docker is missing

---

## 🚀 Quick Start

1. **Check Docker installation:**
   ```bash
   scripts\check-docker-installation.bat
   ```

2. **Build and push Docker image:**
   ```bash
   scripts\build-and-push-docker.bat latest
   ```

---

## 📚 Documentation

For more detailed information, see:
- [Docker Deployment Guide](../docs/DOCKER_DEPLOYMENT.md)
- [Docker Installation Guide](../docs/DOCKER_INSTALLATION_WINDOWS.md)

---

## 🔧 Adding New Scripts

When adding new scripts:
1. Place them in the `scripts/` directory
2. Update this README with usage instructions
3. Ensure scripts are executable (Linux/Mac): `chmod +x script.sh`

