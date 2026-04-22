# wezterm-set

跨平台终端开发环境配置集合 — **WezTerm + Neovim + Yazi** 为核心，一套配置在 Windows / macOS 都能用。

| 平台 | 子项目 | Shell | 包管理 |
|---|---|---|---|
| Windows | [`win-dev-setup/`](win-dev-setup/) | PowerShell 7 | winget |
| macOS   | [`mac-dev-setup/`](mac-dev-setup/) | zsh          | Homebrew |

## 共同特性

- **WezTerm** 终端（nightly） — Catppuccin Mocha 主题，状态栏显示 Git 分支和时钟。用 nightly 是因为稳定版更新太慢。
- **HUAHUANVIM** Neovim 配置 — LSP / treesitter / cmp / nvim-tree / aerial
- **Yazi** 文件浏览器 — Git 状态图标，回车 nvim 打开，`y` 函数退出时自动 cd
- **Starship** 提示符 — 显示 Git 分支、Node / Python / Rust 版本等
- **图片剪贴板粘贴** — Ctrl+V 自动存 PNG 到 `E:\temp` / `~/tmp` 并粘贴路径
- **现代 CLI 工具** — `eza` / `fd` / `rg` / `fzf`

## 目录结构

```
wezterm-set/
├── README.md                # 本文件
├── win-dev-setup/           # Windows 版
│   ├── README.md
│   ├── docs/                # 安装/快捷键/排错
│   ├── wezterm/             # → ~\.config\wezterm\
│   ├── nvim/                # → ~\AppData\Local\nvim\
│   ├── yazi/                # → ~\AppData\Roaming\yazi\config\
│   ├── powershell/          # → ~\Documents\PowerShell\profile.ps1
│   └── scripts/             # install.ps1 / deploy.ps1
└── mac-dev-setup/           # macOS 版
    ├── README.md
    ├── docs/
    ├── wezterm/             # → ~/.config/wezterm/
    ├── nvim/                # → ~/.config/nvim/
    ├── yazi/                # → ~/.config/yazi/
    ├── zsh/                 # → ~/.zshrc
    └── scripts/             # install.sh / deploy.sh
```

**两边的 `wezterm/` 和 `nvim/` 和 `yazi/` 配置文件几乎一样** — WezTerm 用 `wezterm.target_triple` 运行时判断平台，一份 lua 双端通用。差异只在安装脚本和 shell profile。

## 用法

到对应子目录按 README 操作：

- Windows: [win-dev-setup/README.md](win-dev-setup/README.md)
- macOS: [mac-dev-setup/README.md](mac-dev-setup/README.md)

两边都是三步：`install` → `deploy` → 重开终端。

## 许可

MIT（配置文件是个人整理，其中引用的 HUAHUANVIM / yazi-rs 插件各自保留原作者权利）。
