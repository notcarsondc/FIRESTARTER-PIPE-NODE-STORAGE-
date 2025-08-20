#!/bin/bash
# ==============================
# Pipe Firestarter One Click Command
# Made by WeekShit 
# ==============================
set -e

INSTALL_FLAG="$HOME/.pipe_installed"
PIPE_DIR="$HOME/pipe"
CREDENTIALS_FILE="$HOME/.pipe-cli.json"

# Function: Check if command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Function: Install Pipe & dependencies
install_pipe() {
    echo "🚀 Updating & Installing dependencies..."
    
    # Update system
    sudo apt update && sudo apt upgrade -y
    
    # Install dependencies (cleaned up list)
    sudo apt install -y \
        curl git wget build-essential \
        pkg-config libssl-dev clang \
        jq make gcc nano tmux htop \
        tar unzip lz4 automake autoconf \
        bsdmainutils ncdu
    
    # Install Rust
    if ! command_exists rustc; then
        echo "📦 Installing Rust..."
        curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
        source "$HOME/.cargo/env"
        
        # Verify Rust installation
        if ! command_exists rustc; then
            echo "❌ Rust installation failed"
            exit 1
        fi
    else
        echo "✅ Rust already installed"
        source "$HOME/.cargo/env" 2>/dev/null || true
    fi
    
    echo "📋 Rust version: $(rustc --version)"
    echo "📋 Cargo version: $(cargo --version)"
    
    # Clone Pipe repo with error handling
    if [ ! -d "$PIPE_DIR" ]; then
        echo "📂 Cloning Pipe Repo..."
        if ! git clone https://github.com/PipeNetwork/pipe.git "$PIPE_DIR"; then
            echo "❌ Failed to clone repository. Please check if the repository exists."
            exit 1
        fi
    else
        echo "📂 Repo already exists, updating..."
        cd "$PIPE_DIR"
        git pull origin main 2>/dev/null || git pull origin master 2>/dev/null || echo "⚠️ Could not update repo"
    fi
    
    cd "$PIPE_DIR"
    
    # Verify this is a Rust project
    if [ ! -f "Cargo.toml" ]; then
        echo "❌ Invalid repository - no Cargo.toml found"
        exit 1
    fi
    
    # Install pipe-cli
    echo "⚙️ Installing Pipe CLI..."
    if ! cargo install --path .; then
        echo "❌ Failed to install Pipe CLI"
        exit 1
    fi
    
    # Verify Installation with better error handling
    echo "✅ Verifying pipe installation..."
    if command_exists pipe; then
        echo "✅ Pipe CLI installed successfully"
        # Test if help command works (but don't fail on non-zero exit)
        pipe -h >/dev/null 2>&1 && echo "✅ Pipe CLI responding correctly" || echo "⚠️ Pipe CLI installed but help command has issues"
    else
        echo "❌ Pipe installation failed - command not found"
        echo "💡 Try running: source ~/.cargo/env"
        exit 1
    fi
    
    # Setup new user
    echo ""
    read -p "👤 Enter your desired Pipe username: " USERNAME
    if [ -z "$USERNAME" ]; then
        echo "❌ Username cannot be empty"
        exit 1
    fi
    
    if ! pipe new-user "$USERNAME"; then
        echo "❌ Failed to create user"
        exit 1
    fi
    
    echo "🔑 Set a strong password for your Pipe account:"
    if ! pipe set-password; then
        echo "❌ Failed to set password"
        exit 1
    fi
    
  
    echo "📄 Opening credentials file for review..."
    if [ -f "$CREDENTIALS_FILE" ]; then
        echo "📋 Your credentials file is located at: $CREDENTIALS_FILE"
        echo "⚠️ Please copy & save your credentials safely before proceeding."
        echo "Press Enter to open the file in nano..."
        read
        nano "$CREDENTIALS_FILE"
    else
        echo "⚠️ Credentials file not found at $CREDENTIALS_FILE"
    fi
    
   
    echo ""
    REFERRAL_CODE="ATHARV23-AR4S"
    echo "🎁 Applying referral code: $REFERRAL_CODE"
    
    if pipe referral apply "$REFERRAL_CODE"; then
        echo "✅ Referral code applied successfully!"
    else
        echo "❌ Failed to apply referral code: $REFERRAL_CODE"
        echo "⚠️ Installation will continue, but referral benefits may not be applied"
        read -p "Press Enter to continue..." 
    fi
    
   
    touch "$INSTALL_FLAG"
    echo ""
    echo "🎉 Installation Completed! Run the script again for menu options."
    echo "📋 Remember to backup your credentials from: $CREDENTIALS_FILE"
}


