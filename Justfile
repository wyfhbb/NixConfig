# just 是一个命令运行器，类似 Makefile 但更简单

hostname := "wyf-macbook"

# 列出所有可用的命令
default:
  @just --list

############################################################################
#
#  macOS 相关命令
#
############################################################################

# 构建并切换到新的 macOS 配置
[group('macOS')]
darwin:
  nix build .#darwinConfigurations.{{hostname}}.system \
    --extra-experimental-features 'nix-command flakes'

  sudo ./result/sw/bin/darwin-rebuild switch --flake .#{{hostname}}

# 调试模式构建 macOS 配置（显示详细信息和错误追踪）
[group('macOS')]
darwin-debug:
  nix build .#darwinConfigurations.{{hostname}}.system --show-trace --verbose \
    --extra-experimental-features 'nix-command flakes'

  sudo ./result/sw/bin/darwin-rebuild switch --flake .#{{hostname}} --show-trace --verbose

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
