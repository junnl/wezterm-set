-- WezTerm 右侧状态栏：Git 分支 + 时钟
-- Git 查询结果缓存 10 秒，避免每次渲染都 fork 子进程

return function(wezterm, config)
	config.status_update_interval = 5000

	local git_cache = { path = nil, branch = nil, ts = 0 }

	local function cwd_to_path(cwd_url)
		if not cwd_url then return nil end
		return cwd_url.file_path or tostring(cwd_url):gsub('^file://[^/]*', '')
	end

	local function get_git_branch(path)
		if not path or path == '' then return nil end
		local now = os.time()
		if git_cache.path == path and (now - git_cache.ts) < 10 then
			return git_cache.branch
		end
		local ok, stdout = wezterm.run_child_process({
			'git', '-C', path, 'branch', '--show-current',
		})
		local branch = nil
		if ok and stdout then
			branch = stdout:gsub('[%s\r\n]+$', '')
			if branch == '' then branch = nil end
		end
		git_cache = { path = path, branch = branch, ts = now }
		return branch
	end

	wezterm.on('update-status', function(window, pane)
		local date = wezterm.strftime '%Y-%m-%d %H:%M'
		local branch = nil
		if window:is_focused() then
			branch = get_git_branch(cwd_to_path(pane:get_current_working_dir()))
		end

		local parts = {}
		if branch then table.insert(parts, ' ' .. branch) end
		table.insert(parts, date)

		window:set_right_status(wezterm.format({
			{ Attribute = { Italic = true } },
			{ Text = '  ' .. table.concat(parts, ' | ') .. '  ' },
		}))
	end)
end
