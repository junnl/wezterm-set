# win-dev-setup / scripts / deploy.ps1
# 把仓库里的配置软链接到系统路径。
# 需要【管理员】权限（Windows 软链接默认需要）。
#
# 使用:
#   1. 以管理员身份开 PowerShell
#   2. cd 到项目根目录
#   3. .\scripts\deploy.ps1
#   (想撤销就加 -Unlink 参数)

param(
  [switch]$Unlink,     # 删除已创建的软链接
  [switch]$Force       # 目标已存在也覆盖
)

$ErrorActionPreference = 'Stop'

# 检查管理员
$isAdmin = ([Security.Principal.WindowsPrincipal] `
  [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole(
    [Security.Principal.WindowsBuiltinRole]::Administrator)
if (-not $isAdmin) {
  Write-Error "请以管理员身份运行 PowerShell（创建软链接需要权限）"
  exit 1
}

# 仓库根（scripts 的父目录）
$repoRoot = Split-Path -Parent $PSScriptRoot
Write-Host "仓库根: $repoRoot" -ForegroundColor Cyan

$links = @(
  @{ Source = "$repoRoot\wezterm";         Target = "$env:USERPROFILE\.config\wezterm" },
  @{ Source = "$repoRoot\nvim";            Target = "$env:LOCALAPPDATA\nvim" },
  @{ Source = "$repoRoot\yazi";            Target = "$env:APPDATA\yazi\config" },
  @{ Source = "$repoRoot\powershell\profile.ps1"; Target = "$env:USERPROFILE\Documents\PowerShell\profile.ps1" }
)

foreach ($l in $links) {
  $src = $l.Source
  $dst = $l.Target
  $dstParent = Split-Path -Parent $dst

  if ($Unlink) {
    if (Test-Path $dst) {
      $item = Get-Item $dst -Force
      if ($item.LinkType) {
        Remove-Item $dst -Force
        Write-Host "删除软链接: $dst" -ForegroundColor Yellow
      } else {
        Write-Warning "不是软链接，跳过: $dst"
      }
    }
    continue
  }

  # 创建父目录
  if (-not (Test-Path $dstParent)) {
    New-Item -ItemType Directory -Path $dstParent -Force | Out-Null
  }

  # 目标已存在
  if (Test-Path $dst) {
    $item = Get-Item $dst -Force
    if ($item.LinkType -and $item.Target -eq $src) {
      Write-Host "已存在相同软链接: $dst" -ForegroundColor DarkGray
      continue
    }
    if (-not $Force) {
      $backup = "$dst.bak.$(Get-Date -Format 'yyyyMMdd-HHmmss')"
      Move-Item $dst $backup
      Write-Host "已备份旧配置到: $backup" -ForegroundColor Yellow
    } else {
      Remove-Item $dst -Recurse -Force
    }
  }

  # 创建软链接
  $isDir = (Test-Path $src -PathType Container)
  if ($isDir) {
    New-Item -ItemType SymbolicLink -Path $dst -Target $src | Out-Null
  } else {
    New-Item -ItemType SymbolicLink -Path $dst -Target $src | Out-Null
  }
  Write-Host "已链接: $dst -> $src" -ForegroundColor Green
}

if ($Unlink) {
  Write-Host "`n软链接已清理" -ForegroundColor Green
  exit 0
}

# 同步 yazi 插件
Write-Host "`n=== 同步 Yazi 插件 ===" -ForegroundColor Cyan
if (Get-Command ya -ErrorAction SilentlyContinue) {
  ya pkg upgrade
} else {
  Write-Warning "ya 不在 PATH 里，请手动运行 'ya pkg upgrade'"
}

Write-Host "`n=== 部署完成 ===" -ForegroundColor Green
Write-Host "下一步:" -ForegroundColor Yellow
Write-Host "  1. 关闭所有 WezTerm 窗口，重新打开"
Write-Host "  2. 首次打开 nvim 会自动装插件（可能要几分钟）"
Write-Host "  3. nvim 里执行 :TSUpdate 装 treesitter parser"
