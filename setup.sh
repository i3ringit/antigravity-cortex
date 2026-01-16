#!/bin/bash
set -e

# Get the directory where this script resides (the Cortex submodule root)
SCRIPT_DIR="$(dirname "$(realpath "$0")")"
PROJECT_ROOT="$(pwd)"

echo "🔮 Initializing Antigravity Cortex..."
echo "   Source: $SCRIPT_DIR"
echo "   Target: $PROJECT_ROOT/.agent"

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
    else
        echo "   Warning: Source directory $SOURCE_PATH does not exist."
    fi
done

echo "✅ Antigravity Cortex initialized successfully."
echo "   Context: .agent/rules"
echo "   Skills:  .agent/skills"
echo "   Workflows: .agent/workflows"
