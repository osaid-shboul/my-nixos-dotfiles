{ config, lib, pkgs, ... }:

{
  options.features.development = {
    enable = lib.mkEnableOption "Programming and Development Environment";
  };

  config = lib.mkIf config.features.development.enable {
    environment.systemPackages = with pkgs; [
      # أدوات البرمجة بلغة C
      gcc           # المترجم الأساسي
      gnumake       # أداة make الضرورية لترجمة المشاريع عبر ملفات Makefile
      gdb           # مصحح الأخطاء لاكتشاف مشاكل العمليات والإشارات
      valgrind      # أداة فحص تسريب الذاكرة (Memory leaks)
      
      # أدوات تطوير الويب
      nodejs_20     # بيئة تشغيل خوادم Node.js
      
      # أدوات عامة للتحكم بالكود
      git           # للتحكم بالنسخ
      gh            # أداة GitHub الرسمية للتعامل مع المستودعات
    
     norminette
     vscode
     pkg-config
     opencv
     tesseract
    ];
  };
}
