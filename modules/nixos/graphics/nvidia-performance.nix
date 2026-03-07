{ config, lib, pkgs, ... }:

{
  # 允许 NVIDIA unfree 包
  nixpkgs.config.allowUnfreePredicate = pkg:
    builtins.elem (pkgs.lib.getName pkg) [
      "nvidia-x11"
      "nvidia-persistenced"
    ];

  # 性能模式：独显作为默认渲染设备
  services.xserver.videoDrivers = [ "nvidia" ];

  hardware.nvidia = {
    open = true;
    package = config.boot.kernelPackages.nvidiaPackages.stable;

    modesetting.enable = true;
    nvidiaSettings = true;
    nvidiaPersistenced = true;

    # 性能优先：关闭细粒度省电，避免频繁上下电
    powerManagement.enable = lib.mkForce false;
    powerManagement.finegrained = lib.mkForce false;
    dynamicBoost.enable = true;

    prime = {
      nvidiaBusId = lib.mkDefault "PCI:2@0:0:0";

      # 性能模式关闭 offload，启用 sync
      offload.enable = lib.mkForce false;
      offload.enableOffloadCmd = lib.mkForce false;
      sync.enable = true;
    };
  };

  boot.kernelParams = [
    "nvidia-drm.modeset=1"
    "nvidia-drm.fbdev=1"
  ];

  environment.variables = {
    # 强制默认走 NVIDIA 用户态栈
    __EGL_VENDOR_LIBRARY_FILENAMES = "/run/opengl-driver/share/glvnd/egl_vendor.d/10_nvidia.json";
    __GLX_VENDOR_LIBRARY_NAME = "nvidia";
    __VK_LAYER_NV_optimus = "NVIDIA_only";
    NIXOS_OZONE_WL = "1";
  };

  environment.systemPackages = with pkgs; [
    nvtopPackages.full
  ];
}
