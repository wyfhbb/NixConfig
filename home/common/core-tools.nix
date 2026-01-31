# 核心命令行工具（所有平台通用）
{ config, pkgs, ... }:

{
  # 添加本地二进制变量
  home.sessionPath = [ 
    "$HOME/.local/bin"
  ];

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

    # Git 配置
    git = {
      enable = true;

      # 用户信息（请修改为你的信息）
      userName = "wyf";
      userEmail = "102380235+wyfhbb@users.noreply.github.com";

      # 核心配置
      extraConfig = {
        # 基础设置
        init.defaultBranch = "main";
        core = {
          editor = "nvim";
          autocrlf = "input";  # Linux/Mac 使用 input，Windows 使用 true
          quotepath = false;   # 正确显示中文文件名
        };

        # 颜色配置
        color = {
          ui = "auto";
          branch = "auto";
          diff = "auto";
          status = "auto";
        };

        # 拉取策略
        pull.rebase = true;  # 使用 rebase 而不是 merge

        # 推送配置
        push = {
          default = "current";
          autoSetupRemote = true;  # 自动设置上游分支
        };

        # 分支配置
        branch.autoSetupRebase = "always";

        # 重写 URL（可选：HTTPS 转 SSH）
        # url."git@github.com:".insteadOf = "https://github.com/";

        # Diff 和 Merge 工具
        diff = {
          tool = "nvimdiff";
          algorithm = "histogram";  # 更好的 diff 算法
        };
        merge = {
          tool = "nvimdiff";
          conflictstyle = "diff3";  # 显示共同祖先
        };

        # 显示配置
        log.date = "relative";

        # 性能优化
        feature.manyFiles = true;  # 大仓库优化

        # 其他实用配置
        help.autocorrect = 1;  # 自动纠正拼写错误的命令
        rerere.enabled = true;  # 记住冲突解决方案
      };

      # Git 别名
      aliases = {
        # 状态和日志
        st = "status -sb";  # 简洁状态
        lg = "log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit";
        ll = "log --oneline --graph --all --decorate";

        # 提交相关
        co = "checkout";
        ci = "commit";
        cm = "commit -m";
        ca = "commit --amend";
        can = "commit --amend --no-edit";

        # 分支管理
        br = "branch";
        brd = "branch -d";
        brD = "branch -D";

        # 变更操作
        undo = "reset --soft HEAD^";  # 撤销上一次提交
        unstage = "reset HEAD --";    # 取消暂存

        # 差异查看
        df = "diff";
        dfc = "diff --cached";

        # 拉取和推送
        pl = "pull";
        ps = "push";
        pf = "push --force-with-lease";  # 更安全的强制推送

        # 其他实用命令
        last = "log -1 HEAD --stat";  # 查看最后一次提交
        alias = "config --get-regexp ^alias\\.";  # 列出所有别名
      };

      # Git 忽略文件（全局）- 只包含系统垃圾文件
      ignores = [
        # macOS 系统文件
        ".DS_Store"
        ".AppleDouble"
        ".LSOverride"

        # Windows 系统文件
        "Thumbs.db"
        "Desktop.ini"
        "$RECYCLE.BIN/"

        # Linux 系统文件
        ".Trash-*"
        ".directory"
      ];
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
          "docker"
          "docker-compose"
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
