{ pkgs, lib, ... }:

let
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

  # cs35l56 固件文件名需要和驱动预期完全一致
  cs35l56-firmware = pkgs.runCommandLocal "cs35l56-firmware" {} ''
    mkdir -p $out/lib/firmware/cirrus/cs35l56
    cp ${bin1} "$out/lib/firmware/cirrus/cs35l56-b0-dsp1-misc-17aa3921-amp1.bin"
    cp ${bin2} "$out/lib/firmware/cirrus/cs35l56-b0-dsp1-misc-17aa3921-amp2.bin"
    cp ${wmfw} "$out/lib/firmware/cirrus/cs35l56-b0-dsp1-misc-17aa3921.wmfw"
  '';
in
{
  # cs35l56 驱动不支持 .zst 压缩固件
  hardware.firmware = lib.mkBefore [ cs35l56-firmware ];
  hardware.enableAllFirmware = true;
  hardware.firmwareCompression = lib.mkForce "none";
}
