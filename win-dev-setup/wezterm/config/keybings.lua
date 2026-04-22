-- WezTerm 键位与鼠标
-- Ctrl+C: 有选中则复制，否则透传中断
-- Ctrl+V: 剪贴板有图片则保存 PNG 并粘贴路径，否则粘贴文本
-- 自动检测平台选择图片保存路径和保存方式

return function(wezterm, config)
	local is_windows = wezterm.target_triple:find('windows') ~= nil

	-- 图片保存路径（按平台）
	local img_dir = is_windows and 'E:\\temp' or (os.getenv('HOME') .. '/tmp')

	-- 把剪贴板图片保存为 PNG，返回路径字符串；失败返回 nil
	local function save_clipboard_image()
		if is_windows then
			local ps_script = string.format([[
$ErrorActionPreference = 'Stop'
Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing
$img = [System.Windows.Forms.Clipboard]::GetImage()
if ($img) {
  $dir = '%s'
  if (-not (Test-Path $dir)) { New-Item -ItemType Directory -Path $dir | Out-Null }
  $path = Join-Path $dir ('img-' + (Get-Date -Format 'yyyyMMdd-HHmmss-fff') + '.png')
  $img.Save($path, [System.Drawing.Imaging.ImageFormat]::Png)
  Write-Output $path
}
]], img_dir)
			local ok, stdout, _ = wezterm.run_child_process({
				'powershell', '-NoProfile', '-NonInteractive', '-Command', ps_script,
			})
			if ok and stdout and stdout:match('%S') then
				return (stdout:gsub('[%s\r\n]+$', ''))
			end
		else
			-- macOS：用 pngpaste (brew install pngpaste)
			local ts = os.date('%Y%m%d-%H%M%S')
			local path = img_dir .. '/img-' .. ts .. '.png'
			os.execute('mkdir -p "' .. img_dir .. '"')
			local ok = wezterm.run_child_process({ 'pngpaste', path })
			if ok then
				-- 确认文件存在且非空
				local f = io.open(path, 'rb')
				if f then
					local sz = f:seek('end') or 0
					f:close()
					if sz > 0 then return path end
				end
			end
		end
		return nil
	end

	config.keys = {
		{ key = 'Enter',      mods = 'CTRL',  action = wezterm.action.ToggleFullScreen },
		{ key = 'Enter',      mods = 'ALT',   action = wezterm.action.DisableDefaultAssignment },
		{ key = 't',          mods = 'ALT',   action = wezterm.action.SpawnTab("DefaultDomain") },
		{ key = 'm',          mods = 'ALT',   action = wezterm.action.ShowTabNavigator },
		{ key = 'w',          mods = 'ALT',   action = wezterm.action.CloseCurrentPane { confirm = true } },
		{ key = 'n',          mods = 'ALT',   action = wezterm.action.SpawnWindow },

		-- Ctrl+C: 有选中即复制并清空选区，否则透传 Ctrl+C
		{ key = 'c', mods = 'CTRL', action = wezterm.action_callback(function(window, pane)
			local sel = window:get_selection_text_for_pane(pane)
			if sel and sel ~= '' then
				window:perform_action(wezterm.action.CopyTo 'ClipboardAndPrimarySelection', pane)
				window:perform_action(wezterm.action.ClearSelection, pane)
			else
				window:perform_action(wezterm.action.SendKey { key = 'c', mods = 'CTRL' }, pane)
			end
		end) },

		-- Ctrl+V: 剪贴板有图则保存 PNG 并粘贴路径，否则粘贴文本
		{ key = 'v', mods = 'CTRL', action = wezterm.action_callback(function(window, pane)
			local path = save_clipboard_image()
			if path then
				pane:paste(path)
			else
				window:perform_action(wezterm.action.PasteFrom 'Clipboard', pane)
			end
		end) },

		{ key = 'f', mods = 'CTRL|SHIFT', action = wezterm.action.Search 'CurrentSelectionOrEmptyString' },
		{ key = 'p', mods = 'CTRL|SHIFT', action = wezterm.action.ActivateCommandPalette },

		-- 分屏
		{ key = 'd', mods = 'ALT',   action = wezterm.action.SplitHorizontal { domain = "CurrentPaneDomain" } },
		{ key = 'D', mods = 'ALT',   action = wezterm.action.SplitVertical   { domain = "CurrentPaneDomain" } },
		{ key = 'h', mods = 'ALT',   action = wezterm.action.ActivatePaneDirection("Left")  },
		{ key = 'j', mods = 'ALT',   action = wezterm.action.ActivatePaneDirection("Down")  },
		{ key = 'k', mods = 'ALT',   action = wezterm.action.ActivatePaneDirection("Up")    },
		{ key = 'l', mods = 'ALT',   action = wezterm.action.ActivatePaneDirection("Right") },
		{ key = 'LeftArrow',  mods = 'ALT', action = wezterm.action.AdjustPaneSize { "Left",  5 } },
		{ key = 'DownArrow',  mods = 'ALT', action = wezterm.action.AdjustPaneSize { "Down",  5 } },
		{ key = 'UpArrow',    mods = 'ALT', action = wezterm.action.AdjustPaneSize { "Up",    5 } },
		{ key = 'RightArrow', mods = 'ALT', action = wezterm.action.AdjustPaneSize { "Right", 5 } },

		-- 标签
		{ key = 'L', mods = 'ALT', action = wezterm.action.ActivateTabRelative(1)  },
		{ key = 'H', mods = 'ALT', action = wezterm.action.ActivateTabRelative(-1) },
	}

	-- 鼠标：左键拖动选中松开即复制；右键粘贴；Ctrl+左键打开链接
	config.mouse_bindings = {
		{
			event = { Up = { streak = 1, button = 'Left' } },
			mods = 'NONE',
			action = wezterm.action.CompleteSelection 'ClipboardAndPrimarySelection',
		},
		{
			event = { Down = { streak = 1, button = 'Right' } },
			mods = 'NONE',
			action = wezterm.action.PasteFrom 'Clipboard',
		},
		{
			event = { Up = { streak = 1, button = 'Left' } },
			mods = 'CTRL',
			action = wezterm.action.OpenLinkAtMouseCursor,
		},
	}
end
