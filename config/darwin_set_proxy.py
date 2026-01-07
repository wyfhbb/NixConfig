"""
  为 nix-daemon 设置代理以加速下载
  可以放心地忽略此文件，如果不需要代理。

  https://github.com/NixOS/nix/issues/1472#issuecomment-1532955973
"""
import os
import plistlib
import shlex
import subprocess
from pathlib import Path


NIX_DAEMON_PLIST = Path("/Library/LaunchDaemons/org.nixos.nix-daemon.plist")
NIX_DAEMON_NAME = "org.nixos.nix-daemon"
# 由 clash 或其他代理工具提供的 http 代理
HTTP_PROXY = "http://127.0.0.1:7890"       

pl = plistlib.loads(NIX_DAEMON_PLIST.read_bytes())

# 设置 http/https 代理
# 注意: curl 只接受小写的 `http_proxy`!
# 注意: https://curl.se/libcurl/c/libcurl-env.html
pl["EnvironmentVariables"]["http_proxy"] = HTTP_PROXY
pl["EnvironmentVariables"]["https_proxy"] = HTTP_PROXY

# 移除 http 代理
# pl["EnvironmentVariables"].pop("http_proxy", None)
# pl["EnvironmentVariables"].pop("https_proxy", None)

os.chmod(NIX_DAEMON_PLIST, 0o644)
NIX_DAEMON_PLIST.write_bytes(plistlib.dumps(pl))
os.chmod(NIX_DAEMON_PLIST, 0o444)

# 重新加载 plist
for cmd in (
	f"launchctl unload {NIX_DAEMON_PLIST}",
	f"launchctl load {NIX_DAEMON_PLIST}",
):
    print(cmd)
    subprocess.run(shlex.split(cmd), capture_output=False)

