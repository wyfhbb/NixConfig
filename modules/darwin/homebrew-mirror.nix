{ lib, ... }:
let
  # Homebrew 镜像
  homebrew_mirror_env = {
    HOMEBREW_API_DOMAIN = "https://mirrors.tuna.tsinghua.edu.cn/homebrew-bottles/api";
    HOMEBREW_BOTTLE_DOMAIN = "https://mirrors.tuna.tsinghua.edu.cn/homebrew-bottles";
    HOMEBREW_BREW_GIT_REMOTE = "https://mirrors.tuna.tsinghua.edu.cn/git/homebrew/brew.git";
    HOMEBREW_CORE_GIT_REMOTE = "https://mirrors.tuna.tsinghua.edu.cn/git/homebrew/homebrew-core.git";
    HOMEBREW_PIP_INDEX_URL = "https://pypi.tuna.tsinghua.edu.cn/simple";
  };
in
{
  # 为你手动安装 Homebrew 包设置环境变量。
  environment.variables = homebrew_mirror_env;

  # 在运行 `brew bundle` 之前为 nix-darwin 设置环境变量。
  system.activationScripts.homebrew.text =
    let
      env_script = lib.attrsets.foldlAttrs (
        acc: name: value:
        acc + "\nexport ${name}=${value}"
      ) "" homebrew_mirror_env;
    in
    lib.mkBefore ''
      echo >&2 '${env_script}'
      ${env_script}
    '';
}
