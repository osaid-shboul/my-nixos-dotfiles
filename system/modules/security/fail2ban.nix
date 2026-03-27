{ config, lib, ... }:

{
  options.features.security.fail2ban = {
    enable = lib.mkEnableOption "Fail2Ban Intrusion Prevention";
  };

  config = lib.mkIf config.features.security.fail2ban.enable {
    services.fail2ban.enable = true;
  };
}
