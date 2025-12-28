#!/bin/bash

# Kira Agent Installer
# usage: ./install.sh <path_to_your_target_project>
#
# Prerequisite:
# 1. Download kira-agent source code (e.g. Zip file)
# 2. Extract the Zip file
# 3. Run this script from the extracted directory

set -e

# --- Configuration ---
SOURCE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TARGET_DIR="$1"

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "${BLUE}🤖 Kira Agent Installer${NC}"

# 1. Validation
if [ -z "$TARGET_DIR" ]; then
    echo -e "${RED}❌ Error: Missing target directory.${NC}"
    echo -e "Usage: ./install.sh <path_to_your_project>"
    exit 1
fi

# Safety check: User passed a zip file?
if [[ "$TARGET_DIR" == *.zip ]]; then
    echo -e "${RED}❌ Error: It looks like you passed a ZIP file.${NC}"
    echo -e "Please unzip the file first, then run this script pointing to your target project directory."
    echo -e "Example: ./install.sh ../my-awesome-project"
    exit 1
fi

# Resolve absolute path for target
# Check if readlink -f or realpath exists (for cross-platform strictness), else use simple cd hack
if command -v realpath &> /dev/null; then
    TARGET_DIR=$(realpath "$TARGET_DIR")
else
    # Fallback if target exists
    if [ -d "$TARGET_DIR" ]; then
        TARGET_DIR=$(cd "$TARGET_DIR" && pwd)
    fi
fi

echo -e "Source Directory: ${BLUE}$SOURCE_DIR${NC}"
echo -e "Target Directory: ${GREEN}$TARGET_DIR${NC}"
echo ""

if [ ! -d "$TARGET_DIR" ]; then
    echo -e "${RED}❌ Error: Target directory does not exist: $TARGET_DIR${NC}"
    exit 1
fi

# 2. Pre-flight Checks on Target
if [ ! -f "$TARGET_DIR/package.json" ] && [ ! -f "$TARGET_DIR/composer.json" ] && [ ! -f "$TARGET_DIR/go.mod" ] && [ ! -f "$TARGET_DIR/pom.xml" ] && [ ! -f "$TARGET_DIR/requirements.txt" ]; then
    echo -e "${YELLOW}⚠️  Warning: No project definition file (package.json, composer.json, etc.) found in target directory.${NC}"
    echo -e "Are you sure '$TARGET_DIR' is a project root?"
    read -p "Continue? (y/n) " -n 1 -r
    echo ""
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        exit 1
    fi
fi

# 3. Check Source Integrity
if [ ! -d "$SOURCE_DIR/.claude" ]; then
    echo -e "${RED}❌ Error: Source .claude directory not found in $SOURCE_DIR.${NC}"
    echo -e "Please ensure you are running this script from the UNZIPPED Kira Agent repository root."
    exit 1
fi

# 4. Install .claude configuration
echo -e "${BLUE}📂 Configure .claude agents and skills...${NC}"
if [ -d "$TARGET_DIR/.claude" ]; then
    echo -e "${YELLOW}⚠️  .claude directory already exists in target.${NC}"
    BACKUP_DIR="$TARGET_DIR/.claude.bak.$(date +%s)"
    echo -e "Backing up existing .claude to $(basename "$BACKUP_DIR")..."
    mv "$TARGET_DIR/.claude" "$BACKUP_DIR"
fi

cp -r "$SOURCE_DIR/.claude" "$TARGET_DIR/"
echo -e "${GREEN}✓ .claude directory installed${NC}"

# 5. Install .mcp.json
if [ -f "$TARGET_DIR/.mcp.json" ]; then
    echo -e "${YELLOW}⚠️  .mcp.json already exists in target.${NC}"
    echo -e "Skipping overwrite. Please manually merge keys from source .mcp.json if needed."
else
    if [ -f "$SOURCE_DIR/.mcp.json" ]; then
        cp "$SOURCE_DIR/.mcp.json" "$TARGET_DIR/"
        echo -e "${GREEN}✓ .mcp.json installed${NC}"
    else
        echo -e "${YELLOW}⚠️  Warning: .mcp.json not found in source.${NC}"
    fi
fi

# 6. Initialize .kira workspace in Target
echo -e "${BLUE}🛠️  Initializing .kira workspace...${NC}"
mkdir -p "$TARGET_DIR/.kira/inputs"
mkdir -p "$TARGET_DIR/.kira/plans"
mkdir -p "$TARGET_DIR/.kira/reviews"
mkdir -p "$TARGET_DIR/.kira/logs"

# Copy template files if they exist in source
if [ -d "$SOURCE_DIR/.kira" ]; then
    # Copy templates from each subdirectory
    for subdir in inputs plans reviews logs; do
        if [ -d "$SOURCE_DIR/.kira/$subdir" ]; then
            # Copy all .md files (templates) from source to target
            for template in "$SOURCE_DIR/.kira/$subdir"/*.md; do
                if [ -f "$template" ]; then
                    cp "$template" "$TARGET_DIR/.kira/$subdir/"
                    echo -e "${GREEN}✓ Copied template: $(basename "$template") to .kira/$subdir/${NC}"
                fi
            done
        fi
    done
fi

# Add .gitignore for .kira/logs if not exists
if [ ! -f "$TARGET_DIR/.kira/.gitignore" ]; then
    echo "logs/" > "$TARGET_DIR/.kira/.gitignore"
    echo "plans/" >> "$TARGET_DIR/.kira/.gitignore"
    echo "reviews/" >> "$TARGET_DIR/.kira/.gitignore"
    echo "!inputs/" >> "$TARGET_DIR/.kira/.gitignore"
    echo -e "${GREEN}✓ .kira structure created${NC}"
fi

# 7. Update .gitignore
echo -e "${BLUE}🙈 Updating .gitignore...${NC}"
GITIGNORE_FILE="$TARGET_DIR/.gitignore"

if [ ! -f "$GITIGNORE_FILE" ]; then
    touch "$GITIGNORE_FILE"
    echo -e "${GREEN}Created .gitignore${NC}"
fi

# Helper to safely append to gitignore
IGNORES=(".claude/" ".mcp.json")
HEADER_ADDED=false

# Check if we need to add a header first (only if we are going to add items)
# But simple approach: just check each item
for ignore in "${IGNORES[@]}"; do
    if ! grep -qsF "$ignore" "$GITIGNORE_FILE"; then
        # Check if file has content and doesn't end with newline
        if [ -s "$GITIGNORE_FILE" ] && [ "$(tail -c1 "$GITIGNORE_FILE" | wc -l)" -eq 0 ]; then
            echo "" >> "$GITIGNORE_FILE"
        fi
        
        # Add header only once
        if [ "$HEADER_ADDED" = false ]; then
             if ! grep -qsF "# Kira Agent" "$GITIGNORE_FILE"; then
                 echo -e "\n# Kira Agent" >> "$GITIGNORE_FILE"
             fi
             HEADER_ADDED=true
        fi
        
        echo "$ignore" >> "$GITIGNORE_FILE"
        echo -e "Added ${GREEN}$ignore${NC} to .gitignore"
    else
        echo -e "${YELLOW}$ignore${NC} already in .gitignore"
    fi
done

# 8. Final Checks
echo ""
echo -e "${GREEN}✨ Kira Agent has been successfully installed into $TARGET_DIR!${NC}"
echo ""
echo -e "Next steps:"
echo -e "1. Go to your project: ${BLUE}cd $TARGET_DIR${NC}"
echo -e "2. Update your API keys in ${BLUE}.mcp.json${NC} (if required)"
echo -e "3. Run ${BLUE}claude${NC} to start the agent"
