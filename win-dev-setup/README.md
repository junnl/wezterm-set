# Windows Dev Setup

WezTerm + Neovim + Yazi + PowerShell 7 的完整终端开发环境配置，一键迁移到新机器。

## 特性

- **WezTerm**：Catppuccin Mocha 主题、JetBrains Mono 字体、状态栏显示 Git 分支和时钟
- **Neovim**：HUAHUANVIM `Six` 分支（LSP / cmp / treesitter / nvim-tree / aerial）
- **Yazi**：Git 状态图标、回车 nvim 打开、`y` 函数退出时自动 cd
- **PowerShell 7**：Starship 提示符、`eza` 替代 `ls`、代理控制函数
- **图片剪贴板粘贴**：`Ctrl+V` 自动保存为 PNG 到 `E:\temp\` 并粘贴路径

## 快速开始

```powershell
# 1. clone 本仓库
git clone <your-repo-url> E:\aplan\win-dev-setup
cd E:\aplan\win-dev-setup

# 2. 装依赖（winget）
.\scripts\install.ps1

# 3. 以【管理员】身份重开一个 pwsh，部署配置（创建符号链接）
.\scripts\deploy.ps1

# 4. 关闭所有 WezTerm 窗口后重新打开
```

详细步骤见 [docs/INSTALL.md](docs/INSTALL.md)。

## 文档

- [INSTALL.md](docs/INSTALL.md) — 分步迁移指南
- [CHEATSHEET.md](docs/CHEATSHEET.md) — 所有快捷键速查
- [TROUBLESHOOTING.md](docs/TROUBLESHOOTING.md) — 常见问题

## 目录结构

```
win-dev-setup/
├── README.md
├── docs/                   # 指南和速查
├── wezterm/                # → ~\.config\wezterm\
├── nvim/                   # → ~\AppData\Local\nvim\
├── yazi/                   # → ~\AppData\Roaming\yazi\config\
├── powershell/profile.ps1  # → ~\Documents\PowerShell\profile.ps1
└── scripts/
    ├── install.ps1         # winget 一键装依赖
    └── deploy.ps1          # 创建符号链接
```

## 对应的 macOS 版本

见 `../mac-dev-setup/`，配置文件几乎完全相同，只是安装脚本和 shell profile 改成 brew+zsh。
