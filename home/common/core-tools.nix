# 核心命令行工具（所有平台通用）
{ config, pkgs, ... }:

{
  programs = {
    # 现代 vim
    neovim = {
      enable = true;
      defaultEditor = true;
      vimAlias = true;
      viAlias = true;

      extraConfig = ''
        set number relativenumber
        set expandtab tabstop=2 shiftwidth=2
        set ignorecase smartcase
        set clipboard=unnamedplus
      '';

      plugins = with pkgs.vimPlugins; [
        nvim-treesitter.withAllGrammars # 语法高亮
        telescope-nvim # 模糊搜索文件
        lualine-nvim # 状态栏
        catppuccin-nvim # 主题
      ];
    };

    tmux = {
      enable = true;
      mouse = true;
      baseIndex = 1;
      terminal = "screen-256color";

      extraConfig = ''
        # 快速重载配置
        bind r source-file ~/.config/tmux/tmux.conf \; display "配置已重载"

        # 分屏快捷键
        bind | split-window -h -c "#{pane_current_path}"
        bind - split-window -v -c "#{pane_current_path}"

        # Vim 风格窗格切换
        bind h select-pane -L
        bind j select-pane -D
        bind k select-pane -U
        bind l select-pane -R

        # 状态栏样式
        set -g status-style bg=default,fg=white
        set -g status-left-length 40
        set -g status-right "#[fg=cyan]%Y-%m-%d %H:%M"

        # 启用真彩色
        set -ga terminal-overrides ",*256col*:Tc"
      '';

      plugins = with pkgs.tmuxPlugins; [
        sensible
        yank
        resurrect
        continuum
      ];
    };
    # 终端文件管理器
    yazi = {
      enable = true;
      enableZshIntegration = true;
      settings = {
        manager = {
          show_hidden = true;
          sort_dir_first = true;
        };
      };
    };
    zsh = {
      enable = true;
      enableCompletion = true;
      autosuggestion.enable = true;
      syntaxHighlighting.enable = true;

      oh-my-zsh = {
        enable = true;
        plugins = [
          "git"
          "tmux"
        ];
        theme = "";
      };

      plugins = [
        {
          name = "powerlevel10k";
          src = pkgs.zsh-powerlevel10k;
          file = "share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
        }
      ];

      initContent = ''
        # Powerlevel10k 配置
        source ${./p10k.zsh}
        source ${./conda-init.zsh}
      '';
    };
  };
}
