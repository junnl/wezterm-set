# Windows 迁移安装指南

## 前置要求

- Windows 10 build 1809 以上（要能用 `winget`）
- 能访问 GitHub（国内建议先配代理，详见最后一节）
- 管理员权限（创建软链接需要）

## 分步安装

### 1. 克隆本仓库

找一个长期目录，别放到项目临时目录：

```powershell
git clone https://github.com/junnl/wezterm-set.git E:\aplan\wezterm-set
cd E:\aplan\wezterm-set\win-dev-setup
```

### 2. 装依赖

```powershell
.\scripts\install.ps1
```

默认包括可选依赖（ImageMagick/chafa/zoxide/FFmpeg）。不想装可选的：

```powershell
.\scripts\install.ps1 -SkipOptional
```

装完后 **关闭这个 PowerShell 窗口**，让 PATH 生效。

### 3. 部署配置（需要管理员）

右键开始菜单 → "Windows Terminal (管理员)" 或 "PowerShell (管理员)"：

```powershell
cd E:\aplan\wezterm-set\win-dev-setup
.\scripts\deploy.ps1
```

脚本会做：

- 把 `wezterm/` 软链接到 `~\.config\wezterm\`
- 把 `nvim/` 软链接到 `~\AppData\Local\nvim\`
- 把 `yazi/` 软链接到 `~\AppData\Roaming\yazi\config\`
- 把 `powershell\profile.ps1` 软链接到 `~\Documents\PowerShell\profile.ps1`
- 如果目标已存在，自动备份成 `.bak.yyyyMMdd-HHmmss`
- 跑 `ya pkg upgrade` 同步 yazi 插件

### 4. 重启 WezTerm

关所有 WezTerm 窗口，再打开一个。这次应该看到：

- Catppuccin Mocha 主题
- JetBrains Mono 字体
- 右上状态栏显示 Git 分支（如果 cwd 是 git 仓库）
- Starship 提示符

### 5. 首次初始化 Neovim

```powershell
nvim
```

Lazy.nvim 会自动下载所有插件（3~5 分钟）。装完后执行：

```vim
:TSUpdate
```

等 treesitter parser 下完，再执行：

```vim
:qa
```

## 配置代理（国内访问 GitHub）

默认 profile 已经把代理端口设在了 `127.0.0.1:21882`（Clash Verge 默认混合端口）。**如果你用别的端口**，编辑 `powershell/profile.ps1` 顶部的两个变量：

```powershell
$script:PROXY_HTTP  = "http://127.0.0.1:你的HTTP端口"
$script:PROXY_SOCKS = "socks5://127.0.0.1:你的SOCKS端口"
```

还需要让 git 走代理（只针对 github.com）：

```powershell
git config --global http.https://github.com.proxy http://127.0.0.1:21882
git config --global https.https://github.com.proxy http://127.0.0.1:21882
```

查看当前配置：`git config --global --get-regexp "^http"`
撤销：`git config --global --unset http.https://github.com.proxy`

## 撤销（把配置删干净）

```powershell
.\scripts\deploy.ps1 -Unlink   # 仅删软链接
# 之前备份的 *.bak.* 还在原目录
```

## 常见报错

看 [TROUBLESHOOTING.md](TROUBLESHOOTING.md)。
