local opts = { silent = true }

-- buffer commands
vim.keymap.set(
	'n',
	'<leader>b]',
	'<cmd>lua require("bufferline").cycle(1)<CR>',
	opts
)

vim.keymap.set(
	'n',
	'<leader>bn',
	'<cmd>lua require("bufferline").cycle(1)<CR>',
	opts
)

vim.keymap.set(
	'n',
	'<leader>bg',
	'<cmd>lua require("bufferline").pick_buffer()<CR>',
	opts
)

vim.keymap.set(
	'n',
	'<leader>b[',
	'<cmd>lua require("bufferline").cycle(-1)<CR>',
	opts
)

vim.keymap.set(
	'n',
	'<leader>bp',
	'<cmd>lua require("bufferline").cycle(-1)<CR>',
	opts
)

vim.keymap.set(
	'n',
	'<leader>bc',
	'<cmd>bwipeout<CR>',
	opts
)

-- window
vim.keymap.set('n', '<leader>ww', '<C-w>w', opts)
vim.keymap.set('n', '<leader>wd', '<C-w>q', opts)
vim.keymap.set('n', '<leader>ws', '<C-W>s', opts)
vim.keymap.set('n', '<leader>wv', '<C-w>v', opts)
vim.keymap.set('n', '<leader>w2', '<C-w>v', opts)
vim.keymap.set('n', '<leader>wh', '<C-w>h', opts)
vim.keymap.set('n', '<leader>wj', '<C-w>j', opts)
vim.keymap.set('n', '<leader>wl', '<C-w>l', opts)
vim.keymap.set('n', '<leader>wk', '<C-w>k', opts)
vim.keymap.set('n', '<leader>wH', '<C-W>5<', opts)
vim.keymap.set('n', '<leader>wJ', '<cmd>resize +5<CR>', opts)
vim.keymap.set('n', '<leader>wL', '<C-W>5>', opts)
vim.keymap.set('n', '<leader>wK', '<cmd>resize -5<CR>', opts)
vim.keymap.set('n', '<leader>w=', '<C-W>=', opts)

--Oil
vim.keymap.set('n', '-', '<CMD>Oil<CR>', { desc = "Open parent directory" })
