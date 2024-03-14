{modulesPath, ...}: {
  imports = [(modulesPath + "/profiles/qemu-guest.nix")];
  boot.loader.grub = {
    efiSupport = true;
    efiInstallAsRemovable = true;
    device = "nodev";
  };

  boot.initrd.availableKernelModules = ["ata_piix" "uhci_hcd" "virtio_pci" "virtio_scsi" "sd_mod"];
  boot.initrd.kernelModules = [];
  boot.kernelModules = ["kvm-amd"];
  boot.extraModulePackages = [];
  zramSwap.enable = true;
  boot.tmp.cleanOnBoot = true;

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/1FC5-9E05";
    fsType = "vfat";
  };

  fileSystems."/" = {
    device = "/dev/sda1";
    fsType = "ext4";
  };


  fileSystems."/media" = {
    device = "/dev/sda14";
    fsType = "ext4";
  };
}
