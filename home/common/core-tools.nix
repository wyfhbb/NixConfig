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
        set termguicolors
        set signcolumn=yes
        set updatetime=250
      '';

      # Lua 配置
      extraLuaConfig = ''
        -- Leader 键设为空格（必须在最前面）
        vim.g.mapleader = ' '
        vim.g.maplocalleader = ' '

        -- 主题
        vim.cmd.colorscheme "catppuccin-mocha"

        -- lualine 状态栏
        require('lualine').setup { options = { theme = 'catppuccin' } }

        -- nvim-tree 文件树
        require('nvim-tree').setup()
        vim.keymap.set('n', '<leader>e', ':NvimTreeToggle<CR>', { desc = '文件树' })

        -- telescope 模糊搜索
        local builtin = require('telescope.builtin')
        vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = '搜索文件' })
        vim.keymap.set('n', '<leader>fg', builtin.live_grep, { desc = '全局搜索' })
        vim.keymap.set('n', '<leader>fb', builtin.buffers, { desc = '切换 Buffer' })

        -- comment.nvim 注释
        require('Comment').setup()

        -- nvim-autopairs 自动括号
        require('nvim-autopairs').setup()

        -- nvim-surround 包围符号
        require('nvim-surround').setup()

        -- leap 快速跳转
        require('leap').add_default_mappings()

        -- gitsigns Git 标记
        require('gitsigns').setup()

        -- which-key 快捷键提示
        require('which-key').setup()

        -- indent-blankline 缩进线
        require('ibl').setup()

        -- bufferline 标签栏
        require('bufferline').setup {
          options = {
            diagnostics = false,
            show_buffer_close_icons = false,
            show_close_icon = false,
          }
        }
        vim.keymap.set('n', '<Tab>', ':BufferLineCycleNext<CR>', { desc = '下一个标签' })
        vim.keymap.set('n', '<S-Tab>', ':BufferLineCyclePrev<CR>', { desc = '上一个标签' })
        vim.keymap.set('n', '<leader>x', ':bdelete<CR>', { desc = '关闭当前标签' })
      '';

      plugins = with pkgs.vimPlugins; [
        nvim-treesitter.withAllGrammars # 语法高亮
        telescope-nvim # 模糊搜索文件
        plenary-nvim # telescope 依赖
        lualine-nvim # 状态栏
        catppuccin-nvim # 主题

        # 文件导航
        nvim-tree-lua # 文件树 (:NvimTreeToggle)
        nvim-web-devicons # 文件图标

        # 编辑增强
        nvim-autopairs # 自动补全括号
        nvim-surround # 快速操作包围符号 (ys/cs/ds)
        comment-nvim # 快速注释 (gcc)
        leap-nvim # 快速跳转 (s + 两个字符)

        # Git 集成
        gitsigns-nvim # 显示 git 修改标记

        # 实用工具
        which-key-nvim # 快捷键提示
        indent-blankline-nvim # 显示缩进线
        bufferline-nvim # 顶部标签栏
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
