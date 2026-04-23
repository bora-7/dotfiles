------------------- OPTIONS -------------------
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '
vim.g.have_nerd_font = true
vim.o.number = true
vim.o.relativenumber = true
vim.o.mouse = 'a'
vim.o.showmode = false
vim.schedule(function() vim.o.clipboard = 'unnamedplus' end)
vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.signcolumn = 'yes'
vim.o.updatetime = 250
vim.o.timeoutlen = 500
vim.o.list = true
-- vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }
vim.opt.listchars = { tab = '│ ', trail = '·', nbsp = '␣' }
vim.opt.wrap = false
vim.o.inccommand = 'split'
vim.o.scrolloff = 10
vim.o.confirm = true
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true

-- errors inline
vim.diagnostic.config {
	update_in_insert = true,
	severity_sort = true,
	virtual_text = true,
	jump = { float = true },
}

-- remove default syntax highlight, only use treestierr
vim.cmd('syntax off')

---------------- AUTO COMMANDS -------------------

-- yank highlight
vim.api.nvim_create_autocmd('TextYankPost', {
  callback = function()
    vim.highlight.on_yank({ timeout = 100, })
    end,
})

-- attatch treesitter
vim.api.nvim_create_autocmd('FileType', {
    callback = function() pcall(vim.treesitter.start) end,
})

---------------- PLUGIN INSTALL -----------------

vim.cmd('packadd nvim.difftool')
vim.cmd('packadd nvim.undotree')


vim.pack.add {
	-- dependencies --
	'https://github.com/nvim-lua/plenary.nvim',
    'https://github.com/nvim-tree/nvim-web-devicons',
    'https://github.com/lewis6991/gitsigns.nvim',
    -- plugins --
	'https://github.com/ellisonleao/gruvbox.nvim',
	'https://github.com/stevearc/oil.nvim',
	'https://github.com/windwp/nvim-autopairs',
	'https://github.com/christoomey/vim-tmux-navigator',
	'https://github.com/nvim-telescope/telescope.nvim',
	'https://github.com/windwp/nvim-ts-autotag',
    'https://github.com/tpope/vim-surround',
    'https://github.com/nvim-mini/mini.ai',
	{ src = 'https://github.com/theprimeagen/harpoon', branch='harpoon2' },
	-- LSP --
	{ src = 'https://github.com/saghen/blink.cmp', branch = 'v1' },
	'https://github.com/neovim/nvim-lspconfig',
	'https://github.com/nvim-treesitter/nvim-treesitter',
    'https://github.com/nvim-lualine/lualine.nvim',
    "https://github.com/mason-org/mason.nvim",
    "https://github.com/mason-org/mason-lspconfig.nvim",
    "https://github.com/WhoIsSethDaniel/mason-tool-installer.nvim",
    "https://github.com/stevearc/conform.nvim",
}

-------------------- PLUGIN CONFIG -----------------------

require('mini.ai').setup()

require("lualine").setup({
  options = {
    theme = "auto",
  },
  sections = {
    lualine_a = { "mode", "filename", "branch" },
    lualine_b = {},
    lualine_c = {},
    lualine_x = {},
    lualine_y = {},
    lualine_z = {
      {
        "diagnostics",
      },
      {
        "diff",
        symbols = { added = "+", modified = "~", removed = "-" },
      }
    },
  },
})


require('oil').setup({
  columns = { "icon" },
  view_options = {
    show_hidden = true,
  },
  skip_confirm_for_simple_edits = true,
})

require('nvim-autopairs').setup()

