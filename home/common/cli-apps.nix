{pkgs, ...}: {
  home.packages = with pkgs; [
    uv
  ];

  programs = {
    # modern vim
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
        nvim-treesitter.withAllGrammars  # 语法高亮
        telescope-nvim                    # 模糊搜索文件
        lualine-nvim                      # 状态栏
        catppuccin-nvim                   # 主题
      ];
    };

    # terminal file manager
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
  };
}
