-- 标签页样式：Catppuccin Mocha 半圆标签

return function(wezterm, config)
	local scheme = wezterm.color.get_builtin_schemes()['Catppuccin Mocha']
	local theme_bg = scheme.background

	local GLYPH_SEMI_CIRCLE_LEFT = ""
	local GLYPH_SEMI_CIRCLE_RIGHT = ""

	local colors = {
		default   = { bg = "#45475a", fg = "#cdd6f4" },
		is_active = { bg = "#45475a", fg = "#f5e0dc" },
		hover     = { bg = "#f5e0dc", fg = "#1e1e2e" },
	}

	local function push(cells, bg, fg, attribute, text)
		table.insert(cells, { Background = { Color = bg } })
		table.insert(cells, { Foreground = { Color = fg } })
		table.insert(cells, { Attribute = attribute })
		table.insert(cells, { Text = text })
	end

	wezterm.on("format-tab-title", function(tab, tabs, panes, _config, hover, max_width)
		local cells = {}

		local bg, fg
		if tab.is_active then
			bg, fg = colors.is_active.bg, colors.is_active.fg
		elseif hover then
			bg, fg = colors.hover.bg, colors.hover.fg
		else
			bg, fg = colors.default.bg, colors.default.fg
		end

		local title = tab.active_pane.title or "shell"
		local title_width = math.max(max_width - 4, 0)
		if title_width == 0 then
			title = ""
		elseif #title > title_width then
			title = wezterm.truncate_right(title, title_width)
		end

		local padding = " "

		push(cells, theme_bg, bg, { Intensity = "Bold" }, padding .. GLYPH_SEMI_CIRCLE_LEFT)
		push(cells, bg, fg, { Intensity = "Bold" }, padding .. title .. padding)
		push(cells, theme_bg, bg, { Intensity = "Bold" }, GLYPH_SEMI_CIRCLE_RIGHT .. padding)

		return cells
	end)
end
