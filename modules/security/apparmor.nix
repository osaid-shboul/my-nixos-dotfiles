{ config, lib, pkgs, ... }:

{
  options.features.security.apparmor = {
    enable = lib.mkEnableOption "AppArmor Mandatory Access Control";
  };

  config = lib.mkIf config.features.security.apparmor.enable {
    
    # تفعيل نظام العزل
    security.apparmor = {
      enable = true;
      enableCache = true; # لتسريع إقلاع النظام
    };

    # تفعيل نظام تسجيل ومراقبة الحوادث الأمنية
    security.auditd.enable = true;
    security.audit.enable = true;

    # أدوات مساعدة للتحكم بالـ AppArmor من التيرمنال
    environment.systemPackages = with pkgs; [
      apparmor-utils
      apparmor-profiles
    ];
  };
}
