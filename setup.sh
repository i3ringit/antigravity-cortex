#!/bin/bash
set -e

# Get the directory where this script resides (the Cortex submodule root)
SCRIPT_DIR="$(dirname "$(realpath "$0")")"
PROJECT_ROOT="$(pwd)"

echo "🔮 Initializing Antigravity Cortex..."
echo "   Source: $SCRIPT_DIR"
echo "   Target: $PROJECT_ROOT/.agent"

# Safety Guard: Prevent running inside the source directory
if [ "$SCRIPT_DIR" == "$PROJECT_ROOT" ]; then
    echo ""
    echo "❌ SAFETY ERROR: You are running this script from the source directory."
    echo "   This script is intended to install Cortex into a *wrapper* project."
    echo "   Running it here would overwrite source files with symlinks."
    echo "   Please run this from the root of your wrapper project (e.g., cortex-lab)."
    exit 1
fi

# Function to safely remove broken links pointing to our upstream
function prune_dead_links() {
    local search_dir="$1"
    local upstream_root="$2"
    
    echo "🧹 Cleaning up orphaned links in $search_dir..."
    
    # Enable nullglob to handle empty directories
    shopt -s nullglob
    for dest_file in "$search_dir"/*; do
        # 1. Skip if file exists (valid link or regular file)
        if [ -e "$dest_file" ]; then
            continue
        fi
        
        # 2. If we are here, file does NOT exist (broken link or gone).
        # Check if it is a broken symlink.
        if [ -L "$dest_file" ]; then
            # 3. Ownership Verification
            # Read the raw link target
            target=$(readlink "$dest_file")
            
            # Absolute path of the broken link's intended target
            link_dir=$(dirname "$dest_file")
            
            # Use realpath -m (virtual path) to resolve the full path
            abs_target_candidate=$(realpath -m "$link_dir/$target")
            
            # Check if this candidate is within UPSTREAM_ROOT (SCRIPT_DIR)
            if [[ "$abs_target_candidate" == "$upstream_root"* ]]; then
                rm "$dest_file"
                echo "   🗑️ Removed orphan: $(basename "$dest_file") (was pointing to upstream)"
            else
                echo "   ⚠️  Skipping broken link (not ours): $(basename "$dest_file") -> $target"
            fi
        fi
    done
    shopt -u nullglob
}


# Parse arguments
CHECK_DEPS=false

while [[ "$#" -gt 0 ]]; do
    case $1 in
        --check-deps|-f|--force) 
            CHECK_DEPS=true 
            ;;
        --help|-h)
            echo "Usage: ./setup.sh [OPTIONS]"
            echo ""
            echo "Options:"
            echo "  --check-deps, -f, --force    Force dependency check/install (runs 'agent-browser install --with-deps')"
            echo "  --help, -h                   Show this help message"
            echo ""
            exit 0
            ;;
        *) 
            echo "Unknown parameter: $1" 
            echo "Use --help for usage information."
            exit 1 
            ;;
    esac
    shift
done

echo "🔍 Checking dependencies..."

# Check for agent-browser
if command -v agent-browser &> /dev/null; then
    echo "   ✅ agent-browser is installed."
    
    # Check if we need to install dependencies
    if [ "$CHECK_DEPS" = true ]; then
        echo "   🔄 Forced dependency check/install requested..."
        if [[ "$OSTYPE" == "linux-gnu"* ]]; then
             echo "   🐧 Linux detected. Installing with system dependencies..."
             if ! agent-browser install --with-deps; then
                 echo "   ❌ Failed to verify/install browser dependencies."
                 exit 1
             fi
        else
             echo "   ⚙️  Verifying agent-browser binaries..."
             if ! agent-browser install; then
                 echo "   ❌ Failed to install browser binaries."
                 exit 1
             fi
        fi
    else
        # Fast path
        echo "   ⏩ Skipping dependency check (already installed). Use --check-deps to force."
    fi
else
    echo "   ❌ agent-browser is NOT installed."
    echo "      It is required for browsing capabilities."
    echo ""
    read -p "   Would you like to install it globally now? (npm install -g agent-browser) [y/N] " -n 1 -r
    echo ""
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        echo "   📦 Installing agent-browser..."
        
        # Capture failure to suggest sudo, and EXIT on failure
        if ! npm install -g agent-browser; then
            echo ""
            echo "   ❌ Installation failed (likely permissions)."
            echo "   👉 Please run: sudo npm install -g agent-browser"
            echo "      Then run this script again."
            exit 1
        fi
        
        echo "   ⚙️  Installing browser binaries..."
        if [[ "$OSTYPE" == "linux-gnu"* ]]; then
             echo "   🐧 Linux detected. Installing with system dependencies..."
             if ! agent-browser install --with-deps; then
                 echo "   ❌ Failed to install browser binaries/dependencies."
                 exit 1
             fi
        else
             if ! agent-browser install; then
                 echo "   ❌ Failed to install browser binaries."
                 exit 1
             fi
        fi
    else
        echo "   ⚠️  Skipping agent-browser installation."
        echo "       Please install it manually to use browser skills:"
        if [[ "$OSTYPE" == "linux-gnu"* ]]; then
            echo "       npm install -g agent-browser && agent-browser install --with-deps"
        else
            echo "       npm install -g agent-browser && agent-browser install"
        fi
        # We allow continuing without it, but warn.
    fi
fi

# Define directories to sync
DIRS=("rules" "skills" "workflows")

for dir in "${DIRS[@]}"; do
    SOURCE_PATH="$SCRIPT_DIR/.agent/$dir"
    DEST_PATH="$PROJECT_ROOT/.agent/$dir"

    echo "📂 Processing $dir..."

    # Create destination directory if it doesn't exist
    if [ ! -d "$DEST_PATH" ]; then
        mkdir -p "$DEST_PATH"
        echo "   Created $DEST_PATH"
    fi

    # Check if source directory exists
    if [ -d "$SOURCE_PATH" ]; then
        # Find all files in the source directory (excluding .gitkeep etc if needed, but * is fine for now)
        # We use find to be safe, but a loop over * works if glob matches.
        
        # Enable nullglob to handle empty directories gracefully
        shopt -s nullglob
        for file in "$SOURCE_PATH"/*; do
            filename=$(basename "$file")
            target="$DEST_PATH/$filename"
            
            # Calculate relative path for the symlink
            # We want the link to point to the source file relative to the link's location
            rel_path=$(realpath --relative-to="$DEST_PATH" "$file")
            
            # Create or update symbolic link
            ln -sfn "$rel_path" "$target"
            echo "   Linked $filename"
        done
        shopt -u nullglob

        # Prune dead links that point to our upstream
        prune_dead_links "$DEST_PATH" "$SCRIPT_DIR"
    else
        echo "   Warning: Source directory $SOURCE_PATH does not exist."
    fi
done

echo "✅ Antigravity Cortex initialized successfully."
echo "   Context: .agent/rules"
echo "   Skills:  .agent/skills"
echo "   Workflows: .agent/workflows"
