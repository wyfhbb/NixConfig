# 终端应用配置（桌面和 macOS）
{...}: {
  xdg.configFile."ghostty/config".text = ''
    font-family = "MesloLGS NF"
    font-size = 14.6

    # 自动复制选中文本到系统剪切板
    copy-on-select = clipboard

    # 确认关闭窗口时不显示确认提示
    confirm-close-surface = false
    # 光标轨迹特效相关文件
    custom-shader = ${../../config/cursor_smear.glsl}
    
    background = #1F1F1F
    foreground = #CCCCCC
    
    palette = 0=#000000
    palette = 1=#d6181b
    palette = 2=#6A9955
    palette = 3=#e4d201
    palette = 4=#569cd6
    palette = 5=#bc3fbc
    palette = 6=#4EC9B0
    palette = 7=#e5e5e5
    palette = 8=#666666
    palette = 9=#ce9178
    palette = 10=#b5cea8
    palette = 11=#DCDCAA
    palette = 12=#9cdcfe
    palette = 13=#d670d6
    palette = 14=#9cdcfe
    palette = 15=#e5e5e5
    
    window-padding-x = 5
    window-padding-y = 5
    background-opacity = 0.7
    background-blur = true
    
    # Mac OS specific
    macos-titlebar-style = transparent
  '';
}
