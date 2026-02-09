{ config, pkgs, ... }:

{
  # 必须：允许 NVIDIA unfree 包
  nixpkgs.config.allowUnfreePredicate = pkg:
    builtins.elem (pkgs.lib.getName pkg) [
      "nvidia-x11"
      "nvidia-persistenced"
    ];

  # 图形支持
  hardware.graphics = {
    enable = true;
    enable32Bit = true;

    extraPackages = with pkgs; [
      # VA-API 视频解码/编码（二选一即可，新 Intel GPU 用 intel-media-driver）
      intel-media-driver      # 新 Intel GPU (Broadwell+)
      # intel-vaapi-driver    # 老 Intel GPU，确定是新 GPU 可注释掉

      # Vulkan 支持（mesa 已包含 Intel Vulkan 驱动 ANV）
      vulkan-loader

      # OpenCL 支持
      intel-compute-runtime

      # VDPAU -> VA-API 桥接（部分旧应用如 mpv 旧配置可能需要）
      libvdpau-va-gl
    ];

    extraPackages32 = with pkgs.pkgsi686Linux; [
      intel-media-driver
      vulkan-loader
    ];
  };

  # 视频驱动顺序：modesetting 优先（Intel），nvidia 其次
  services.xserver.videoDrivers = [ "modesetting" "nvidia" ];

  hardware.nvidia = {
    # RTX 50/40/30 系列推荐 open = true
    # 如果遇到 50W TDP 锁功耗问题，或者是旧款显卡，尝试改为 false 使用闭源内核模块
    open = true;

    package = config.boot.kernelPackages.nvidiaPackages.stable;

    modesetting.enable = true;
    nvidiaSettings = false;             # Wayland 下不需要
    
    # ！！！关键修改：Offload 模式下为了让显卡休眠（D3cold），必须关闭 persistenced
    nvidiaPersistenced = false;

    # 电源管理
    powerManagement.enable = true;
    powerManagement.finegrained = true; # RTX 30+ 支持细粒度省电

    # 尝试解决 50W 锁功耗问题 (启用 Dynamic Boost)
    # 注意：这需要 hardware.opengl.extraPackages 中包含 nvidia-powerd 的相关支持，
    # 或者某些 NixOS 版本通过 dynamicBoost.enable 开启。
    # 25.05+ 后通常不需要手动配置 powerd，但如果有问题可尝试显式开启：
    dynamicBoost.enable = true; 

    # PRIME Offload 配置
    prime = {
      offload = {
        enable = true;
        enableOffloadCmd = true;        # 生成 nvidia-offload 命令
      };

      # PCI Bus ID（根据你的硬件）
      intelBusId = "PCI:0@0:2:0";
      nvidiaBusId = "PCI:2@0:0:0";
    };
  };

  # 内核参数
  boot.kernelParams = [
    "nvidia-drm.modeset=1"
    "nvidia-drm.fbdev=1"              # 改善 TTY/Plymouth 显示
    # suspend 问题可取消注释:
    # "nvidia.NVreg_PreserveVideoMemoryAllocations=1"
  ];

  # 环境变量
  environment.variables = {
    # Intel VA-API 驱动
    LIBVA_DRIVER_NAME = "iHD";

    # Vulkan 设备选择：优先 Intel（设备索引 0 通常是集显）
    # 如果应用支持，可用此变量指定默认 Vulkan 设备
    # VK_LOADER_DEVICE_SELECT = "10de:*";  # 强制选择 NVIDIA
  };

  # 环境变量 - sessionVariables 更适合桌面会话
  environment.sessionVariables = {
    # EGL 优先用 Mesa（Intel）
    __EGL_VENDOR_LIBRARY_FILENAMES = "/run/opengl-driver/share/glvnd/egl_vendor.d/50_mesa.json";

    # CUDA/NVIDIA 库路径 - 让 PyTorch 等能找到 NVIDIA 驱动
    LD_LIBRARY_PATH = "/run/opengl-driver/lib";

    # Electron/Chromium Wayland 支持（可选，启用后 Chrome 原生 Wayland）
    # NIXOS_OZONE_WL = "1";

    # 如果需要强制 GLX 用 NVIDIA（offload 场景通常不需要全局设置）
    # __GLX_VENDOR_LIBRARY_NAME = "nvidia";
  };

  # 工具包
  environment.systemPackages = with pkgs; [
    nvtopPackages.full        # GPU 监控
    vulkan-tools              # vulkaninfo
    libva-utils               # vainfo
    mesa-demos                   # GLX 信息
    pciutils                  # lspci
  ];
}