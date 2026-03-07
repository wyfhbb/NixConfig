{ config, lib, pkgs, ... }:

{
  # 允许 NVIDIA unfree 包
  nixpkgs.config.allowUnfreePredicate = pkg:
    builtins.elem (pkgs.lib.getName pkg) [
      "nvidia-x11"
      "nvidia-persistenced"
    ];

  # Offload 省电模式：集显负责日常显示，独显按需调用
  services.xserver.videoDrivers = [ "modesetting" "nvidia" ];

  hardware.nvidia = {
    open = true;
    package = config.boot.kernelPackages.nvidiaPackages.stable;

    modesetting.enable = true;
    nvidiaSettings = false;
    nvidiaPersistenced = false;

    powerManagement.enable = true;
    powerManagement.finegrained = true;
    dynamicBoost.enable = true;

    prime = {
      nvidiaBusId = lib.mkDefault "PCI:2@0:0:0";

      offload = {
        enable = true;
        enableOffloadCmd = true;
      };

      sync.enable = lib.mkForce false;
    };
  };

  boot.kernelParams = [
    "nvidia-drm.modeset=1"
    "nvidia-drm.fbdev=1"
  ];

  environment.variables = {
    # Offload 场景下优先走 Mesa EGL（通常由核显承担桌面渲染）
    __EGL_VENDOR_LIBRARY_FILENAMES = "/run/opengl-driver/share/glvnd/egl_vendor.d/50_mesa.json";
    NIXOS_OZONE_WL = "1";
  };

  environment.systemPackages = with pkgs; [
    nvtopPackages.full
  ];
}
