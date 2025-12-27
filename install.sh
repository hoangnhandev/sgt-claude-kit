#!/bin/bash

# Kira Agent Installer
# Installs Kira Agent configuration into the current project directory.
# Usage: 
#   Online: ./install.sh
#   Offline: ./install.sh path/to/kira-agent.zip

set -e

# --- Configuration ---
REPO_URL="git@github.com:hnhan03112000/panda-b-sport.git"
BRANCH="main"
TEMP_DIR="/tmp/kira-agent-installer-$(date +%s)"
TARGET_DIR=$(pwd)
SOURCE_ZIP="$1"

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "${BLUE}🤖 Kira Agent Installer${NC}"
echo -e "Target Directory: ${GREEN}$TARGET_DIR${NC}"
echo ""

# 1. Pre-flight Checks
if [ ! -f "package.json" ] && [ ! -f "composer.json" ] && [ ! -f "go.mod" ] && [ ! -f "pom.xml" ] && [ ! -f "requirements.txt" ]; then
    echo -e "${YELLOW}⚠️  Warning: No project definition file (package.json, composer.json, etc.) found.${NC}"
    echo -e "Are you sure you are in the root of your project?"
    read -p "Continue? (y/n) " -n 1 -r
    echo ""
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        exit 1
    fi
fi

# 2. Prepare Source
mkdir -p "$TEMP_DIR"

if [ -n "$SOURCE_ZIP" ]; then
    # --- Install from ZIP ---
    echo -e "${BLUE}📦 Extracting source from zip: $SOURCE_ZIP...${NC}"
    
    if [ ! -f "$SOURCE_ZIP" ]; then
        echo -e "${RED}❌ Error: Zip file not found at $SOURCE_ZIP${NC}"
        exit 1
    fi

    # Check for unzip command
    if ! command -v unzip &> /dev/null; then
        echo -e "${RED}❌ Error: 'unzip' command is required but not installed.${NC}"
        exit 1
    fi

    unzip -q "$SOURCE_ZIP" -d "$TEMP_DIR"
    
    # Detect root directory inside zip (handle github-style zip structure usually folder-name-branch/)
    # We look for the .claude directory
    DETECTED_ROOT=$(find "$TEMP_DIR" -type d -name ".claude" | head -n 1 | xargs dirname)
    
    if [ -z "$DETECTED_ROOT" ]; then
        echo -e "${RED}❌ Error: Invalid structure. Could not find '.claude' directory in zip archive.${NC}"
        rm -rf "$TEMP_DIR"
        exit 1
    fi
    
    SOURCE_DIR="$DETECTED_ROOT"
    echo -e "${GREEN}✓ Source extracted from zip${NC}"

else
    # --- Install from GIT ---
    echo -e "${BLUE}📦 Downloading source from Git...${NC}"
    git clone --depth 1 --branch $BRANCH $REPO_URL "$TEMP_DIR" > /dev/null 2>&1 || {
        echo -e "${RED}❌ Failed to clone repository. Please check REPO_URL in the script.${NC}"
        echo -e "Current URL: $REPO_URL"
        exit 1
    }
    SOURCE_DIR="$TEMP_DIR"
    echo -e "${GREEN}✓ Source downloaded from git${NC}"
fi

# 3. Install .claude configuration
echo -e "${BLUE}📂 Configure .claude agents and skills...${NC}"
if [ -d ".claude" ]; then
    echo -e "${YELLOW}⚠️  .claude directory already exists.${NC}"
    echo -e "Backing up existing .claude to .claude.bak.$(date +%s)..."
    mv .claude ".claude.bak.$(date +%s)"
fi

cp -r "$SOURCE_DIR/.claude" "$TARGET_DIR/"
echo -e "${GREEN}✓ .claude directory installed${NC}"

# 4. Install .mcp.json
if [ -f ".mcp.json" ]; then
    echo -e "${YELLOW}⚠️  .mcp.json already exists.${NC}"
    echo -e "Skipping overwrite. Please manually merge keys from source .mcp.json if needed."
else
    if [ -f "$SOURCE_DIR/.mcp.json" ]; then
        cp "$SOURCE_DIR/.mcp.json" "$TARGET_DIR/"
        echo -e "${GREEN}✓ .mcp.json installed${NC}"
    else
        echo -e "${YELLOW}⚠️  Warning: .mcp.json not found in source.${NC}"
    fi
fi

# 5. Initialize .kira workspace
echo -e "${BLUE}🛠️  Initializing .kira workspace...${NC}"
mkdir -p .kira/inputs
mkdir -p .kira/plans
mkdir -p .kira/reviews
mkdir -p .kira/logs

# Add .gitignore for .kira/logs if not exists
if [ ! -f ".kira/.gitignore" ]; then
    echo "logs/" > .kira/.gitignore
    echo "plans/" >> .kira/.gitignore
    echo "reviews/" >> .kira/.gitignore
    echo "!inputs/" >> .kira/.gitignore
    echo -e "${GREEN}✓ .kira structure created${NC}"
fi

# 6. Formatting Hooks Setup
if ! command -v prettier &> /dev/null && [ ! -f "node_modules/.bin/prettier" ]; then
    echo -e "${YELLOW}ℹ️  Prettier is used by Kira hooks for formatting.${NC}"
fi

# Cleanup
rm -rf "$TEMP_DIR"

echo ""
echo -e "${GREEN}✨ Kira Agent has been successfully installed!${NC}"
echo ""
echo -e "Next steps:"
echo -e "1. Update your API keys in ${BLUE}.mcp.json${NC} (if required for MCP servers)"
echo -e "2. Run ${BLUE}claude${NC} to start the agent"
echo -e "3. Check ${BLUE}.claude/commands/${NC} for available workflows"
