{ config, lib, ... }:

{
  options.features.security.permissions = {
    enable = lib.mkEnableOption "Granular Permissions and Polkit";
  };

  config = lib.mkIf config.features.security.permissions.enable {
    
    security.polkit.enable = true;

    security.sudo = {
      enable = true;
      
      wheelNeedsPassword = true; 
      
      execWheelOnly = true;
    };
  };
}
