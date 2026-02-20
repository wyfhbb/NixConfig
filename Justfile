# just 是一个命令运行器，类似 Makefile 但更简单



# 列出所有可用的命令
default:
  @just --list

############################################################################
#
#  系统部署命令
#
############################################################################

# 首次初始化系统（启用 flake 和必要的实验性功能）
# 用法: just init darwin | just init wsl | just init vps-server | just init desktop-linux
[group('build')]
init hostname:
  #!/usr/bin/env bash
  echo "正在进行首次系统初始化..."
  if [[ "{{hostname}}" == "darwin" ]]; then
    nix build .#darwinConfigurations.darwin.system \
      --extra-experimental-features 'nix-command flakes' \
      --impure
    sudo ./result/sw/bin/darwin-rebuild switch --flake .#darwin \
      --extra-experimental-features 'nix-command flakes'
  else
    sudo nixos-rebuild switch --flake .#{{hostname}} \
      --experimental-features 'nix-command flakes' \
      --impure
  fi
  echo "首次初始化完成！后续可以使用 'just rebuild {{hostname}}' 命令"

# 构建并切换到新的系统配置
# 用法: just rebuild darwin | just rebuild wsl | just rebuild vps-server | just rebuild desktop-linux
[group('build')]
rebuild hostname:
  #!/usr/bin/env bash
  if [[ "{{hostname}}" == "darwin" ]]; then
    nix build .#darwinConfigurations.darwin.system \
      --extra-experimental-features 'nix-command flakes'
    sudo ./result/sw/bin/darwin-rebuild switch --flake .#darwin
  else
    sudo nixos-rebuild switch --flake .#{{hostname}} --impure
  fi

# 调试模式构建系统配置（显示详细信息和错误追踪）
# 用法: just rebuild-debug darwin | just rebuild-debug wsl | just rebuild-debug desktop-linux
[group('build')]
rebuild-debug hostname:
  #!/usr/bin/env bash
  if [[ "{{hostname}}" == "darwin" ]]; then
    nix build .#darwinConfigurations.darwin.system --show-trace --verbose \
      --extra-experimental-features 'nix-command flakes'
    sudo ./result/sw/bin/darwin-rebuild switch --flake .#darwin --show-trace --verbose
  else
    sudo nixos-rebuild switch --flake .#{{hostname}} --show-trace --verbose --impure
  fi

# 测试 NixOS 配置（不切换，仅限 Linux）
# 用法: just test wsl | just test vps-server | just test desktop-linux
[group('build')]
test hostname:
  sudo nixos-rebuild test --flake .#{{hostname}} --impure

# 构建 NixOS 配置（不切换，仅限 Linux）
# 用法: just build wsl | just build vps-server | just build desktop-linux
[group('build')]
build hostname:
  sudo nixos-rebuild build --flake .#{{hostname}} --impure

############################################################################
#
#  Nix 通用命令
#
############################################################################

# 更新所有 flake 输入源
[group('nix')]
up:
  nix flake update

# 更新指定的输入源
# 用法: just upp nixpkgs
[group('nix')]
upp input:
  nix flake update {{input}}

# 列出系统配置的所有历史版本
[group('nix')]
history:
  nix profile history --profile /nix/var/nix/profiles/system

# 打开 nix repl 交互式环境
[group('nix')]
repl:
  nix repl -f flake:nixpkgs

# 删除 7 天前的旧版本（macOS 需要 sudo）
[group('nix')]
clean:
  sudo nix profile wipe-history --profile /nix/var/nix/profiles/system --older-than 7d

# 垃圾回收：清理未使用的 nix store 条目
[group('nix')]
gc:
  # 清理系统级未使用的条目
  sudo nix-collect-garbage --delete-older-than 7d
  # 清理用户级未使用的条目（home-manager）
  nix-collect-garbage --delete-older-than 7d

# 格式化仓库中的所有 nix 文件
[group('nix')]
fmt:
  nix fmt

# 显示 nix store 中的所有自动 gc roots
[group('nix')]
gcroot:
  ls -al /nix/var/nix/gcroots/auto/
