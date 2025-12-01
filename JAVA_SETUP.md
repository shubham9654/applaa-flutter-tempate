# Java Setup Guide

## Problem
You're seeing the error: "JDK 17 or higher is required. Please set a valid Java home path to 'java.jdt.ls.java.home' setting or JAVA_HOME environment variable."

## Solution

### Option 1: Install JDK 17 or Higher (Recommended)

1. **Download JDK 17+**:
   - Go to [Eclipse Adoptium](https://adoptium.net/) (recommended)
   - Or [Oracle JDK](https://www.oracle.com/java/technologies/downloads/)
   - Download JDK 17 or higher (LTS version recommended)

2. **Install JDK**:
   - Run the installer
   - Note the installation path (usually `C:\Program Files\Eclipse Adoptium\jdk-17.0.x-hotspot` or `C:\Program Files\Java\jdk-17`)

3. **Set JAVA_HOME Environment Variable**:
   - Press `Win + X` and select "System"
   - Click "Advanced system settings"
   - Click "Environment Variables"
   - Under "System variables", click "New"
   - Variable name: `JAVA_HOME`
   - Variable value: `C:\Program Files\Eclipse Adoptium\jdk-17.0.x-hotspot` (use your actual path)
   - Click "OK"

4. **Add Java to PATH**:
   - Find the "Path" variable in System variables
   - Click "Edit"
   - Click "New" and add: `%JAVA_HOME%\bin`
   - Click "OK" on all dialogs

5. **Restart VS Code/Cursor**:
   - Close and reopen VS Code/Cursor for changes to take effect

### Option 2: Use Android Studio's JDK (If you have Android Studio installed)

If you have Android Studio installed, it includes a JDK:

1. Find Android Studio's JDK path (usually `C:\Program Files\Android\Android Studio\jbr`)
2. Open `.vscode/settings.json` in this project
3. Uncomment and update the `java.jdt.ls.java.home` setting:
   ```json
   {
     "java.jdt.ls.java.home": "C:\\Program Files\\Android\\Android Studio\\jbr"
   }
   ```
4. Reload VS Code/Cursor

### Option 3: Configure in VS Code Settings

If you prefer not to set environment variables:

1. Open `.vscode/settings.json` in this project
2. Uncomment and update the `java.jdt.ls.java.home` line with your JDK path:
   ```json
   {
     "java.jdt.ls.java.home": "C:\\Program Files\\Java\\jdk-17"
   }
   ```
3. Reload VS Code/Cursor

### Verify Installation

After setting up, verify Java is accessible:

1. Open a new terminal in VS Code/Cursor
2. Run: `java -version`
3. You should see Java version 17 or higher

## Additional Notes

- For Flutter Android development, you need JDK 11 or higher (JDK 17+ recommended)
- The Java Language Server requires JDK 17+ for optimal performance
- If you're using Flutter, you typically need Java for Android builds

## Troubleshooting

- **Still getting the error?**: Restart VS Code/Cursor after making changes
- **Java version too old?**: Download and install JDK 17 or higher
- **Path not found?**: Verify the JDK installation path is correct
- **Windows path format**: Use double backslashes (`\\`) or forward slashes (`/`) in settings.json
