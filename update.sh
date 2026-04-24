#!/usr/bin/env bash

# الألوان لتجميل المخرجات في التيرمنال
GREEN='\033[1;32m'
BLUE='\033[1;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}=========================================${NC}"
echo -e "${BLUE}   🚀 Starting NixOS System Update...    ${NC}"
echo -e "${BLUE}=========================================${NC}"

# 1. بناء النظام الجديد
sudo nixos-rebuild switch

# التحقق من نجاح البناء قبل إكمال الرفع
if [ $? -eq 0 ]; then
    echo -e "${GREEN}✅ System built successfully!${NC}"
    
    # 2. رفع التعديلات إلى GitHub
    echo -e "${BLUE}📦 Syncing with GitHub...${NC}"
    cd ~/nixos-config
    git add .
    git commit -m "System update: $(date '+%Y-%m-%d %H:%M')"
    git push origin main
    
    echo -e "${GREEN}🎉 All done! Your dotfiles are safe in the cloud.${NC}"
else
    echo -e "\033[1;31m❌ Build failed! Git push aborted to prevent saving broken code.\033[0m"
    exit 1
fi
