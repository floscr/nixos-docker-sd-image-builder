{ lib, ... }: {
  imports = [
    # Select your destination system here. Available choices are:
    # - generic-aarch64
    # - rpi3 (alias for generic-aarch64)
    # - rpi4
    ./rpi4
  ];

  # The installer starts with a "nixos" user to allow installation, so add the SSH key to
  # that user. Note that the key is, at the time of writing, put in `/etc/ssh/authorized_keys.d`
  users.extraUsers.nixos.openssh.authorizedKeys.keys = [
    "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDQ+NcxEWCFLdenXYUeKtMmwmdKcovMGUi/VWiBRUZr6Ul5Bj7iu+29QL8j7g8Xi4cMdMA98CNKhBBSfdPZu1bApP97TgUfpbKMZmnMP9xKCPNkdQyO4D0EreBC6P9zMdq9LfNWl5non+8PZmZ55eeoSCC2CwQqWjq/IQjeCR4JB4Wc2IHsiTVItA5q6FQ+5nRXz13Rhk/uxWRQStlG5XTePdglOqz9F0fJRMC1NN1FbXBMBi7Cfpg+Tc6RWKFnNYJcIYrMa2CnF0fCEqivtmfr7AutsA3ygYsucfOZzmsOm2CE0A6x80qAtungFH+MpHOr9NWX5QU7jLUvhOzhErir floscr@thinknix"
  ];

  # bzip2 compression takes loads of time with emulation, skip it. Enable this if you're low
  # on space.
  sdImage.compressImage = false;

  # OpenSSH is forced to have an empty `wantedBy` on the installer system[1], this won't allow it
  # to be automatically started. Override it with the normal value.
  # [1] https://github.com/NixOS/nixpkgs/blob/9e5aa25/nixos/modules/profiles/installation-device.nix#L76
  systemd.services.sshd.wantedBy = lib.mkOverride 40 [ "multi-user.target" ];

  # Enable OpenSSH out of the box.
  services.sshd.enabled = true;

  # Wireless networking (1). You might want to enable this if your Pi is not attached via Ethernet.
  #networking.wireless = {
  #  enable = true;
  #  interfaces = [ "wlan0" ];
  #  networks = {
  #    "SSID" = {
  #      psk = "password";
  #    };
  #  };
  #};

  # Wireless networking (2). Enables `wpa_supplicant` on boot.
  #systemd.services.wpa_supplicant.wantedBy = lib.mkOverride 10 [ "default.target" ];

  # NTP time sync.
  #services.timesyncd.enable = true;
}
