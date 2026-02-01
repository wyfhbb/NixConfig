{ config, pkgs, ... }:

{
  # 必须：允许 NVIDIA unfree 包（user-space 仍是闭源）
  nixpkgs.config.allowUnfreePredicate = pkg:
    builtins.elem (pkgs.lib.getName pkg) [
      "nvidia-x11"          # NVIDIA 驱动（名字虽有 x11，但 Wayland 也需要）
      "nvidia-persistenced"
    ];

  # 图形支持（新版 NixOS 必须）
  hardware.graphics = {
    enable = true;
    enable32Bit = true;  # 32 位应用支持

    # Intel 核显硬件加速驱动（VA-API + Vulkan）
    extraPackages = with pkgs; [
      # VA-API 视频解码/编码
      intel-media-driver      # 新 Intel GPU (Broadwell+) - 解码和编码
      intel-vaapi-driver      # 老 Intel GPU 兼容（如果确定是新 GPU 可移除）

      # Vulkan 驱动（现代图形 API，WebGPU 需要）
      intel-media-driver      # Intel Vulkan 驱动

      # OpenCL 支持
      intel-compute-runtime   # OpenCL 支持

      # libva-vdpau-driver    # VDPAU 桥接（仅旧应用需要，现代应用直接用 VA-API）
      # libvdpau-va-gl        # VDPAU 桥接（仅旧应用需要）
    ];

    # 32 位硬件加速支持（某些游戏/应用需要）
    extraPackages32 = with pkgs.pkgsi686Linux; [
      intel-media-driver
      # libva-vdpau-driver    # 仅旧应用需要
    ];
  };

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
    nvidiaSettings = false;             # nvidia-settings 主要用于 X11 调优，Wayland 下可禁用节省空间
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
    # 注意：PRIME Offload 模式下，大部分应用默认用 Intel 核显
    # 只有通过 nvidia-offload 命令启动的应用才用 NVIDIA

    # Intel 核显优先用于日常任务（包括视频解码/编码）
    LIBVA_DRIVER_NAME = "iHD";             # iHD = intel-media-driver（推荐）
    # 如果 iHD 有问题，可改为 "i965" (intel-vaapi-driver)

    # 注意: 不设置 NIXOS_OZONE_WL，让 Chrome 使用 XWayland (X11)
    # 这样可以在 Wayland 会话中启用 Vulkan + WebGPU 支持

    # NVIDIA 相关环境变量（仅在 offload 时生效）
    __GLX_VENDOR_LIBRARY_NAME = "nvidia";  # GLX offload 支持
    # GBM_BACKEND = "nvidia-drm";          # 注释掉，避免与 Intel 冲突
  };

  # 推荐工具
  environment.systemPackages = with pkgs; [
    nvtopPackages.full     # 超好用的 GPU 监控（看独显是否真的休眠）
    mesa                   # 确保 Intel 核显 OpenGL/Vulkan 支持
    vulkan-tools           # Vulkan 工具（vulkaninfo 等）
    libva-utils            # VA-API 工具（vainfo 等）
  ];
}