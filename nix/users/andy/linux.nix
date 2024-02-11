{ pkgs, inputs, ... }:
{
  config = {
    programs.zsh.enable = true;

    users.users.andy = {
      isNormalUser = true;
      home = "/home/andy";
      extraGroups = [ "docker" "wheel" "wireshark" ];
      shell = pkgs.zsh;
      hashedPassword = "$6$XBMSmc8cQl/ziMpG$foWH9T5Ygy4l6C4RjdVenAO3/HgD6uswn3tzGQ/P1BMNC9t9Yh/gW8u2KV1e84AvaWpiMFmpXbYzgsB5cWLe.1";
      # openssh.authorizedKeys.keys = [
      #   "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPj3mSTTXkRf04WU/7D1l+G8j8/fOGoXLdgHJXviXBhg andy"
      # ];
    };
  };
}