require('gitsigns').setup({
  signs = {
    add          = { text = '+' },
    change       = { text = '~' },
    delete       = { text = '_' },
    topdelete    = { text = '‾' },
    changedelete = { text = '~' },
  },
  on_attach = function(bufnr)
    local gs = require('gitsigns')
    local map = function(mode, lhs, rhs, desc)
      vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc })
    end

    map('n', ']c', function() gs.nav_hunk('next') end, 'Next hunk')
    map('n', '[c', function() gs.nav_hunk('prev') end, 'Prev hunk')

    map('n', '<leader>hp', gs.preview_hunk, 'Preview hunk')
    map('n', '<leader>hs', gs.stage_hunk, 'Stage hunk')
    map('n', '<leader>hu', gs.undo_stage_hunk, 'Unstage hunk')
    map('n', '<leader>hr', gs.reset_hunk, 'Reset hunk')
    map('n', '<leader>hd', gs.diffthis, 'Diff against index')
    map('n', '<leader>hD', function() gs.diffthis('~') end, 'Diff against HEAD')
    map('n', '<leader>ht', gs.toggle_deleted, 'Toggle deleted lines')

    map({ 'o', 'x' }, 'ih', '<cmd>Gitsigns select_hunk<cr>', 'Inner hunk')
  end,
})

require('nvim-ts-autotag').setup()

require('blink.cmp').setup({
	fuzzy = { implementation = 'lua' },
	signature = { enabled = true },
	keymap = { preset = 'super-tab' },
})

--------------------- KEYMAPS -------------------

-- harpoon keymaps
local mark = require("harpoon.mark")
local ui = require("harpoon.ui")

vim.keymap.set("n", "<leader>fa", mark.add_file)
vim.keymap.set("n", "<C-e>", ui.toggle_quick_menu)

vim.keymap.set("n", "<leader>1", function() ui.nav_file(1) end)
vim.keymap.set("n", "<leader>2", function() ui.nav_file(2) end)
vim.keymap.set("n", "<leader>3", function() ui.nav_file(3) end)
vim.keymap.set("n", "<leader>4", function() ui.nav_file(4) end)

vim.cmd.colorscheme("gruvbox")
-- vsplit
vim.keymap.set("n", "|", function()
  vim.cmd("botright vsplit")
  require("oil").open()
end, { desc = "Oil right split" })

-- new h split
vim.keymap.set("n", "_", function()
  vim.cmd("botright split") -- bottom
  require("oil").open()
end, { desc = "Oil bottom split" })

-- oil
vim.keymap.set('n', '<leader>o', '<cmd>Oil<cr>')

-- alternate buffer
vim.keymap.set('n', '<leader>a', '<C-^>')

-- Move selected block down
vim.keymap.set('v', 'J', ":<C-u>'<,'>m '>+1<CR>gv=gv")

-- Move selected block up
vim.keymap.set('v', 'K', ":<C-u>'<,'>m '<-2<CR>gv=gv")

-- move between panes like tmux
vim.keymap.set('n', '<C-h>', '<C-w>h')
vim.keymap.set('n', '<C-j>', '<C-w>j')
vim.keymap.set('n', '<C-k>', '<C-w>k')
vim.keymap.set('n', '<C-l>', '<C-w>l')

-- restart nvim
vim.keymap.set('n', '<leader><C-r>', '<cmd>restart<cr>')

-- remove search highlight
vim.keymap.set("n", "<C-x>", function() vim.cmd("nohlsearch") end)


-- zz remaps
vim.keymap.set('n', '<C-d>', '<C-d>zz', { desc = 'Half page down' })
vim.keymap.set('n', '<C-u>', '<C-u>zz', { desc = 'Half page up' })


-- ~/.config/nvim/init.lua (at the top level, not in a filetype plugin)

-- Hover with custom border
vim.keymap.set("n", "K", function()
  vim.lsp.buf.hover({
    border = "rounded",
    focusable = true,
    max_width = 80,
    max_height = 30,
  })
end, { noremap = true, silent = true })

-- Signature help with rounded border
vim.keymap.set("n", "<C-k>", function()
  vim.lsp.buf.signature_help({
    border = "rounded",
    focusable = true,
  })
end, { noremap = true, silent = true })

