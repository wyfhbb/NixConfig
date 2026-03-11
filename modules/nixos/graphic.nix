{ ... }:

{
  # 图形组合选择（同一时刻只启用一个组合）
  # 默认启用：Intel 核显 + NVIDIA 省电 Offload
  imports = [
    # ===== 1) Intel 核显 + NVIDIA 省电（默认）=====
    # ./graphics/igpu-intel.nix
    # ./graphics/nvidia-powersave.nix

    # ===== 2) Intel 核显 + NVIDIA 性能模式 =====
    # ./graphics/igpu-intel.nix
    # ./graphics/nvidia-performance.nix

    # ===== 3) AMD 核显 + NVIDIA 省电 =====
    # ./graphics/igpu-amd.nix
    # ./graphics/nvidia-powersave.nix
    # 注意：需要在主机层设置 hardware.nvidia.prime.amdBusId

    # ===== 4) AMD 核显 + NVIDIA 性能模式 =====
    # ./graphics/igpu-amd.nix
    # ./graphics/nvidia-performance.nix
    # 注意：需要在主机层设置 hardware.nvidia.prime.amdBusId

    # ===== 5) 仅 Intel 核显 =====
    # ./graphics/igpu-intel.nix

    # ===== 6) 仅 AMD 核显 =====
    ./graphics/igpu-amd.nix
  ];
}
