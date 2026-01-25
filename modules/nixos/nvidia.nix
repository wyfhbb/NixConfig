{ config, pkgs, ... }:

{
  # 必须：允许 NVIDIA unfree 包（user-space 仍是闭源）
  nixpkgs.config.allowUnfreePredicate = pkg:
    builtins.elem (pkgs.lib.getName pkg) [
      "nvidia-x11"
      "nvidia-settings"
      "nvidia-persistenced"
    ];

  # 图形支持（新版 NixOS 必须）
  hardware.graphics.enable = true;

  # 视频驱动：modesetting 给 Intel 核显用，nvidia 给独显用
  # 顺序重要：modesetting 放前面，确保 X/Wayland 默认用 Intel
  services.xserver.videoDrivers = [ "modesetting" "nvidia" ];

  hardware.nvidia = {
    # RTX 50 系列推荐 open = true（开源内核模块，更好兼容 Wayland + 电源管理）
    open = true;

    # 稳定版驱动（RTX 50 系列已支持，推荐 stable 或 production）
    package = config.boot.kernelPackages.nvidiaPackages.stable;
    # 如果 stable 不行或想更新更快：用 .production 或 .beta

    modesetting.enable = true;          # Wayland / 混合图形必须
    nvidiaSettings = true;              # 安装 nvidia-settings（可选查看/调优）
    nvidiaPersistenced = true;          # 帮助电源管理和稳定性

    # 电源管理（笔记本强烈推荐，帮独显更容易休眠）
    powerManagement.enable = true;
    powerManagement.finegrained = true;  # RTX 40/50 系列支持更细粒度省电，可选开启试试
  };

  # PRIME Offload 配置：核显优先，独显按需
  hardware.nvidia.prime = {
    offload = {
      enable = true;
      enableOffloadCmd = true;          # 关键！生成 nvidia-offload 命令
    };

    # 你的 PCI ID（已转换）
    intelBusId = "PCI:0@0:2:0";
    nvidiaBusId = "PCI:2@0:0:0";
  };

  # Wayland / 常见修复（强烈建议加）
  boot.kernelParams = [
    "nvidia-drm.modeset=1"            # Wayland 支持必须
    # 如果 suspend/resume 有问题，可加下面这行（把临时文件放 /var/tmp，避免 /tmp 被清）
    # "nvidia.NVreg_TemporaryFilePath=/var/tmp"
  ];

  # 环境变量（修复部分 Electron/Chromium 应用 + 硬件解码）
  environment.variables = {
    __GLX_VENDOR_LIBRARY_NAME = "nvidia";  # 帮助 offload 时正确选 nvidia
    GBM_BACKEND = "nvidia-drm";
    LIBVA_DRIVER_NAME = "nvidia";          # VA-API 硬件解码（如果用独显时）
  };

  # 推荐工具
  environment.systemPackages = with pkgs; [
    nvtopPackages.full     # 超好用的 GPU 监控（看独显是否真的休眠）
    mesa                   # 确保 Intel 核显 OpenGL/Vulkan 支持
  ];
}