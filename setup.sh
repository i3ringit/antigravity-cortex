#!/bin/bash
set -e

# Get the directory where this script resides (the Cortex submodule root)
SCRIPT_DIR="$(dirname "$(realpath "$0")")"
PROJECT_ROOT="$(pwd)"

echo "🔮 Initializing Antigravity Cortex..."
echo "   Source: $SCRIPT_DIR"
echo "   Target: $PROJECT_ROOT/.agent"

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
            ln -sf "$rel_path" "$target"
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
