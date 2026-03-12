{ pkgs, inputs, ... }:

{
  boot = {
    loader = {
      limine = {
        enable = true;
        style = {
          interface = {
            resolution = "1920x1080";
          };
        };
      };
      efi = {
        canTouchEfiVariables = true;
      };
    };

    plymouth = {
      enable = true;
      theme = "bgrt";
    };

    consoleLogLevel = 0;

    initrd = {
      verbose = false;
      systemd = {
        enable = true;
      };
      luks = {
        devices = {
          crypted = {
            device = "/dev/disk/by-uuid/2103bd0c-b53c-4f7c-851a-0ac8fae53ce7";
            crypttabExtraOpts = [ "tpm2-device=auto" ];
          };
        };
      };
      availableKernelModules = [
        "xhci_pci"
        "ahci"
        "nvme"
        "usbhid"
        "usb_storage"
        "sd_mod"
      ];
      kernelModules = [
        "nvidia"
        "nvidia_modeset"
        "nvidia_uvm"
        "nvidia_drm"
      ];
    };

    kernelParams = [
      "quiet"
      "splash"
      "boot.shell_on_fail"
      "rd.systemd.show_status=false"
      "rd.udev.log_level=3"
      "udev.log_priority=3"
      "video=1920x1080"
      "nvidia-drm.modeset=1"
      "nvidia-drm.fbdev=1"
    ];

    kernelPackages =
      pkgs.linuxPackagesFor
        inputs.nix-cachyos-kernel.packages.${pkgs.system}.linux-cachyos-latest-lto-x86_64-v3;

    kernelModules = [ "kvm-intel" ];
    extraModulePackages = [ ];

    kernel = {
      sysctl = {
        "net.ipv4.tcp_congestion_control" = "bbr";
        "net.core.default_qdisc" = "cake";
        "net.ipv4.tcp_fastopen" = 3;
        "net.ipv4.tcp_mtu_probing" = 1;

        "vm.swappiness" = 10;
        "vm.vfs_cache_pressure" = 50;
        "vm.dirty_background_ratio" = 5;
        "vm.dirty_ratio" = 10;
        "vm.max_map_count" = 2147483642;
      };
    };
  };
}
