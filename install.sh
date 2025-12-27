#!/bin/bash

# Kira Agent Installer
# Installs Kira Agent configuration from the current directory into a target project directory.
# Usage: ./install.sh <path_to_target_project>

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

# Resolve absolute path for target
TARGET_DIR=$(realpath "$TARGET_DIR")
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
    echo -e "Please ensure you are running this script from the Kira Agent repository root."
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

# Add .gitignore for .kira/logs if not exists
if [ ! -f "$TARGET_DIR/.kira/.gitignore" ]; then
    echo "logs/" > "$TARGET_DIR/.kira/.gitignore"
    echo "plans/" >> "$TARGET_DIR/.kira/.gitignore"
    echo "reviews/" >> "$TARGET_DIR/.kira/.gitignore"
    echo "!inputs/" >> "$TARGET_DIR/.kira/.gitignore"
    echo -e "${GREEN}✓ .kira structure created${NC}"
fi

# 7. Final Checks
echo ""
echo -e "${GREEN}✨ Kira Agent has been successfully installed into $TARGET_DIR!${NC}"
echo ""
echo -e "Next steps:"
echo -e "1. Go to your project: ${BLUE}cd $TARGET_DIR${NC}"
echo -e "2. Update your API keys in ${BLUE}.mcp.json${NC} (if required)"
echo -e "3. Run ${BLUE}claude${NC} to start the agent"
