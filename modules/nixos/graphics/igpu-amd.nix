{ lib, pkgs, ... }:

{
  # AMD 核显基础图形栈（Mesa/RADV）
  hardware.graphics = {
    enable = true;
    enable32Bit = true;

    extraPackages = with pkgs; [
      vulkan-loader
      libvdpau-va-gl
    ];

    extraPackages32 = with pkgs.pkgsi686Linux; [
      vulkan-loader
    ];
  };

  # AMD VA-API 驱动（Mesa）
  environment.variables = {
    LIBVA_DRIVER_NAME = lib.mkDefault "radeonsi";
  };

  # 如果与 NVIDIA PRIME 联用，请在主机层设置实际 AMD Bus ID，例如：
  # hardware.nvidia.prime.amdBusId = "PCI:6@0:0:0";

  environment.systemPackages = with pkgs; [
    vulkan-tools
    libva-utils
    mesa-demos
    pciutils
  ];
}
