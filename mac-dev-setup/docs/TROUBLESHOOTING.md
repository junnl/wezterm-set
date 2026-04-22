# 常见问题排查（macOS）

## WezTerm

### 字体是方块

```bash
brew tap homebrew/cask-fonts
brew install --cask font-jetbrains-mono
```

### 状态栏不显示 Git 分支

cwd 不是 Git 仓库就不显示，正常现象。

### Cmd+V 粘贴不出图片

`pngpaste` 没装：`brew install pngpaste`

## Yazi

### 右侧没有预览

```bash
yazi --version
yazi --debug | less
```

关键行看 `Adapter.matches` 和 `Dimension`。没尺寸就升级 WezTerm。

### 文件旁没有 Git 状态

```bash
ya pkg upgrade
```

重启 yazi。

## Neovim

### 插件装不上

```bash
proxy_on
nvim
```

nvim 里：`:Lazy sync` → `:TSUpdate` → `:qa`。

## zsh

### `source ~/.zshrc` 报错

看具体哪一行 → 逐段注释排查。常见是 `brew` 没在 PATH。手动：

```bash
eval "$(/opt/homebrew/bin/brew shellenv)"    # Apple Silicon
eval "$(/usr/local/bin/brew shellenv)"        # Intel
```

### 工具命令找不到

brew 装的东西在 `/opt/homebrew/bin`（M 系列）或 `/usr/local/bin`（Intel）。shellenv 没执行就不在 PATH。

## 代理

### `curl -x http://127.0.0.1:7890 https://github.com` 超时

1. Clash / v2ray 没开
2. 端口不对，改 `~/.zshrc` 里的 `_PROXY_HTTP`
3. macOS 的"系统代理"开关要打开

### Git 超时

```bash
git config --global http.https://github.com.proxy http://127.0.0.1:7890
git config --global https.https://github.com.proxy http://127.0.0.1:7890
```

## 重置

```bash
./scripts/deploy.sh --unlink
```

备份的 `*.bak.*` 在原位置。
