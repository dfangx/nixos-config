{ config, pkgs, lib, inputs, host, ... }:
{
  options.qemu.enable = lib.mkEnableOption "Enable QEMU options";
  config = lib.mkIf config.qemu.enable {
    virtualisation = {
      spiceUSBRedirection.enable = true;
      libvirtd = {
        enable = true;
        qemu = {
          ovmf = {
            enable = true;
            packages = [ pkgs.OVMFFull.fd ];
          };
          swtpm.enable = true;
        };
      };
    };

    programs = {
      virt-manager.enable = true;
    };
    services = {
      spice-vdagentd.enable = true;
      qemuGuest.enable = true;
    };
    users.users.cyrusng = {
      extraGroups = [ "libvirtd" ];
    };
  };
}

