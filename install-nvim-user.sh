#!/bin/bash
set -e

# Install Neovim for current user only (no sudo required)
# This script installs Neovim to ~/.local and updates PATH

echo "=== Neovim User-Local Installation Script ==="
echo "This will install Neovim to ~/.local for user: $(whoami)"
echo ""

# Configuration
INSTALL_DIR="$HOME/.local"
BIN_DIR="$INSTALL_DIR/bin"
TMP_DIR="/tmp/nvim-install-$$"

# Detect architecture
ARCH=$(uname -m)
case $ARCH in
    x86_64)
        NVIM_ARCH="linux64"
        ;;
    aarch64|arm64)
        echo "Error: ARM architecture detected. Please use AppImage method instead:"
        echo "  wget https://github.com/neovim/neovim/releases/latest/download/nvim.appimage"
        echo "  chmod +x nvim.appimage"
        echo "  mv nvim.appimage ~/.local/bin/nvim"
        exit 1
        ;;
    *)
        echo "Error: Unsupported architecture: $ARCH"
        exit 1
        ;;
esac

# Create directories
mkdir -p "$BIN_DIR"
mkdir -p "$TMP_DIR"

# Cleanup function
cleanup() {
    rm -rf "$TMP_DIR"
}
trap cleanup EXIT

echo "Downloading Neovim (stable) for $NVIM_ARCH..."

# Download Neovim
cd "$TMP_DIR"
DOWNLOAD_URL="https://github.com/neovim/neovim/releases/latest/download/nvim-$NVIM_ARCH.tar.gz"
FILENAME="nvim-$NVIM_ARCH.tar.gz"

if command -v curl &> /dev/null; then
    echo "Using curl to download..."
    if ! curl -fL --progress-bar -o "$FILENAME" "$DOWNLOAD_URL"; then
        echo "Error: Download failed with curl"
        exit 1
    fi
elif command -v wget &> /dev/null; then
    echo "Using wget to download..."
    if ! wget --show-progress -O "$FILENAME" "$DOWNLOAD_URL"; then
        echo "Error: Download failed with wget"
        exit 1
    fi
else
    echo "Error: Neither curl nor wget found. Please install one of them."
    exit 1
fi

# Verify download
if [ ! -f "$FILENAME" ]; then
    echo "Error: Downloaded file not found"
    exit 1
fi

# Check file size (should be > 1MB for a valid download)
FILE_SIZE=$(stat -c%s "$FILENAME" 2>/dev/null || stat -f%z "$FILENAME" 2>/dev/null || echo "0")
if [ "$FILE_SIZE" -lt 1000000 ]; then
    echo "Error: Downloaded file is too small ($FILE_SIZE bytes). Download may have failed."
    echo "File contents:"
    head -20 "$FILENAME"
    exit 1
fi

# Verify it's a gzip file
if ! file "$FILENAME" | grep -q "gzip compressed"; then
    echo "Error: Downloaded file is not a valid gzip archive"
    echo "File type: $(file "$FILENAME")"
    echo "First few lines:"
    head -20 "$FILENAME"
    exit 1
fi

# Extract
echo "Extracting Neovim..."
if ! tar xzf "$FILENAME"; then
    echo "Error: Failed to extract archive"
    exit 1
fi

# Find extracted directory
EXTRACTED_DIR=$(find . -maxdepth 1 -type d -name "nvim-*" | head -1)
if [ -z "$EXTRACTED_DIR" ]; then
    echo "Error: Could not find extracted directory"
    ls -la
    exit 1
fi

# Install to ~/.local
echo "Installing to $INSTALL_DIR..."
cp -r "$EXTRACTED_DIR"/* "$INSTALL_DIR/"

# Verify installation
if [ -x "$BIN_DIR/nvim" ]; then
    echo ""
    echo "✓ Neovim installed successfully!"
    echo "  Location: $BIN_DIR/nvim"
    echo "  Version: $("$BIN_DIR/nvim" --version | head -n1)"
else
    echo "Error: Installation failed"
    exit 1
fi

# Update PATH in shell config
echo ""
echo "Updating shell configuration..."

# Function to add PATH to config file
add_to_path() {
    local config_file="$1"
    local path_line='export PATH="$HOME/.local/bin:$PATH"'

    if [ -f "$config_file" ]; then
        if ! grep -q "$HOME/.local/bin" "$config_file"; then
            echo "" >> "$config_file"
            echo "# Added by Neovim install script" >> "$config_file"
            echo "$path_line" >> "$config_file"
            echo "  ✓ Updated $config_file"
            return 0
        else
            echo "  - $config_file already contains ~/.local/bin in PATH"
            return 1
        fi
    fi
    return 1
}

# Detect shell and update appropriate config
UPDATED=0
if [ -n "$BASH_VERSION" ] || [ -f "$HOME/.bashrc" ]; then
    add_to_path "$HOME/.bashrc" && UPDATED=1
fi

if [ -f "$HOME/.zshrc" ]; then
    add_to_path "$HOME/.zshrc" && UPDATED=1
fi

if [ -f "$HOME/.profile" ]; then
    add_to_path "$HOME/.profile" && UPDATED=1
fi

echo ""
if [ $UPDATED -eq 1 ]; then
    echo "=== Installation Complete! ==="
    echo ""
    echo "To use Neovim, either:"
    echo "  1. Restart your terminal, or"
    echo "  2. Run: source ~/.bashrc (or ~/.zshrc if using zsh)"
    echo ""
    echo "Then run: nvim"
else
    if command -v nvim &> /dev/null; then
        echo "=== Installation Complete! ==="
        echo ""
        echo "Neovim is ready to use. Run: nvim"
    else
        echo "=== Installation Complete! ==="
        echo ""
        echo "Note: ~/.local/bin is already in your PATH or you need to add it manually."
        echo "Add this line to your ~/.bashrc or ~/.zshrc:"
        echo '  export PATH="$HOME/.local/bin:$PATH"'
        echo ""
        echo "Then restart your terminal or source the config file."
    fi
fi

echo ""
echo "Uninstall instructions:"
echo "  rm -rf ~/.local/bin/nvim ~/.local/share/nvim ~/.local/lib/nvim"
