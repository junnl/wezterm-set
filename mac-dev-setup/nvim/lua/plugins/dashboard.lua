local logo = [[
███╗   ███╗██╗   ██╗███╗   ██╗██╗   ██╗██╗███╗   ███╗
████╗ ████║╚██╗ ██╔╝████╗  ██║██║   ██║██║████╗ ████║
██╔████╔██║ ╚████╔╝ ██╔██╗ ██║██║   ██║██║██╔████╔██║
██║╚██╔╝██║  ╚██╔╝  ██║╚██╗██║╚██╗ ██╔╝██║██║╚██╔╝██║
██║ ╚═╝ ██║   ██║   ██║ ╚████║ ╚████╔╝ ██║██║ ╚═╝ ██║
╚═╝     ╚═╝   ╚═╝   ╚═╝  ╚═══╝  ╚═══╝  ╚═╝╚═╝     ╚═╝
]]

require('dashboard').setup {
  theme = 'hyper',
  config = {
    header = vim.split(logo, "\n"),
    shortcut = {
      { desc = '󰊳 Update', group = '@property', action = 'Lazy update', key = 'u' },
      {
        icon = ' ',
        icon_hl = '@variable',
        desc = 'Files',
        group = 'Label',
        action = 'Telescope find_files',
        key = 'f',
      },
      {
        desc = ' Apps',
        group = 'DiagnosticHint',
        action = 'Telescope app',
        key = 'a',
      },
    },
    packages = { enable = true },
    project = {
      enable = true,
      limit = 8, 
      icon = '📂 ',
      label = 'Projects',
      action = function(path) 
        vim.cmd('Telescope find_files cwd=' .. path)
      end,
		},
	}
}
