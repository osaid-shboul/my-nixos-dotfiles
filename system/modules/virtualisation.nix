{ config, lib, pkgs, ... }:

{
  options.features.virtualisation = {
    enable = lib.mkEnableOption "Docker Virtualisation Support";
  };

  config = lib.mkIf config.features.virtualisation.enable {
    
    # 1. تفعيل محرك Docker
    virtualisation.docker = {
      enable = true;
      
      # ميزة التنظيف التلقائي (لحذف الحاويات القديمة التي تستهلك مساحة التخزين)
      autoPrune = {
        enable = true;
        dates = "weekly";
      };
    };

    # 2. إضافة الأدوات المساعدة للنظام
    environment.systemPackages = with pkgs; [
      docker-compose  # أداة لتشغيل عدة حاويات معاً بملف واحد (مثل خادم + قاعدة بيانات)
    ];
  };
}
