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

إذا كنت تستخدم NixOS وتريد تطبيق هذه الإعدادات على جهازك، اتبع هذه الخطوات بحذر:

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
سنقوم بإنشاء روابط تجعل النظام يقرأ إعدادات الواجهة مباشرة من هذا المستودع:

```bash
ln -s ~/nixos-config/dotfiles/hypr ~/.config/hypr
ln -s ~/nixos-config/dotfiles/waybar ~/.config/waybar
ln -s ~/nixos-config/dotfiles/kitty ~/.config/kitty
ln -s ~/nixos-config/dotfiles/fastfetch ~/.config/fastfetch
```

### الخطوة 4: تفعيل النظام (NixOS Config)

تنبيهات هامة قبل البناء:
1. الهاردوير: ملف hardware-configuration.nix مخصص لجهازي. يجب نسخ تعريفات جهازك عبر الأمر التالي لتحل محل ملفي:
   ```bash
   cp /etc/nixos/hardware-configuration.nix ~/nixos-config/system/hardware-configuration.nix
   ```
2. اسم المستخدم: افتح ملف `system/configuration.nix` وابحث عن كلمة `osaid` واستبدلها باسم المستخدم الخاص بك في نظامك.

بعد التعديل، قم بربط ملف الإعدادات الرئيسي ليعتمد على المستودع:
```bash
sudo rm /etc/nixos/configuration.nix
sudo ln -s ~/nixos-config/system/configuration.nix /etc/nixos/configuration.nix
```

ثم قم ببناء النظام:
```bash
sudo nixos-rebuild switch
```
أعد تشغيل الجهاز لتدخل إلى الواجهة الجديدة.

---

## ربط المستودع بحسابك الشخصي على GitHub

هذا المستودع يحتوي على سكربت أتمتة لرفع التعديلات. لتجنب أخطاء الصلاحيات، يجب توجيه المستودع لحسابك:

1. قم بإنشاء مستودع جديد (فارغ) في حسابك على GitHub.
2. افتح التيرمنال في مجلد الإعدادات الخاص بك وغيّر رابط الرفع إلى مستودعك الجديد:
```bash
cd ~/nixos-config
git remote set-url origin [https://github.com/اسم_حسابك/اسم_المستودع.git](https://github.com/اسم_حسابك/اسم_المستودع.git)
```
3. إذا لم تكن قد سجلت دخولك في Git مسبقاً، نفذ هذه الأوامر لتأكيد هويتك:
```bash
git config --global user.name "اسمك"
git config --global user.email "بريدك@example.com"
```

---

## سكربت التحديث الذكي (Auto-Sync)
تم تجهيز هذا المستودع بسكربت update.sh. عندما تقوم بتعديل أي ملف، لن تحتاج لكتابة أوامر البناء والرفع يدوياً. السكربت سيكتشف تلقائياً إذا كان المستودع مرتبطاً بحسابك أو بحاجة إلى إعداد.

فقط افتح التيرمنال واكتب أمر التحديث:

```bash
nixsync
```
سيقوم النظام بـ:
1. التحقق من إعدادات مستودع GitHub.
2. بناء وتحديث NixOS.
3. حفظ التعديلات ورفعها تلقائياً مع كتابة الوقت والتاريخ.

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