# macOS Dev Setup

WezTerm + Neovim + Yazi + zsh 的完整终端开发环境配置，一键迁移到新机器。

## 特性

- **WezTerm**：Catppuccin Mocha 主题、JetBrains Mono 字体、状态栏显示 Git 分支和时钟
- **Neovim**：HUAHUANVIM `Six` 分支（LSP / cmp / treesitter / nvim-tree / aerial）
- **Yazi**：Git 状态图标、回车 nvim 打开、`y` 函数退出时自动 cd
- **zsh**：Starship 提示符、`eza` 替代 `ls`、代理控制函数
- **图片剪贴板粘贴**：`Cmd+V` 自动保存为 PNG 到 `~/tmp/` 并粘贴路径

## 快速开始

```bash
# 1. clone
git clone <your-repo-url> ~/dev/mac-dev-setup
cd ~/dev/mac-dev-setup

# 2. 装依赖（homebrew）
./scripts/install.sh

# 3. 部署配置（创建符号链接，不需要 sudo）
./scripts/deploy.sh

# 4. 重新打开 WezTerm
```

详细步骤见 [docs/INSTALL.md](docs/INSTALL.md)。

## 文档

- [INSTALL.md](docs/INSTALL.md) — 分步迁移指南
- [CHEATSHEET.md](docs/CHEATSHEET.md) — 所有快捷键速查
- [TROUBLESHOOTING.md](docs/TROUBLESHOOTING.md) — 常见问题

## 目录结构

```
mac-dev-setup/
├── README.md
├── docs/                   # 指南和速查
├── wezterm/                # → ~/.config/wezterm/
├── nvim/                   # → ~/.config/nvim/
├── yazi/                   # → ~/.config/yazi/
├── zsh/zshrc               # → ~/.zshrc
└── scripts/
    ├── install.sh          # brew 一键装依赖
    └── deploy.sh           # 创建符号链接
```

## 对应的 Windows 版本

见 `../win-dev-setup/`。配置文件几乎相同，只是安装脚本和 shell profile 改成 winget+PowerShell。
