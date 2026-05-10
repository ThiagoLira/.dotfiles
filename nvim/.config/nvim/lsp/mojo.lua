-- Resolves mojo-lsp-server from the project's .venv (uv) or PATH.
return {
	cmd = function(dispatchers, config)
		local exe = "mojo-lsp-server"
		if config and config.root_dir then
			local venv = config.root_dir .. "/.venv/bin/mojo-lsp-server"
			if vim.uv.fs_stat(venv) then
				exe = venv
			end
		end
		return vim.lsp.rpc.start({ exe }, dispatchers)
	end,
	filetypes = { "mojo" },
	root_markers = { "pixi.toml", "pyproject.toml", ".git" },
}
