-- WezTerm appearance：字体、主题、默认 shell、初始目录
-- 在 Windows 和 macOS 之间自动切换。

return function(wezterm, config)
	-- 默认长宽
	config.initial_cols = 120
	config.initial_rows = 28

	config.window_decorations = "RESIZE"
	config.use_fancy_tab_bar = false
	config.tab_max_width = 25
	config.hide_tab_bar_if_only_one_tab = false

	config.font_size = 12
	config.color_scheme = 'Catppuccin Mocha'
	config.font = wezterm.font('JetBrains Mono', { weight = 'Bold', italic = true })

	-- 平台自适应：启动 shell 和初始目录
	local triple = wezterm.target_triple
	if triple:find('windows') then
		-- Windows: 优先 PowerShell 7-preview，不在则回退 PowerShell 7
		local pwsh_preview = 'C:\\Program Files\\PowerShell\\7-preview\\pwsh.exe'
		local pwsh_stable  = 'C:\\Program Files\\PowerShell\\7\\pwsh.exe'
		local ok = wezterm.run_child_process({ 'cmd', '/c', 'if exist "' .. pwsh_preview .. '" (exit 0) else (exit 1)' })
		config.default_prog = { ok and pwsh_preview or pwsh_stable, '-NoLogo' }
		config.default_cwd  = 'E:\\aplan'
	else
		-- macOS / Linux: 用登录 shell（会加载 .zshrc / .bashrc）
		config.default_prog = { '/bin/zsh', '-l' }
		config.default_cwd  = wezterm.home_dir
	end

	config.window_padding = {
		top = 0,
	}
end
