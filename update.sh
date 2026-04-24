#!/usr/bin/env bash

GREEN='\033[1;32m'
BLUE='\033[1;34m'
YELLOW='\033[1;33m'
RED='\033[1;31m'
NC='\033[0m'

echo -e "${BLUE}=========================================${NC}"
echo -e "${BLUE}   Starting NixOS System Update...       ${NC}"
echo -e "${BLUE}=========================================${NC}"

cd ~/nixos-config || exit
CURRENT_REMOTE=$(git config --get remote.origin.url)

# التحقق من حساب المستودع
if [[ "$CURRENT_REMOTE" == *"osaid-shboul"* ]]; then
    echo -e "${YELLOW}[Warning] The repository is still linked to the original author (osaid-shboul).${NC}"
    read -p "Do you have your own GitHub repository URL to link now? (y/n): " answer
    if [[ "$answer" == "y" || "$answer" == "Y" ]]; then
        read -p "Enter your repository URL: " new_url
        git remote set-url origin "$new_url"
        echo -e "${GREEN}[Success] Repository linked successfully!${NC}"
    else
        echo -e "${YELLOW}[Notice] Skipping GitHub push to avoid permission errors.${NC}"
        SKIP_GIT=true
    fi
fi

# بناء النظام
sudo nixos-rebuild switch

if [ $? -eq 0 ]; then
    echo -e "${GREEN}[Success] System built successfully!${NC}"
    
    # رفع الملفات إذا لم يتم تخطي الخطوة
    if [ "$SKIP_GIT" != true ]; then
        echo -e "${BLUE}Syncing with GitHub...${NC}"
        git add .
        git commit -m "System update: $(date '+%Y-%m-%d %H:%M')"
        git push origin main
        echo -e "${GREEN}[Success] All done! Your dotfiles are safe in the cloud.${NC}"
    fi
else
    echo -e "${RED}[Error] Build failed! Git push aborted.${NC}"
    exit 1
fi