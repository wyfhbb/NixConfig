{
  description = "My Cross-Platform Nix Configuration";

  # ============================================
  # inputs: 声明这个 flake 依赖的外部资源
  # ============================================

  nixConfig = {
    substituters = [
      # Query the mirror of USTC first, and then the official cache.
      "https://mirrors.ustc.edu.cn/nix-channels/store"
      "https://cache.nixos.org"
    ];
  };

  inputs = {
    # nixpkgs: Nix 官方软件包仓库（所有平台共用一个版本，简化配置）
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";

    # home-manager: 用户环境管理工具（管理 dotfiles、软件等）
    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs"; # 让 home-manager 使用我们的 nixpkgs
    };

    # nix-darwin: macOS 系统管理工具
    darwin = {
      url = "github:LnL7/nix-darwin/nix-darwin-25.11";
      inputs.nixpkgs.follows = "nixpkgs"; # 让 darwin 使用我们的 nixpkgs
    };

    # nix-homebrew: 用 Nix 管理 Homebrew
    nix-homebrew.url = "github:zhaofengli/nix-homebrew";

    # NixOS-WSL: 在 WSL 中运行 NixOS 的特殊模块
    nixos-wsl = {
      url = "github:nix-community/NixOS-WSL/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  # ============================================
  # outputs: 定义这个 flake 提供的输出
  # ============================================
  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      darwin,
      nix-homebrew,
      nixos-wsl,
      ...
    }@inputs:
    let
      # ========== 全局变量定义 ==========
      # 所有主机配置的变量都在这里集中管理，方便维护

      # 默认用户名（所有主机共用）
      username = "wyf";

    in
    {
      # ==========================================
      # darwinConfigurations: macOS 系统配置
      # ==========================================
      darwinConfigurations = {
        # 配置名称: wyf-macbook（你可以自定义，部署时会用到）
        wyf-macbook =
          let
            # 此主机的特定变量
            hostname = "wyf-macbook";
            system = "aarch64-darwin";
          in
          darwin.lib.darwinSystem {
            inherit system;

            # specialArgs: 传递自定义变量给所有模块
            # 这样所有模块都可以通过函数参数访问 username 和 hostname
            specialArgs = {
              inherit username hostname;
            };

            # modules: 要导入的配置模块列表
            modules = [
              # 导入主机特定的配置文件
              ./hosts/wyf-macbook

              # 集成 home-manager（用于管理用户配置）
              home-manager.darwinModules.home-manager
              {
                # home-manager 配置
                home-manager.useGlobalPkgs = true; # 使用系统级的 pkgs
                home-manager.useUserPackages = true; # 用户包安装到用户环境
                home-manager.users.${username} = import ./home/profiles/macos.nix;
              }

              # 集成 nix-homebrew
              nix-homebrew.darwinModules.nix-homebrew
              {
                nix-homebrew = {
                  enable = true;
                  user = username;
                };
              }
            ];
          };
      };

      # ==========================================
      # formatter: 代码格式化工具
      # ==========================================
      formatter = {
        x86_64-linux = nixpkgs.legacyPackages.x86_64-linux.nixfmt-tree;
        aarch64-darwin = nixpkgs.legacyPackages.aarch64-darwin.nixfmt-tree;
      };

      # ==========================================
      # nixosConfigurations: Linux 系统配置
      # ==========================================
      nixosConfigurations = {
        # ===== WSL 配置 =====
        wsl =
          let
            hostname = "nixwsl";
            system = "x86_64-linux";
          in
          nixpkgs.lib.nixosSystem {
            inherit system;

            specialArgs = {
              inherit username hostname;
            };

            modules = [
              ./hosts/wsl

              # 导入 NixOS-WSL 的特殊模块
              nixos-wsl.nixosModules.wsl

              # 集成 home-manager
              home-manager.nixosModules.home-manager
              {
                home-manager.useGlobalPkgs = true;
                home-manager.useUserPackages = true;
                home-manager.users.${username} = import ./home/profiles/wsl.nix;
              }
            ];
          };

        # ===== VPS 服务器配置 =====
        vps =
          let
            hostname = "vps-server";
            system = "x86_64-linux";
          in
          nixpkgs.lib.nixosSystem {
            inherit system;

            specialArgs = {
              inherit username hostname;
            };

            modules = [
              ./hosts/vps-server

              # 服务器也用精简配置
              home-manager.nixosModules.home-manager
              {
                home-manager.useGlobalPkgs = true;
                home-manager.useUserPackages = true;
                home-manager.users.${username} = import ./home/profiles/server.nix;
              }
            ];
          };

        # ===== 桌面 Linux 配置 =====
        desktop =
          let
            hostname = "nixos-wyf";
            system = "x86_64-linux";
          in
          nixpkgs.lib.nixosSystem {
            inherit system;

            specialArgs = {
              inherit username hostname;
            };

            modules = [
              ./hosts/desktop-linux

              # 桌面用完整配置（包含 GUI）
              home-manager.nixosModules.home-manager
              {
                home-manager.useGlobalPkgs = true;
                home-manager.useUserPackages = true;
                home-manager.users.${username} = import ./home/profiles/desktop.nix;
              }
            ];
          };
      };
    };
}
