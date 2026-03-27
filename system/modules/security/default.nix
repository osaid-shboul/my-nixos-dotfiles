{ ... }:

{
  imports = [
    ./firewall.nix
    ./fail2ban.nix    
    ./apparmor.nix
    ./ssh.nix
    ./permissions.nix
    ];
}
