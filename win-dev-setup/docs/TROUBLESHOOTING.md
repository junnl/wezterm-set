# 常见问题排查（Windows）

## WezTerm

### 状态栏不显示 Git 分支

- cwd 不是 Git 仓库 → 正常现象
- `git` 不在 PATH → 重开 PowerShell 让 `profile.ps1` 刷新 PATH

### 字体是方块

- 没装 JetBrains Mono → `winget install JetBrains.JetBrainsMono`
- 装了但仍乱码 → 在 `wezterm/config/appearance.lua` 里把字体改成 `"JetBrains Mono"`（去掉 Nerd Font 后缀）

### Ctrl+V 粘贴不出图片

- PowerShell 脚本找不到剪贴板图 → 先截图（不是复制文件），再 `Ctrl+V`
- 目录 `E:\temp` 不存在 → 脚本会自动建，若报权限问题改成其他盘

## Yazi

### 右侧没有任何预览

先确认版本和配置：

```powershell
yazi --version
yazi --debug | more
```

关键诊断行：
- `Emulator.detect: kind: WezTerm` — 终端识别对了
- `Adapter.matches: Iip` — 用 iTerm2 图片协议
- `Dimension: width:0 height:0` — WezTerm 没报像素尺寸 → 升级 WezTerm

### 回车不是用 nvim 打开

`yazi --debug` 看 `Text Opener` 段落，确认 `default` 里是 `nvim` 而不是 `code`。如果是 `code`：
- 说明软链接没生效，重跑 `.\scripts\deploy.ps1 -Force`
- 退出 yazi 再进（yazi 只在启动时读一次配置）

### 文件边上没有 Git 状态图标

```powershell
ya pkg upgrade
```
然后重启 yazi。

## Neovim

### 首次启动报 `module 'xxx' not found`

插件还没装完 / 网络挂了。

1. 开启代理：`Enable-Proxy`
2. 进 nvim 跑 `:Lazy sync`，等所有插件绿色 ✓
3. `:TSUpdate`
4. `:qa`

### `rainbow-delimiters` 报 `attempt to index nil value (local 'parser')`

缺 treesitter parser。进 nvim 跑 `:TSUpdate`，或 `:TSInstall <语言>`。

### nvim-treesitter 模块找不到

仓库里已经把分支钉在 `master`（新主分支 API 变了）。如果你手动改过，确认 `nvim/lua/plugins/plugins-setup.lua` 的 treesitter 入口有 `branch = "master"`。

## PowerShell

### `. $PROFILE` 报 "not recognized"

用：

```powershell
. $PROFILE.CurrentUserAllHosts
```

或直接重开 pwsh。

### 工具命令找不到

```powershell
# 看 PATH
$env:PATH -split ';'
```

没有 winget 装的目录 → profile 的 `$toolDirs` 匹配失败（版本号变了）。手动把装的版本号粘进 profile，或 `Get-ChildItem "$env:LOCALAPPDATA\Microsoft\WinGet\Packages" | Select Name` 看名字。

## 代理

### `curl -x http://127.0.0.1:21882 https://github.com` 超时

1. 代理没开 → 打开 Clash Verge
2. 端口不对 → Clash Verge 设置里看 "混合端口"
3. 系统代理没打开 → Clash Verge 开关打开

### git push 依然 443 timeout

`git config --global --get-regexp "^http"` 看有没有 proxy 配置。没有就：

```powershell
git config --global http.https://github.com.proxy http://127.0.0.1:21882
git config --global https.https://github.com.proxy http://127.0.0.1:21882
```

## 重置

完全撤销：

```powershell
.\scripts\deploy.ps1 -Unlink
```

之前备份的 `*.bak.yyyyMMdd-HHmmss` 还在原目录，手动改回来即可。
