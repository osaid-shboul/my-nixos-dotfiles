# NixOS & Hyprland Dotfiles

نظام متكامل، نظيف، ومستقر مبني على NixOS مع واجهة Hyprland بتصميم زجاجي (Glassmorphism). تم هندسة هذا المستودع ليكون مقسماً إلى وحدات (Modular) لتسهيل القراءة، التعديل، والمشاركة.

---

## الهيكل التنظيمي (كيف يعمل النظام؟)
النظام مقسم إلى جزأين رئيسيين لضمان الترتيب:

1. system/ (قلب النظام):
   يحتوي على إعدادات NixOS الأساسية مقسمة إلى وحدات في مجلد modules (مثل إعدادات الصوت، الأمان، الألعاب، التطوير). الملف الرئيسي هنا هو configuration.nix.
2. dotfiles/ (شكل الواجهة):
   يحتوي على إعدادات واجهة المستخدم والبرامج الرسومية:
   * hypr/: إعدادات النوافذ، الاختصارات، والتصميم الزجاجي.
   * waybar/: شريط المهام العلوي (الصوت، البلوتوث، الشبكة، البطارية).
   * kitty/: إعدادات التيرمنال السريعة والشفافة.
   * fastfetch/: معلومات النظام التي تظهر عند فتح التيرمنال.

---

## طريقة التثبيت (من الصفر)

إذا كنت تستخدم NixOS وتريد تطبيق هذه الإعدادات على جهازك، اتبع هذه الخطوات البسيطة بحذر:

### الخطوة 1: تحميل الملفات
افتح التيرمنال وقم باستنساخ المستودع إلى مجلدك الرئيسي:

```bash
cd ~
git clone [https://github.com/osaid-shboul/my-nixos-dotfiles.git](https://github.com/osaid-shboul/my-nixos-dotfiles.git) nixos-config
```

### الخطوة 2: حماية ملفاتك القديمة (النسخ الاحتياطي)
قم بحفظ نسخة من إعداداتك الحالية تحسباً لأي طارئ:

```bash
mkdir -p ~/.config-backup
mv ~/.config/hypr ~/.config/waybar ~/.config/kitty ~/.config/fastfetch ~/.config-backup/ 2>/dev/null
```

### الخطوة 3: ربط إعدادات الواجهة (Symlinks)
سنقوم بإنشاء "روابط" تجعل النظام يقرأ إعدادات الواجهة مباشرة من هذا المستودع:

```bash
ln -s ~/nixos-config/dotfiles/hypr ~/.config/hypr
ln -s ~/nixos-config/dotfiles/waybar ~/.config/waybar
ln -s ~/nixos-config/dotfiles/kitty ~/.config/kitty
ln -s ~/nixos-config/dotfiles/fastfetch ~/.config/fastfetch
```

### الخطوة 4: تفعيل النظام (NixOS Config)
تحذير هام: لا تقم بنسخ ملف hardware-configuration.nix الموجود هنا لأنه خاص بجهازي. احتفظ بالملف الخاص بجهازك!

قم بربط ملف الإعدادات الرئيسي فقط:

```bash
sudo rm /etc/nixos/configuration.nix
sudo ln -s ~/nixos-config/system/configuration.nix /etc/nixos/configuration.nix
```

ثم قم ببناء النظام:

```bash
sudo nixos-rebuild switch
```
أعد تشغيل الجهاز، وستستقبلك واجهة Hyprland الجديدة!

---

## سكربت التحديث الذكي (Auto-Sync)
تم تجهيز هذا المستودع بسكربت update.sh. عندما تقوم بتعديل أي ملف (سواء تغيير لون في الواجهة أو إضافة برنامج في NixOS)، لن تحتاج لكتابة أوامر البناء والرفع يدوياً.

فقط افتح التيرمنال واكتب:

```bash
sync
```
سيقوم النظام بـ:
1. بناء وتحديث NixOS.
2. حفظ التعديلات في Git.
3. رفعها تلقائياً إلى GitHub مع كتابة الوقت والتاريخ.

---

## أهم الاختصارات (Keybindings)

| الوظيفة | الاختصار |
| :--- | :--- |
| فتح التيرمنال (Kitty) | Super + Q |
| إغلاق النافذة الحالية | Super + X |
| فتح قائمة البرامج (Wofi) | Super + R |
| فتح متصفح الملفات | Super + E |
| فتح المتصفح (Firefox) | Super + 1 |
| إدارة الحافظة (CopyQ) | Super + V |
| تصوير الشاشة | Print Screen |
| مدير المهام (Btop) | Super + Escape |
| الآلة الحاسبة | Super + C |
| الخروج من النظام | Super + M |

*(لتغيير اللغة بين العربية والإنجليزية اضغط Super + Space)*