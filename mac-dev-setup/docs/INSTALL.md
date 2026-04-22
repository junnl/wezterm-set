# macOS 迁移安装指南

## 前置要求

- macOS 11 (Big Sur) 以上
- 已登录 Apple ID（App Store / Homebrew 前置）
- 能访问 GitHub（需要代理的见最后一节）

## 分步安装

### 1. 克隆本仓库

```bash
git clone https://github.com/junnl/wezterm-set.git ~/dev/wezterm-set
cd ~/dev/wezterm-set/mac-dev-setup
```

### 2. 装依赖

```bash
chmod +x scripts/install.sh scripts/deploy.sh
./scripts/install.sh
```

脚本自动装：

- WezTerm、Neovim、Yazi
- fzf / ripgrep / eza / fd / starship
- pngpaste（Cmd+V 图片粘贴需要）
- jq / poppler / ffmpegthumbnailer / sevenzip（yazi 预览用）
- JetBrains Mono 字体

### 3. 部署配置

```bash
./scripts/deploy.sh
```

会创建这些软链接（macOS 的软链接不需要 sudo）：

- `~/.config/wezterm` → 本仓库 `wezterm/`
- `~/.config/nvim` → 本仓库 `nvim/`
- `~/.config/yazi` → 本仓库 `yazi/`
- `~/.zshrc` → 本仓库 `zsh/zshrc`

原有文件会备份成 `*.bak.yyyymmdd-HHMMSS`。

### 4. 重启 WezTerm

```bash
killall wezterm-gui 2>/dev/null
open -a WezTerm
```

### 5. 首次初始化 Neovim

```bash
nvim
```

等 lazy.nvim 装完插件，然后：

```vim
:TSUpdate
:qa
```

## 配置代理

默认 `zshrc` 里的代理端口是 `127.0.0.1:7890`（Clash 默认）。如果用别的端口，改 `zsh/zshrc` 里这两行：

```bash
export _PROXY_HTTP="http://127.0.0.1:你的端口"
export _PROXY_SOCKS="socks5://127.0.0.1:你的端口"
```

Git 代理（针对 github.com）：

```bash
git config --global http.https://github.com.proxy http://127.0.0.1:7890
git config --global https.https://github.com.proxy http://127.0.0.1:7890
```

默认会在开 shell 时自动开代理。手动切：

```bash
proxy_on
proxy_off
```

## 撤销

```bash
./scripts/deploy.sh --unlink
```

只删软链接。之前备份的 `*.bak.*` 还在原位置。

## 常见报错

看 [TROUBLESHOOTING.md](TROUBLESHOOTING.md)。
