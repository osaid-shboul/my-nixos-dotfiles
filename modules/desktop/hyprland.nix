{ config, lib, pkgs, ... }:

{
  # ============================================================================
  # 1. التعريف (Options)
  # ============================================================================
  options.features.desktop.hyprland = {
    enable = lib.mkEnableOption "Hyprland Wayland Compositor";
  };

  # ============================================================================
  # 2. الإعدادات (Configuration)
  # ============================================================================
  config = lib.mkIf config.features.desktop.hyprland.enable {
    
    # إعدادات شاشة الدخول
    services.displayManager.sddm = {
      enable = true;
      wayland.enable = true;
    };

    # تفعيل Hyprland
    programs.hyprland = {
      enable = true;
      xwayland.enable = true;
    };

    # تفعيل حفظ كلمات السر (ضروري للواي فاي)
    services.gnome.gnome-keyring.enable = true;
    security.pam.services.login.enableGnomeKeyring = true;

    # تشغيل الخدمات تلقائياً عند الدخول للجلسة الرسومية
    systemd.user.services = {
      swww-daemon = {
        description = "swww-daemon for wallpapers";
        wantedBy = [ "graphical-session.target" ];
        serviceConfig.ExecStart = "${pkgs.swww}/bin/swww-daemon";
      };

      waybar = {
        description = "Waybar status bar";
        wantedBy = [ "graphical-session.target" ];
        serviceConfig.ExecStart = "${pkgs.waybar}/bin/waybar";
      };

      # تشغيل أيقونة الشبكة لتعمل في الخلفية وتحفظ الكلمات
      nm-applet = {
        description = "Network Manager Applet";
        wantedBy = [ "graphical-session.target" ];
        serviceConfig.ExecStart = "${pkgs.networkmanagerapplet}/bin/nm-applet --indicator";
      };
    };

    # متغيرات النظام للواجهة
    environment.sessionVariables = {
      NIXOS_OZONE_WL = "1";
      WLR_NO_HARDWARE_CURSORS = "1";
    };

    # البرامج الخاصة بالواجهة
    environment.systemPackages = with pkgs; [
      kitty
      waybar
      wofi
      hyprpaper
      nautilus
      grim
      slurp
      wl-clipboard
      swww
      psmisc
      btop
      kdePackages.kcalc
      networkmanagerapplet # ضروري لإدارة الواي فاي
      libsecret             # لمساعدة الخزنة على حفظ الكلمات
      copyq
      wl-clipboard
    ];
    
    # الخطوط المطلوبة للبار والأيقونات
    fonts.packages = with pkgs; [
      font-awesome
      meslo-lgs-nf
    ];
  };
}
