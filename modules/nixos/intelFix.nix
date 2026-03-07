{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    sof-firmware
    alsa-ucm-conf
    alsa-tools  # 包含 hdajackretask 工具，用于调试
    pavucontrol # PulseAudio 音量控制，更精细的音频设备控制
  ];

  services.thermald.enable = true;
  boot.kernelParams = [
    "intel_pstate=active"
    # 尝试不同的 model，或者移除让驱动自动检测
    # "snd_hda_intel.model=alc287-thinkbook"
  ];

  boot.extraModprobeConfig = ''
    options snd-intel-dspcfg dsp_driver=3
    options snd-hda-intel
  '';

  boot.kernelModules = [ "intel_vpu" ];
}
