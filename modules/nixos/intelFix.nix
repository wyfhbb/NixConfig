{ config, pkgs, lib, ... }:

let
  # 下载固件文件
  wmfw = pkgs.fetchurl {
    url = "https://git.kernel.org/pub/scm/linux/kernel/git/firmware/linux-firmware.git/plain/cirrus/cs35l56/CS35L56_Rev3.11.28.wmfw";
    sha256 = "1macmwxx12ngvrllp74v1vxazwfjbyjk9cncjjy2172bi23j5db0";
  };
  bin1 = pkgs.fetchurl {
    url = "https://git.kernel.org/pub/scm/linux/kernel/git/firmware/linux-firmware.git/plain/cirrus/cs35l56-b0-dsp1-misc-17aa3921-spkid1-amp1.bin";
    sha256 = "1iyqv4ffdgr97d02w7s1dpc0wf25k8cp30cw9aa3x98kp22srlwa";
  };
  bin2 = pkgs.fetchurl {
    url = "https://git.kernel.org/pub/scm/linux/kernel/git/firmware/linux-firmware.git/plain/cirrus/cs35l56-b0-dsp1-misc-17aa3921-spkid1-amp2.bin";
    sha256 = "0mvp2fr0x9bkj4bls9xm67ykgsxffsa34nxmdzmgizqwcnaaz9wa";
  };

  # 创建自定义固件包 - 使用 hardware.firmware 但禁用压缩
  cs35l56-firmware = pkgs.runCommandLocal "cs35l56-firmware" {} ''
    mkdir -p $out/lib/firmware/cirrus/cs35l56
    # 小写变体
    cp ${bin1} "$out/lib/firmware/cirrus/cs35l56-b0-dsp1-misc-17aa3921-amp1.bin"
    cp ${bin2} "$out/lib/firmware/cirrus/cs35l56-b0-dsp1-misc-17aa3921-amp2.bin"
    cp ${wmfw} "$out/lib/firmware/cirrus/cs35l56-b0-dsp1-misc-17aa3921.wmfw"
  '';
in
{
  # 关键：禁用固件压缩！cs35l56 驱动不支持 .zst 压缩固件
  hardware.firmware = lib.mkBefore [ cs35l56-firmware ];
  hardware.enableAllFirmware = true;
  
  # 禁用固件压缩 - 这是关键！
  hardware.firmwareCompression = lib.mkForce "none";

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
