{ config, pkgs, ... }:

{
  # 1. تفعيل ميزة RTKit (مهمة جداً لإعطاء الصوت أولوية عالية في المعالج لمنع التقطيع)
  security.rtkit.enable = true;

  # 2. تفعيل محرك PipeWire الأساسي
  services.pipewire = {
    enable = true;
    
    # دعم البرامج التي تستخدم نظام ALSA الأساسي
    alsa.enable = true;
    alsa.support32Bit = true;
    
    # دعم البرامج التي تستخدم نظام PulseAudio القديم
    pulse.enable = true;
    
    # تفعيل مدير الجلسات (المسؤول عن توصيل السماعات والمايكروفون تلقائياً)
    wireplumber.enable = true;
  };

  # 3. تثبيت برنامج رسومي للتحكم بمستوى الصوت
  environment.systemPackages = with pkgs; [
    pavucontrol # واجهة تحكم بالصوت (Volume Mixer)
  ];
}
