#!/usr/bin/env bash
# scripts/common/load-config.sh
# Shared configuration loader — sourced by other scripts, never run directly.
# Requires: jq

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
CONFIG_FILE="$REPO_ROOT/scripts/.config.json"

# ============================================================================
# Validate dependencies
# ============================================================================

if ! command -v jq &>/dev/null; then
    echo "ERROR: jq is required but not installed." >&2
    echo "  Install: sudo apt-get install jq (Ubuntu) or brew install jq (macOS)" >&2
    exit 1
fi

if [[ ! -f "$CONFIG_FILE" ]]; then
    echo "ERROR: Config file not found: $CONFIG_FILE" >&2
    exit 1
fi

if ! jq empty "$CONFIG_FILE" 2>/dev/null; then
    echo "ERROR: Invalid JSON in $CONFIG_FILE" >&2
    exit 1
fi

# ============================================================================
# Read configuration values
# ============================================================================

APP_NAME=$(jq -r '.app_name' "$CONFIG_FILE")
APP_DISPLAY_NAME=$(jq -r '.app_display_name' "$CONFIG_FILE")
VERSION=$(jq -r '.version' "$CONFIG_FILE")
REPO_URL=$(jq -r '.repo_url' "$CONFIG_FILE")

# Derived values
TAG="v${VERSION}"
RELEASE_DIR="$REPO_ROOT/release"

# ============================================================================
# Colors
# ============================================================================

RED="\033[0;31m"
GREEN="\033[0;32m"
YELLOW="\033[0;33m"
BLUE="\033[0;34m"
CYAN="\033[0;36m"
BOLD="\033[1m"
NC="\033[0m"

# ============================================================================
# Helper functions
# ============================================================================

# Extract changelog text for current version from docs/CHANGELOG.md
# Returns all content between ## [version] and the next ## heading
get_version_changelog() {
    local changelog_file="$REPO_ROOT/docs/CHANGELOG.md"

    if [[ ! -f "$changelog_file" ]]; then
        echo ""
        return 0
    fi

    awk -v version="$VERSION" '
        /^## \[/ {
            if ($0 ~ "\\[" version "\\]") {
                in_section = 1
                next
            } else if (in_section) {
                exit
            }
        }
        in_section { print }
    ' "$changelog_file"
}

# Get GitHub repo slug from remote URL (e.g., "Fantasim/logsimulator")
get_repo_slug() {
    git -C "$REPO_ROOT" remote get-url origin 2>/dev/null \
        | sed 's/.*github\.com[:/]\(.*\)\.git$/\1/' \
        | sed 's/.*github\.com[:/]\(.*\)$/\1/'
}

# Verify that version in pyproject.toml and constants.py matches .config.json
verify_version_sync() {
    local pyproject_version
    local constants_version
    local errors=0

    pyproject_version=$(grep -Po '(?<=^version = ")[^"]+' "$REPO_ROOT/pyproject.toml" 2>/dev/null || echo "NOT_FOUND")
    constants_version=$(grep -Po '(?<=VERSION: Final\[str\] = ")[^"]+' "$REPO_ROOT/agnolog/core/constants.py" 2>/dev/null || echo "NOT_FOUND")

    if [[ "$pyproject_version" != "$VERSION" ]]; then
        echo -e "${RED}  Version mismatch: pyproject.toml has '$pyproject_version', config has '$VERSION'${NC}"
        errors=1
    fi

    if [[ "$constants_version" != "$VERSION" ]]; then
        echo -e "${RED}  Version mismatch: constants.py has '$constants_version', config has '$VERSION'${NC}"
        errors=1
    fi

    if [[ "$errors" -gt 0 ]]; then
        echo -e "${YELLOW}  Run: make sync-version${NC}"
        return 1
    fi

    return 0
}

echo -e "${CYAN}Config loaded: $APP_DISPLAY_NAME v$VERSION${NC}"
