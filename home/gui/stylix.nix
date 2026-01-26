# Stylix Home Manager 配置
# 处理 Qt 主题等用户级设置
{ lib, ... }:

{
  # ────────────────────────────────────────────────
  # Qt 主题配置
  # ────────────────────────────────────────────────
  qt = {
    enable = true;
    # 使用 adwaita 替代已弃用的 gnome
    platformTheme.name = "adwaita";
    style.name = "adwaita-dark";
  };

  # ────────────────────────────────────────────────
  # Stylix 用户级目标配置
  # ────────────────────────────────────────────────
  stylix.targets = {
    # 禁用 Qt 的 stylix 管理（使用上面的手动配置避免警告）
    qt.enable = false;
    noctalia-shell.enable = false;
  };
}
