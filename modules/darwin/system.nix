# macOS 系统设置
{ config, pkgs, ... }:
###################################################################################
#
#  macOS 系统配置
#
#  所有的配置选项都在这里有文档记录:
#    https://daiderd.com/nix-darwin/manual/index.html#sec-options
#  macOS `defaults` 命令的不完整列表 (用于查询配置键值):
#    https://github.com/yannbertrand/macos-defaults
#
###################################################################################
{
  imports = [
    ../common/apps.nix
  ];
  # TODO: 添加 macOS 特定配置
  # 允许使用 TouchID 进行 sudo 身份验证 (在终端使用 sudo 时可用指纹解锁)
  security.pam.services.sudo_local.touchIdAuth = true;

  system = {
    stateVersion = 6;

    defaults = {
      menuExtraClock.Show24Hour = true; # show 24 hour clock

      dock = {
        # 自定义触发角 (Hot Corners, 鼠标移动到屏幕角落时触发的动作)
        wvous-tl-corner = 2; # 左上角 - 调度中心 (Mission Control)
        wvous-tr-corner = 1; # 右上角 - 禁用
        wvous-bl-corner = 1; # 左下角 - 禁用
        wvous-br-corner = 1; # 右下角 - 禁用
      };

      # 自定义 Finder (访达)
      finder = {
        _FXShowPosixPathInTitle = true; # 在 Finder 标题栏显示完整 POSIX 路径
        AppleShowAllExtensions = true; # 显示所有文件的扩展名
        FXEnableExtensionChangeWarning = false; # 更改文件扩展名时不显示警告
        QuitMenuItem = true; # 允许通过菜单“退出” Finder (通常 Finder 是不能退出的)
        ShowPathbar = true; # 底部显示路径栏
        ShowStatusBar = true; # 底部显示状态栏
      };

      # 自定义触控板
      trackpad = {
        Clicking = true; # 启用“轻点来点击” (不需要用力按下，只需轻触)
        TrackpadRightClick = true; # 启用双指右键
        TrackpadThreeFingerDrag = true; # 启用三指拖移 (非常有用的功能)
      };

      # 自定义 nix-darwin 没有直接支持的设置
      # macOS `defaults` 命令的不完整列表:
      #   https://github.com/yannbertrand/macos-defaults
      NSGlobalDomain = {
        AppleKeyboardUIMode = 3; # 模式 3 启用全键盘控制 (Tab 键可切换所有控件焦点)
        # ApplePressAndHoldEnabled = true;          # 启用按住按键显示重音符/特殊字符

        # 如果你在文本区域按住某些键，字符会开始重复输入。
        # 这对 Vim 用户非常有用，因为他们使用 `hjkl` 来移动光标。
        # 此设置决定了按住多久后开始重复。
        InitialKeyRepeat = 15; # 正常最小值是 15 (225 毫秒), 最大值是 120 (1800 毫秒)
        # 此设置决定了开始重复后的重复速度。
        KeyRepeat = 3; # 正常最小值是 2 (30 毫秒), 最大值是 120 (1800 毫秒)

        NSAutomaticCapitalizationEnabled = false; # 禁用自动大写
        NSAutomaticDashSubstitutionEnabled = false; # 禁用智能破折号替换 (如将 -- 替换为 —)
        NSAutomaticPeriodSubstitutionEnabled = false; # 禁用智能句号替换 (如双击空格变句号)
        NSAutomaticQuoteSubstitutionEnabled = false; # 禁用智能引号替换 (如将直引号变为弯引号)
        NSAutomaticSpellingCorrectionEnabled = false; # 禁用自动拼写纠正
        NSNavPanelExpandedStateForSaveMode = true; # 默认展开保存面板 (保存文件时的详细路径选择页)
        NSNavPanelExpandedStateForSaveMode2 = true;
        NSWindowShouldDragOnGesture = true;  # 启用 Control+Command 拖移窗口
      };

      # 自定义更多 nix-darwin 不直接支持的设置
      # 可以查看此项目的源码以获取更多未记录的选项:
      #    https://github.com/rgcr/m-cli
      #
      # 所有自定义条目可以通过运行 `defaults read` 命令找到。
      # 或者使用 `defaults read xxx` 读取特定的域。
      CustomUserPreferences = {
        "com.apple.finder" = {
          ShowExternalHardDrivesOnDesktop = true; # 在桌面显示外接硬盘
          ShowMountedServersOnDesktop = true; # 在桌面显示已挂载的服务器
          ShowRemovableMediaOnDesktop = true; # 在桌面显示可移动媒体 (如 U 盘)
          _FXSortFoldersFirst = true; # 排序时文件夹显示在最前 (类似 Windows 的逻辑)
          FXDefaultSearchScope = "SCcf"; # 执行搜索时，默认搜索当前文件夹 ("SCcf")
        };
        "com.apple.desktopservices" = {
          # 避免在网络存储或 USB 卷上创建 .DS_Store 文件
          DSDontWriteNetworkStores = true;
          DSDontWriteUSBStores = true;
        };
        "com.apple.AdLib" = {
          allowApplePersonalizedAdvertising = false; # 关闭 Apple 个性化广告
        };
        # 防止设备插入时自动打开“照片”应用
        "com.apple.ImageCapture".disableHotPlug = true;
      };
    };
  };
}
