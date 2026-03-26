{ config, lib, ... }:

{
  options.features.security.ssh = {
    enable = lib.mkEnableOption "Hardened SSH Server";
  };

  config = lib.mkIf config.features.security.ssh.enable {
    
    services.openssh = {
      enable = true;
      
      settings = {
        # 1. منع استخدام كلمات المرور نهائياً (يسمح فقط بالمفاتيح التشفيرية)
        PasswordAuthentication = false;
        KbdInteractiveAuthentication = false;
        
        # 2. منع حساب المدير (root) من تسجيل الدخول عن بعد
        PermitRootLogin = "no";
        
        # 3. حصر الدخول على مستخدمين محددين فقط
        AllowUsers = [ "osaid" ];
      };

      # 4. تغيير المنفذ الافتراضي لتضليل روبوتات الاختراق (اختياري لكنه مفيد)
      ports = [ 2222 ]; 
    };
  };
}
