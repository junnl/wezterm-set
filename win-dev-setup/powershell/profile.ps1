# PowerShell 7 Profile
# 位置: ~\Documents\PowerShell\profile.ps1
# 重新加载: . $PROFILE.CurrentUserAllHosts  或直接重开 pwsh

# --- UTF-8 编码（避免中文乱码） -------------------------------------------
$OutputEncoding = [System.Text.Encoding]::UTF8
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
[Console]::InputEncoding  = [System.Text.Encoding]::UTF8

# --- 把 winget 装的工具目录塞进 PATH（如果还没在里面） -------------------
$wingetPkgs = "$env:LOCALAPPDATA\Microsoft\WinGet\Packages"
$toolDirs = @(
  # 用 Get-ChildItem 匹配带版本号的子目录，避免版本一升级路径就失效
  (Get-ChildItem "$wingetPkgs\junegunn.fzf_*" -Directory -ErrorAction SilentlyContinue | Select-Object -ExpandProperty FullName -First 1),
  (Get-ChildItem "$wingetPkgs\BurntSushi.ripgrep.MSVC_*\ripgrep-*" -Directory -ErrorAction SilentlyContinue | Select-Object -ExpandProperty FullName -First 1),
  (Get-ChildItem "$wingetPkgs\eza-community.eza_*" -Directory -ErrorAction SilentlyContinue | Select-Object -ExpandProperty FullName -First 1),
  (Get-ChildItem "$wingetPkgs\sharkdp.fd_*\fd-*" -Directory -ErrorAction SilentlyContinue | Select-Object -ExpandProperty FullName -First 1),
  (Get-ChildItem "$wingetPkgs\sxyazi.yazi_*\yazi-*" -Directory -ErrorAction SilentlyContinue | Select-Object -ExpandProperty FullName -First 1),
  "C:\Program Files\starship\bin"
) | Where-Object { $_ -and (Test-Path $_) }

foreach ($d in $toolDirs) {
  if ($env:PATH -notlike "*$d*") { $env:PATH = "$d;$env:PATH" }
}

# --- 别名：现代 CLI 工具 -------------------------------------------------
if (Get-Command eza -ErrorAction SilentlyContinue) {
  function ls  { eza --icons --group-directories-first @args }
  function ll  { eza -l  --icons --group-directories-first --git @args }
  function la  { eza -la --icons --group-directories-first --git @args }
  function lt  { eza --tree --icons --level=2 @args }
}

# 常用缩写
function .. { Set-Location .. }
function ... { Set-Location ..\.. }
function gs  { git status @args }
function gd  { git diff @args }
function gl  { git log --oneline --graph --decorate -20 @args }

# --- yazi 集成：y 函数退出后自动 cd 到光标所在目录 -----------------------
function y {
  $tmp = [System.IO.Path]::GetTempFileName()
  yazi @args --cwd-file="$tmp"
  $cwd = Get-Content -Path $tmp -Encoding UTF8
  if (-not [String]::IsNullOrEmpty($cwd) -and ($cwd -ne $PWD.Path)) {
    Set-Location -LiteralPath ([System.IO.Path]::GetFullPath($cwd))
  }
  Remove-Item -Path $tmp -ErrorAction SilentlyContinue
}

# --- 编辑器环境变量 ------------------------------------------------------
$env:EDITOR = "nvim"
$env:VISUAL = "nvim"

# yazi 需要 file.exe（Git for Windows 自带）
$fileExe = "D:\Program Files\Git\usr\bin\file.exe"
if (-not (Test-Path $fileExe)) { $fileExe = "C:\Program Files\Git\usr\bin\file.exe" }
if (Test-Path $fileExe) { $env:YAZI_FILE_ONE = $fileExe }

# --- 代理（Clash Verge / v2ray 等） --------------------------------------
# 按需修改端口；默认开启
$script:PROXY_HTTP  = "http://127.0.0.1:21882"
$script:PROXY_SOCKS = "socks5://127.0.0.1:21881"

function Enable-Proxy {
  param([switch]$Quiet)
  $env:HTTP_PROXY  = $script:PROXY_HTTP
  $env:HTTPS_PROXY = $script:PROXY_HTTP
  $env:ALL_PROXY   = $script:PROXY_SOCKS
  if (-not $Quiet) { Write-Host "proxy on  ($($script:PROXY_HTTP))" -ForegroundColor Green }
}
function Disable-Proxy {
  param([switch]$Quiet)
  Remove-Item Env:HTTP_PROXY, Env:HTTPS_PROXY, Env:ALL_PROXY -ErrorAction SilentlyContinue
  if (-not $Quiet) { Write-Host "proxy off" -ForegroundColor Yellow }
}
Enable-Proxy -Quiet | Out-Null

# --- Starship 提示符（显示 Git 分支、语言版本等） ------------------------
if (Get-Command starship -ErrorAction SilentlyContinue) {
  Invoke-Expression (&starship init powershell)
}
