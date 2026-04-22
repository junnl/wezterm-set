#!/usr/bin/env bash
# mac-dev-setup / scripts / deploy.sh
# 把仓库里的配置软链接到系统路径。
# 使用: ./scripts/deploy.sh          创建链接
#       ./scripts/deploy.sh --unlink  删除链接

set -e

UNLINK=0
FORCE=0
for arg in "$@"; do
  case "$arg" in
    --unlink) UNLINK=1 ;;
    --force)  FORCE=1  ;;
  esac
done

# 仓库根（scripts 的父目录）
REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
echo "仓库根: $REPO_ROOT"

link() {
  local src="$1"
  local dst="$2"
  local dst_parent
  dst_parent="$(dirname "$dst")"

  if [[ $UNLINK -eq 1 ]]; then
    if [[ -L "$dst" ]]; then
      rm "$dst"
      echo "  删除软链接: $dst"
    fi
    return
  fi

  mkdir -p "$dst_parent"

  if [[ -e "$dst" || -L "$dst" ]]; then
    if [[ -L "$dst" && "$(readlink "$dst")" == "$src" ]]; then
      echo "  已存在相同软链接: $dst"
      return
    fi
    if [[ $FORCE -eq 1 ]]; then
      rm -rf "$dst"
    else
      local backup="$dst.bak.$(date +%Y%m%d-%H%M%S)"
      mv "$dst" "$backup"
      echo "  已备份旧配置到: $backup"
    fi
  fi

  ln -s "$src" "$dst"
  echo "  已链接: $dst -> $src"
}

echo ""
echo "=== 创建软链接 ==="
link "$REPO_ROOT/wezterm"      "$HOME/.config/wezterm"
link "$REPO_ROOT/nvim"         "$HOME/.config/nvim"
link "$REPO_ROOT/yazi"         "$HOME/.config/yazi"
link "$REPO_ROOT/zsh/zshrc"    "$HOME/.zshrc"

if [[ $UNLINK -eq 1 ]]; then
  echo ""
  echo "软链接已清理"
  exit 0
fi

echo ""
echo "=== 同步 Yazi 插件 ==="
if command -v ya >/dev/null 2>&1; then
  ya pkg upgrade
else
  echo "  警告: ya 不在 PATH，请手动运行 'ya pkg upgrade'"
fi

echo ""
echo "=== 部署完成 ==="
echo "下一步:"
echo "  1. 退出 WezTerm 重新打开"
echo "  2. 首次打开 nvim 会自动装插件（几分钟）"
echo "  3. nvim 里执行 :TSUpdate 装 treesitter parser"
