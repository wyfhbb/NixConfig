{ lib, pkgs, ... }:

{
  # Intel 核显基础图形栈
  hardware.graphics = {
    enable = true;
    enable32Bit = true;

    extraPackages = with pkgs; [
      # 新 Intel GPU (Broadwell+) 推荐 iHD
      intel-media-driver
      vulkan-loader
      intel-compute-runtime
      libvdpau-va-gl
    ];

    extraPackages32 = with pkgs.pkgsi686Linux; [
      intel-media-driver
      vulkan-loader
    ];
  };

  # PRIME 与 Intel 核显配合时使用
  hardware.nvidia.prime.intelBusId = lib.mkDefault "PCI:0@0:2:0";

  environment.variables = {
    LIBVA_DRIVER_NAME = lib.mkDefault "iHD";
  };

  environment.systemPackages = with pkgs; [
    vulkan-tools
    libva-utils
    mesa-demos
    pciutils
  ];
}
