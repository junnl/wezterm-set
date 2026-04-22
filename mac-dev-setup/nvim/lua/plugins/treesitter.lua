require('nvim-treesitter').setup {
  -- 自动装这些语言的 parser
  ensure_installed = {
    "vim", "vimdoc", "bash", "c", "cpp", "javascript", "json", "lua",
    "python", "typescript", "tsx", "css", "rust", "markdown", "markdown_inline",
    "toml", "yaml", "html", "go", "regex", "query",
  },

  -- 首次打开文件若缺 parser，自动下载
  auto_install = true,
  sync_install = false,

  highlight = { enable = true },
  indent    = { enable = true },
}
