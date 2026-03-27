# ❄️ NixOS & Hyprland Dotfiles

نظام متكامل مبني على NixOS مع واجهة Hyprland الزجاجية، منظم باستخدام الروابط الرمزية (Symlinks) لسهولة التعديل والرفع.

## 📂 الهيكل التنظيمي:
- **system/**: يحتوي على إعدادات `/etc/nixos` (الحزم، الهاردوير، المستخدمين).
- **dotfiles/**: يحتوي على إعدادات الواجهة (Hyprland, Waybar, Kitty, Fastfetch).

## 🚀 كيفية الاستخدام:
بعد تحميل المستودع، نقوم بإنشاء روابط رمزية لربط النظام بالمستودع:

```bash
# ربط إعدادات الواجهة
ln -s ~/nixos-config/dotfiles/hypr ~/.config/hypr

# ربط إعدادات النظام (يحتاج sudo)
sudo ln -s ~/nixos-config/system/configuration.nix /etc/nixos/configuration.nix