-- Diagnostics with rounded border
vim.keymap.set("n", "<leader>d", function()
  vim.diagnostic.open_float({
    border = "rounded",
    focusable = true,
    max_width = 80,
  })
end, { noremap = true, silent = true })

-- telescope -- 
local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>sf', function() builtin.find_files({ hidden = true }) end, { desc = 'Find files' })
vim.keymap.set('n', '<leader>sg', builtin.live_grep, { desc = 'Live grep' })
vim.keymap.set('n', '<leader><leader>', builtin.buffers, { desc = 'Buffers' })
vim.keymap.set('n', '<leader>sh', builtin.help_tags, { desc = 'Help tags' })

-- Telescope Workspace Errors
vim.keymap.set(
	'n',
	'<leader>se',
	function()
		builtin.diagnostics {
			severity = vim.diagnostic.severity.ERROR,
		}
	end,
	{ desc = '[S]how Workspace [E]rrors' }
)

-- Workspace Warnings
vim.keymap.set(
	'n',
	'<leader>sw',
	function()
		builtin.diagnostics {
			severity = vim.diagnostic.severity.WARN,
		}
	end,
	{ desc = '[S]earch Workspace [W]arnings' }
)

-- toggle warnings
local warnings_enabled = true

vim.keymap.set('n', '<leader>tw', function()
  warnings_enabled = not warnings_enabled

  if warnings_enabled then
    vim.diagnostic.config {
      virtual_text = true,
      underline = true,
    }
    print("Warnings enabled")
  else
    vim.diagnostic.config {
      virtual_text = { severity = vim.diagnostic.severity.ERROR },
      underline = { severity = vim.diagnostic.severity.ERROR },
    }
    print("Warnings disabled")
  end
end, { noremap = true, silent = false })

vim.keymap.set('n', '<leader>u', '<cmd>Undotree<cr>', {
  noremap = true,
  silent = true,
  desc = 'Toggle Undotree'
})


-- bg transparent
vim.api.nvim_set_hl(0, 'Normal', { bg = 'none' })
vim.api.nvim_set_hl(0, 'NormalFloat', { bg = 'none' })
vim.api.nvim_set_hl(0, "SignColumn", { bg = "none" })

------------------------- LSP SETUP -----------------------

local lsp_servers = {
	dockerls = {},
	html = {}, -- vscode-html-language-server
	cssls = {}, -- vscode-css-language-server
	jsonls = {}, -- vscode-json-language-server
	-- eslint = {}, -- vscode-eslint-language-server
	clangd = {},
	gopls = {
		settings = {
			gopls = {
				analyses = {
					unusedparams = true, -- warns about unused function parameters
					nilness = true, -- warns about possible nil dereferences
					unusedwrite = true, -- warns about values written but never read
					shadow = true, -- variable shadowing
				},
				staticcheck = true, -- enables many linter-like warnings
			},
		},
	},
	ts_ls = {
		settings = {
			typescript = {
				inlayHints = {
					includeInlayParameterNameHints = 'all',
					includeInlayParameterNameHintsWhenArgumentMatchesName = false,
					includeInlayFunctionParameterTypeHints = true,
					includeInlayVariableTypeHints = true,
					includeInlayPropertyDeclarationTypeHints = true,
					includeInlayFunctionLikeReturnTypeHints = true,
					includeInlayEnumMemberValueHints = true,
				},
			},
			javascript = {
				inlayHints = {
					includeInlayParameterNameHints = 'all',
					includeInlayFunctionParameterTypeHints = true,
					includeInlayVariableTypeHints = true,
				},
			},
		},
	},
	pyright = {
		settings = {
			python = {
				analysis = {
					typeCheckingMode = 'strict',
					autoSearchPaths = true,
					useLibraryCodeForTypes = true,
					diagnosticMode = 'workspace',
					inlayHints = {
						variableTypes = true,
						functionReturnTypes = true,
						callArgumentNames = true,
					},
				},
			},
		},
	},
	jdtls = {},
	postgres_lsp = {},
	tailwindcss = {},
}

