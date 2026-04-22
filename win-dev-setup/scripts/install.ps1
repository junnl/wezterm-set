# win-dev-setup / scripts / install.ps1
# 一键安装所有依赖。需要 Windows 10+ 且已登录 Microsoft Store（winget 前置）。
# 使用: 在项目根目录 PowerShell 里跑 `.\scripts\install.ps1`

param(
  [switch]$SkipOptional,   # 跳过可选依赖（ImageMagick/chafa/zoxide）
  [switch]$Force           # 已装的也重装（winget upgrade）
)

$ErrorActionPreference = 'Stop'

function Install-Winget {
  param([string]$Id, [string]$Name)
  Write-Host "→ $Name ($Id)" -ForegroundColor Cyan
  $installArgs = @('install', '--id', $Id, '--silent', '--accept-source-agreements', '--accept-package-agreements')
  if ($Force) { $installArgs += '--force' }
  winget @installArgs 2>&1 | Tee-Object -Variable out | Out-Null
  if ($LASTEXITCODE -ne 0 -and ($out -notmatch 'already installed')) {
    Write-Warning "  $Id 安装失败 (exit $LASTEXITCODE)"
  }
}

Write-Host "=== 必装依赖 ===" -ForegroundColor Green
$required = @(
  @{ Id = 'wez.wezterm.nightly';          Name = 'WezTerm (nightly)' },
  @{ Id = 'Microsoft.PowerShell.Preview';  Name = 'PowerShell 7 Preview' },
  @{ Id = 'Neovim.Neovim';                 Name = 'Neovim' },
  @{ Id = 'sxyazi.yazi';                   Name = 'Yazi' },
  @{ Id = 'Starship.Starship';             Name = 'Starship' },
  @{ Id = 'junegunn.fzf';                  Name = 'fzf' },
  @{ Id = 'BurntSushi.ripgrep.MSVC';       Name = 'ripgrep' },
  @{ Id = 'eza-community.eza';             Name = 'eza' },
  @{ Id = 'sharkdp.fd';                    Name = 'fd' },
  @{ Id = 'Git.Git';                       Name = 'Git for Windows' },
  @{ Id = 'JetBrains.JetBrainsMono';       Name = 'JetBrains Mono 字体' }
)
foreach ($p in $required) { Install-Winget -Id $p.Id -Name $p.Name }

if (-not $SkipOptional) {
  Write-Host "`n=== 可选依赖 ===" -ForegroundColor Green
  $optional = @(
    @{ Id = 'ImageMagick.ImageMagick';  Name = 'ImageMagick（yazi 图片预览）' },
    @{ Id = 'hpjansson.chafa';          Name = 'chafa（图片预览后备）' },
    @{ Id = 'ajeetdsouza.zoxide';       Name = 'zoxide（z 目录跳转）' },
    @{ Id = 'Gyan.FFmpeg';              Name = 'FFmpeg（视频缩略图）' }
  )
  foreach ($p in $optional) { Install-Winget -Id $p.Id -Name $p.Name }
}

Write-Host "`n=== 完成 ===" -ForegroundColor Green
Write-Host "下一步: 以【管理员】身份重开一个 PowerShell 窗口，然后运行" -ForegroundColor Yellow
Write-Host "       .\scripts\deploy.ps1" -ForegroundColor Yellow
