# Docker Installation Guide for Windows

## 🐳 Installing Docker Desktop on Windows

### Prerequisites

**System Requirements:**
- Windows 10 64-bit: Pro, Enterprise, or Education (Build 19041 or higher)
- Windows 11 64-bit: Home or Pro (Build 22000 or higher)
- WSL 2 feature enabled
- Virtualization enabled in BIOS

### Step 1: Check Your Windows Version

1. Press `Win + R`, type `winver`, and press Enter
2. Verify you have Windows 10 (Build 19041+) or Windows 11

### Step 2: Enable WSL 2 (Windows Subsystem for Linux)

**Option A: Using PowerShell (Recommended)**

Open PowerShell as **Administrator** and run:

```powershell
# Enable WSL
dism.exe /online /enable-feature /featurename:Microsoft-Windows-Subsystem-Linux /all /norestart

# Enable Virtual Machine Platform
dism.exe /online /enable-feature /featurename:VirtualMachinePlatform /all /norestart

# Restart your computer
Restart-Computer
```

After restart, set WSL 2 as default:

```powershell
wsl --set-default-version 2
```

**Option B: Using Windows Features GUI**

1. Press `Win + X` and select **"Windows PowerShell (Admin)"** or **"Terminal (Admin)"**
2. Open **"Turn Windows features on or off"**
3. Check:
   - ☑️ **Windows Subsystem for Linux**
   - ☑️ **Virtual Machine Platform**
4. Click **OK** and restart when prompted

### Step 3: Download Docker Desktop

**Direct Download:**
- Go to: https://www.docker.com/products/docker-desktop/
- Click **"Download for Windows"**
- Or direct link: https://desktop.docker.com/win/main/amd64/Docker%20Desktop%20Installer.exe

**Alternative: Using winget (Windows Package Manager)**

```powershell
winget install Docker.DockerDesktop
```

### Step 4: Install Docker Desktop

1. **Run the installer:**
   - Double-click `Docker Desktop Installer.exe`
   - Follow the installation wizard

2. **Installation options:**
   - ☑️ **Use WSL 2 instead of Hyper-V** (Recommended)
   - ☑️ **Add shortcut to desktop** (Optional)

3. **Click "OK"** when installation completes

4. **Start Docker Desktop:**
   - Launch Docker Desktop from Start menu
   - Accept the service agreement
   - Sign in or skip (can sign in later)

### Step 5: Verify Installation

Open PowerShell or Command Prompt and run:

```bash
docker --version
# Should show: Docker version XX.XX.X, build xxxxx

docker compose version
# Should show: Docker Compose version vX.X.X

docker run hello-world
# Should download and run a test container
```

### Step 6: Configure Docker Desktop (Optional)

1. **Open Docker Desktop**
2. Click **Settings** (gear icon)
3. **Recommended settings:**
   - **General:**
     - ☑️ Start Docker Desktop when you log in
     - ☑️ Use WSL 2 based engine
   - **Resources:**
     - Adjust CPU/Memory as needed (default is usually fine)
   - **Docker Engine:**
     - Keep default settings unless you need specific configurations

## 🚀 Quick Start After Installation

### 1. Test Docker

```bash
docker run hello-world
```

### 2. Login to Docker Hub

```bash
docker login
# Enter your Docker Hub username and password
```

### 3. Build Your App

```bash
# Navigate to your project
cd C:\Users\shubh\Desktop\applaa\applaa_flutter_template

# Build the image
docker build -t shubham9654/applaa-template:latest -f Dockerfile --target web-server .
```

### 4. Push to Docker Hub

```bash
docker push shubham9654/applaa-template:latest
```

## 🔧 Troubleshooting

### WSL 2 Installation Issues

**Problem:** WSL 2 not installing properly

**Solution:**
```powershell
# Update WSL kernel
wsl --update

# Set default version
wsl --set-default-version 2

# Verify
wsl --status
```

### Docker Desktop Won't Start

**Problem:** Docker Desktop fails to start

**Solutions:**
1. **Restart Docker Desktop:**
   - Right-click Docker Desktop icon → Quit
   - Restart as Administrator

2. **Check WSL 2:**
   ```powershell
   wsl --status
   # Should show: Default Version: 2
   ```

3. **Update WSL:**
   ```powershell
   wsl --update
   ```

4. **Reset Docker Desktop:**
   - Settings → Troubleshoot → Reset to factory defaults

### Virtualization Not Enabled

**Problem:** Error about virtualization not enabled

**Solution:**
1. Restart computer and enter BIOS/UEFI
2. Enable:
   - **Intel VT-x** (Intel processors)
   - **AMD-V** (AMD processors)
   - **Virtualization Technology**
3. Save and restart

### Port Already in Use

**Problem:** Port 8080 or 80 already in use

**Solution:**
```bash
# Check what's using the port
netstat -ano | findstr :8080

# Use different port
docker run -p 8081:80 shubham9654/applaa-template:latest
```

## ✅ Verification Checklist

After installation, verify:

- [ ] `docker --version` works
- [ ] `docker compose version` works
- [ ] `docker run hello-world` succeeds
- [ ] Docker Desktop icon shows "Running"
- [ ] Can access Docker Desktop GUI

## 📚 Additional Resources

- **Docker Desktop Documentation:** https://docs.docker.com/desktop/windows/
- **WSL 2 Installation:** https://docs.microsoft.com/en-us/windows/wsl/install
- **Docker Hub:** https://hub.docker.com/
- **Troubleshooting Guide:** https://docs.docker.com/desktop/troubleshoot/overview/

## 🎯 Next Steps

Once Docker is installed:

1. **Login to Docker Hub:**
   ```bash
   docker login
   ```

2. **Build your image:**
   ```bash
   docker build -t shubham9654/applaa-template:latest .
   ```

3. **Push to Docker Hub:**
   ```bash
   docker push shubham9654/applaa-template:latest
   ```

4. **Or use the provided script:**
   ```bash
   build-and-push-docker.bat latest
   ```

---

**Need Help?** Check the troubleshooting section or Docker Desktop logs:
- Right-click Docker Desktop icon → Troubleshoot → View logs