validate_file() {
    local file_path="$1"
    if [ ! -f "$file_path" ]; then
        echo "❌ File not found: $file_path"
        return 1
    fi
    return 0
}


menu() {
    # Check if pipe command is available
    if ! command_exists pipe; then
        echo "❌ Pipe CLI not found. Try running: source ~/.cargo/env"
        echo "Or reinstall by removing $INSTALL_FLAG and running this script again."
        exit 1
    fi
    
    while true; do
        clear
        echo "======================================="
        echo " Pipe Firestarter Storage All Options"
        echo "   ⚡ Made by WeekShit  ⚡"
        echo "======================================="
        echo ""
        echo "1) Swap SOL → PIPE"
        echo "2) Upload File"
        echo "3) Check Token Usage"
        echo "4) Show Credentials"
        echo "5) Exit"
        echo "======================================="
        read -p "👉 Choose an option (1-5): " OPTION
        
        case $OPTION in
            1)
                echo ""
                read -p "💰 Enter amount of SOL (Devnet) to swap: " AMOUNT
                if [[ "$AMOUNT" =~ ^[0-9]*\.?[0-9]+$ ]] && (( $(echo "$AMOUNT > 0" | bc -l) )); then
                    if pipe swap-sol-for-pipe "$AMOUNT"; then
                        echo "✅ Swap completed successfully!"
                    else
                        echo "❌ Swap failed"
                    fi
                else
                    echo "❌ Invalid amount. Please enter a valid number."
                fi
                ;;
            2)
                echo ""
                read -p "📂 Enter full file path: " FILE_PATH
                if validate_file "$FILE_PATH"; then
                    read -p "📝 Enter file name (as you want it saved): " FILE_NAME
                    if [ -n "$FILE_NAME" ]; then
                        echo "📤 Uploading file..."
                        if pipe upload-file "$FILE_PATH" "$FILE_NAME"; then
                            echo "✅ File uploaded successfully!"
                            echo "🌍 Creating public link..."
                            if pipe create-public-link "$FILE_NAME"; then
                                echo "✅ Public link created!"
                            else
                                echo "⚠️ File uploaded but failed to create public link"
                            fi
                        else
                            echo "❌ File upload failed"
                        fi
                    else
                        echo "❌ File name cannot be empty"
                    fi
                fi
                ;;
            3)
                echo ""
                echo "📊 Checking token usage..."
                if ! pipe token-usage; then
                    echo "❌ Failed to check token usage"
                fi
                ;;
            4)
                echo ""
                if [ -f "$CREDENTIALS_FILE" ]; then
                    echo "📄 Credentials file location: $CREDENTIALS_FILE"
                    echo "📋 Contents:"
                    cat "$CREDENTIALS_FILE" 2>/dev/null || echo "❌ Could not read credentials file"
                else
                    echo "❌ Credentials file not found at $CREDENTIALS_FILE"
                fi
                ;;
            5)
                echo "👋 Exiting Pipe Firestarter Script..."
                exit 0
                ;;
            *)
                echo "❌ Invalid option! Please choose 1-5."
                ;;
        esac
        
        echo ""
        echo "🔄 Press Enter to return to menu..."
        read
    done
}




if ! command_exists bc; then
    echo "📦 Installing bc for number validation..."
    sudo apt install -y bc
fi

# Main execution
if [ ! -f "$INSTALL_FLAG" ]; then
    echo "🔥 Welcome to Pipe Firestarter Installer!"
    echo "This will install Pipe Fire Storage CLI and dependencies."
    echo ""
    read -p "Continue with installation? (y/N): " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo "Installation cancelled."
        exit 0
    fi
    install_pipe
else
    # Ensure cargo env is loaded
    source "$HOME/.cargo/env" 2>/dev/null || true
    menu
fi
