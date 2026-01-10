# Conda 自动初始化（如果存在）
if [ -d "$HOME/miniforge3" ]; then
  __conda_setup="$("$HOME/miniforge3/bin/conda" 'shell.zsh' 'hook' 2> /dev/null)"
  if [ $? -eq 0 ]; then
    eval "$__conda_setup"
  else
    if [ -f "$HOME/miniforge3/etc/profile.d/conda.sh" ]; then
      . "$HOME/miniforge3/etc/profile.d/conda.sh"
    else
      export PATH="$HOME/miniforge3/bin:$PATH"
    fi
  fi
  unset __conda_setup
  
  # 禁用自动激活（仅首次）
  grep -q "auto_activate: false" "$HOME/.condarc" 2>/dev/null || \
    conda config --set auto_activate false 2>/dev/null
fi