local null_ls = require('null-ls')

local opts = {
	debug = true,
	sources = {
		null_ls.builtins.formatting.isort,
		null_ls.builtins.formatting.black,
		null_ls.builtins.diagnostics.mypy.with({
			-- prefer_local = 'venv/bin/',
			command = "./venv/bin/mypy",
			extra_args = {
				"--strict",
				"--follow-imports=normal",
			},
			env = function (params)
				return { PYTHONPATH = params.root }
			end,
		}),
		null_ls.builtins.diagnostics.pylint.with({
			-- prefer_local = 'venv/bin/',
			command = "./venv/bin/pylint",
			extra_args = {
				"--rcfile=./.pylintrc",
			},
			-- env = function (params)
			-- 	return { PYTHONPATH = params.root }
			-- end,
		}),
	}
}
return opts