require("mason").setup()
require("mason-lspconfig").setup()
require("mason-tool-installer").setup({
  ensure_installed = vim.list_extend(vim.tbl_keys(lsp_servers), { "prettier" }),
})

require("conform").setup({
  formatters_by_ft = {
    javascript      = { "prettier" },
    typescript      = { "prettier" },
    javascriptreact = { "prettier" },
    typescriptreact = { "prettier" },
    html            = { "prettier" },
    css             = { "prettier" },
    scss            = { "prettier" },
    json            = { "prettier" },
    yaml            = { "prettier" },
    markdown        = { "prettier" },
  },
  format_on_save = { timeout_ms = 500, lsp_fallback = true },
})

-- configure each lsp server on the table
-- to check what clients are attached to the current buffer, use
-- `:checkhealth vim.lsp`. to view default lsp keybindings, use `:h lsp-defaults`.
for server, config in pairs(lsp_servers) do
  vim.lsp.config(server, {
    settings = config,
    -- only create the keymaps if the server attaches successfully
    on_attach = function(_, bufnr)
      vim.keymap.set("n", "grd", vim.lsp.buf.definition,
        { buffer = bufnr, desc = "vim.lsp.buf.definition()" })
      vim.keymap.set("n", "grt", vim.lsp.buf.type_definition,
        { buffer = bufnr, desc = "vim.lsp.buf.type_definition()" })
      vim.keymap.set("n", "grf", vim.lsp.buf.format,
        { buffer = bufnr, desc = "vim.lsp.buf.format()" })
      vim.keymap.set("n", "grr", vim.lsp.buf.references,
        { buffer = bufnr, desc = "vim.lsp.buf.references()" })
      
      -- Additional useful keymaps
      vim.keymap.set("n", "gri", vim.lsp.buf.implementation,
        { buffer = bufnr, desc = "vim.lsp.buf.implementation()" })
      vim.keymap.set("n", "grn", vim.lsp.buf.rename,
        { buffer = bufnr, desc = "vim.lsp.buf.rename()" })
      vim.keymap.set("n", "gra", vim.lsp.buf.code_action,
        { buffer = bufnr, desc = "vim.lsp.buf.code_action()" })
      vim.keymap.set("n", "K", vim.lsp.buf.hover,
        { buffer = bufnr, desc = "vim.lsp.buf.hover()" })
      vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help,
        { buffer = bufnr, desc = "vim.lsp.buf.signature_help()" })
      
      -- Diagnostics
      vim.keymap.set("n", "[d", vim.diagnostic.goto_prev,
        { buffer = bufnr, desc = "Go to previous diagnostic" })
      vim.keymap.set("n", "]d", vim.diagnostic.goto_next,
        { buffer = bufnr, desc = "Go to next diagnostic" })
      vim.keymap.set("n", "<leader>d", vim.diagnostic.open_float,
        { buffer = bufnr, desc = "Open diagnostic float" })
    end,
  })
  vim.lsp.enable(server)
end

-- :TSInstall bash c cpp diff html css javascript typescript tsx lua luadoc markdown vim python json go java yaml dockerfile sql regex query scss xml csv ini toml make helm graphql http rust php

local group = vim.api.nvim_create_augroup('AutoSave', { clear = true })

vim.api.nvim_create_autocmd(
{ 'InsertLeave', 'TextChanged', 'FocusLost', 'BufLeave' },
{
group = group,
callback = function()
local b = vim.api.nvim_get_current_buf()
if vim.bo[b].buftype == ''
  and vim.bo[b].modifiable
  and vim.api.nvim_buf_get_name(b) ~= ''
then
  vim.cmd('silent! update')
end
end,
}
)

-- oil root
vim.keymap.set('n', '<leader>O', function()
  require('oil').open(vim.fn.getcwd())
end)
