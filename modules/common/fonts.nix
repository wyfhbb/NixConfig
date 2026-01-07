{pkgs, ...}:{
  fonts = {
    packages = with pkgs; [
      # JetBrains 系列
      jetbrains-mono
      nerd-fonts.jetbrains-mono

      # Maple Mono 系列
      maple-mono.truetype
      maple-mono.NF-unhinted
      maple-mono.NF-CN-unhinted

      meslo-lgs-nf

      # 中文字体
      source-han-sans        # 思源黑体
      source-han-serif       # 思源宋体
      noto-fonts-cjk-sans    # Noto Sans CJK
      noto-fonts-cjk-serif   # Noto Serif CJK
      wqy_zenhei             # 文泉驿正黑

      # 编程字体
      fira-code              # Fira Code
      source-code-pro        # Source Code Pro

      # Emoji 和符号
      noto-fonts-color-emoji # Emoji 支持

      # 通用字体
      liberation_ttf         # Liberation 字体族
      dejavu_fonts           # DejaVu 字体族
    ];
  };
}