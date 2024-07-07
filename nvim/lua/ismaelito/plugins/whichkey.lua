-- import which_key plugin safely
local whichkey_setup_ok, which_key_imp = pcall(require, "which-key")
if not whichkey_setup_ok then
	return
end

local setup = {
	plugins = {
		marks = false, -- shows a list of your marks on ' and `
		registers = true, -- shows your registers on " in NORMAL or <C-r> in INSERT mode
		spelling = {
			enabled = true, -- enabling this will show WhichKey when pressing z = to select spelling suggestions
			suggestions = 20, -- how many suggestions should be shown in the list?
		},
		-- The presets plugin, adds help for a bunch of default keybindings in Neovim
		-- No actual key bindings are created
		presets = {
			operators = false, -- adds help for operators like d, y, ... and registers them for motion / text object completion
			motions = false, -- adds help for motions
			text_objects = false, -- help for text objects triggered after entering an operator
			windows = false, -- default bindings on <c-w>
			nav = false, -- misc bindings to work with windows
			z = true, -- bindings for folds, spelling and others prefixed with z
			g = false, -- bindings for prefixed with g
		},
	},
	-- add operators that will trigger motion and text object completion
	-- to enable native operators, set the preset / operators plugin above
	-- operators = { gc = "Comments" },
	key_labels = {
		-- override the label used to display some keys. It doesn't effect WK in any other way.
		-- For example:
		-- ["<space>"] = "SPC",
		-- ["<CR>"] = "RET",
		-- ["<tab>"] = "TAB",
	},
	icons = {
		breadcrumb = "»", -- symbol used in the command line area that shows your active key combo
		separator = "", -- symbol used between a key and it's label
		group = "+", -- symbol prepended to a group
	},
	popup_mappings = {
		scroll_down = "<c-d>", -- binding to scroll down inside the popup
		scroll_up = "<c-u>", -- binding to scroll up inside the popup
	},
	window = {
		border = "rounded", -- none, single, double, shadow
		position = "bottom", -- bottom, top
		margin = { 1, 0, 1, 0 }, -- extra window margin [top, right, bottom, left]
		padding = { 2, 2, 2, 2 }, -- extra window padding [top, right, bottom, left]
		winblend = 0,
	},
	layout = {
		height = { min = 4, max = 25 }, -- min and max height of the columns
		width = { min = 20, max = 50 }, -- min and max width of the columns
		spacing = 3, -- spacing between columns
		align = "left", -- align columns left, center or right
	},
	ignore_missing = true, -- enable this to hide mappings for which you didn't specify a label
	hidden = { "<silent>", "<cmd>", "<Cmd>", "<CR>", "call", "lua", "^:", "^ " }, -- hide mapping boilerplate
	show_help = true, -- show help message on the command line when the popup is visible
	triggers = "auto", -- automatically setup triggers
	-- triggers = {"<leader>"} -- or specify a list manually
	triggers_blacklist = {
		-- list of mode / prefixes that should never be hooked by WhichKey
		-- this is mostly relevant for key maps that start with a native binding
		-- most people should not need to change this
		i = { "j", "k" },
		v = { "j", "k" },
	},
}

local opts = {
	mode = { "n", "v" }, -- NORMAL and VISUAL mode
	prefix = "<leader>",
	buffer = nil, -- Global mappings. Specify a buffer number for buffer local mappings
	silent = true, -- use `silent` when creating keymaps
	noremap = true, -- use `noremap` when creating keymaps
	nowait = true, -- use `nowait` when creating keymaps
}

----------------------
-- GENERAL MAPPINGS --
----------------------
local mappings = {
	["b"] = { "<cmd>VimtexCompile<CR>", "build" },
	["c"] = { "<cmd>VimtexCountWords!<CR>", "count" },
	["d"] = { "<cmd>bdelete!<CR>", "delete buffer" },
	["e"] = { "<cmd>NvimTreeToggle<CR>", "explorer" },
	["i"] = { "<cmd>VimtexTocOpen<CR>", "index" },
	["q"] = { "<cmd>wqa!<CR>", "quit" },
	["r"] = { "", "reorder" },
	["u"] = { "<cmd>UndotreeToggle<CR>", "undo" },
	["v"] = { "<cmd>VimtexView<CR>", "view" },
	["w"] = { "<cmd>wa!<CR>", "write" },
	["x"] = { "", "checkmark" },
	a = {
		name = "ACTIONS",
		a = { "<cmd>lua PdfAnnots()<CR>", "annotate" },
		b = { "<cmd>terminal bibexport -o %:p:r.bib %:p:r.aux<CR>", "bib export" },
		c = { "<cmd>VimtexClean<CR>", "clean aux" },
		g = { "<cmd>e ~/Documents/Codigo/LaTeX/tfmaster/Preliminares/acronimos.tex<CR>", "edit glossary" },
		h = { "<cmd>lua _HTOP_TOGGLE()<CR>", "htop" },
		i = { "<cmd>IlluminateToggle<CR>", "illuminate" },
		l = { "<cmd>lua vim.g.cmptoggle = not vim.g.cmptoggle<CR>", "LSP" },
		p = { '<cmd>lua require("nabla").popup()<CR>', "preview symbols" },
		r = { "<cmd>VimtexErrors<CR>", "report errors" },
		s = {
			name = "EDIT SNIPPETS",
			a = { "<cmd>e ~/.config/nvim/LuaSnip/all.lua<CR>", "all.lua" },
			d = { "<cmd>e ~/.config/nvim/LuaSnip/tex/delimiters.lua<CR>", "delimiters.lua" },
			e = { "<cmd>e ~/.config/nvim/LuaSnip/tex/environments.lua<CR>", "environments.lua" },
			l = { "<cmd>e ~/.config/nvim/LuaSnip/tex/mathopt.lua<CR>", "opten.lua" },
			f = { "<cmd>e ~/.config/nvim/LuaSnip/tex/fonts.lua<CR>", "fonts.lua" },
			g = { "<cmd>e ~/.config/nvim/LuaSnip/tex/greek.lua<CR>", "greek.lua" },
			m = { "<cmd>e ~/.config/nvim/LuaSnip/tex/math.lua<CR>", "math.lua" },
			s = { "<cmd>e ~/.config/nvim/LuaSnip/tex/static.lua<CR>", "static.lua" },
			t = { "<cmd>e ~/.config/nvim/LuaSnip/tex/struct.lua<CR>", "struct.lua" },
		},
		u = { "<cmd>cd %:p:h<CR>", "update cwd" },
		-- w = { "<cmd>TermExec cmd='pandoc %:p -o %:p:r.docx'<CR>" , "word"},
		v = { "<plug>(vimtex-context-menu)", "vimtex menu" },
	},
	f = {
		name = "FIND",
		b = {
			"<cmd>lua require('telescope.builtin').buffers(require('telescope.themes').get_dropdown{previewer = false})<CR>",
			"buffers",
		},
		c = { "<cmd>Telescope bibtex<CR>", "citations" },
		f = { "<cmd>Telescope live_grep theme=ivy<CR>", "project" },
		g = { "<cmd>Telescope git_branches<CR>", "branches" },
		h = { "<cmd>Telescope help_tags<CR>", "help" },
		k = { "<cmd>Telescope keymaps<CR>", "keymaps" },
		-- m = { "<cmd>Telescope man_pages<CR>", "man pages" },
		r = { "<cmd>Telescope registers<CR>", "registers" },
		t = { "<cmd>Telescope colorscheme<CR>", "theme" },
		-- y = { "<cmd>YankyRingHistory<CR>", "yanks" },
		-- c = { "<cmd>Telescope commands<CR>", "commands" },
		-- r = { "<cmd>Telescope oldfiles<CR>", "recent" },
	},
	g = {
		name = "GIT",
		g = { "<cmd>lua _LAZYGIT_TOGGLE()<CR>", "lazygit" },
		j = { "<cmd>lua require 'gitsigns'.next_hunk()<CR>", "next hunk" },
		k = { "<cmd>lua require 'gitsigns'.prev_hunk()<CR>", "prev hunk" },
		l = { "<cmd>lua require 'gitsigns'.blame_line()<CR>", "blame" },
		p = { "<cmd>lua require 'gitsigns'.preview_hunk()<CR>", "preview hunk" },
		r = { "<cmd>lua require 'gitsigns'.reset_hunk()<CR>", "reset hunk" },
		s = { "<cmd>lua require 'gitsigns'.stage_hunk()<CR>", "stage hunk" },
		u = {
			"<cmd>lua require 'gitsigns'.undo_stage_hunk()<CR>",
			"unstage hunk",
		},
		o = { "<cmd>Telescope git_status<CR>", "open changed file" },
		b = { "<cmd>Telescope git_branches<CR>", "checkout branch" },
		c = { "<cmd>Telescope git_commits<CR>", "checkout commit" },
		d = { "<cmd>Gitsigns diffthis HEAD<CR>", "diff" },
	},
	m = {
		name = "MANAGE SESSIONS",
		s = { "<cmd>SessionManager save_current_session<CR>", "save" },
		d = { "<cmd>SessionManager delete_session<CR>", "delete" },
		l = { "<cmd>SessionManager load_session<CR>", "load" },
	},
	p = {
		name = "PANDOC",
		w = { "<cmd>TermExec cmd='pandoc %:p -o %:p:r.docx'<CR>", "word" },
		m = { "<cmd>TermExec cmd='pandoc %:p -o %:p:r.md'<CR>", "markdown" },
		h = { "<cmd>TermExec cmd='pandoc %:p -o %:p:r.html'<CR>", "html" },
		l = { "<cmd>TermExec cmd='pandoc %:p -o %:p:r.tex'<CR>", "latex" },
		p = { "<cmd>TermExec cmd='pandoc %:p -o %:p:r.pdf'<CR>", "pdf" },
	},
	s = {
		name = "SURROUND",
		s = { "<Plug>(nvim-surround-normal)", "surround" },
		d = { "<Plug>(nvim-surround-delete)", "delete" },
		c = { "<Plug>(nvim-surround-change)", "change" },
	},
	t = {
		name = "TEMPLATES",
		b = {
			"<cmd>read ~/.config/nvim/templates/plantilla_beamer1.tex<CR>",
			"plantilla_beamer1.tex",
		},
		g = {
			"<cmd>read ~/.config/nvim/templates/plantilla_beamer2.tex<CR>",
			"plantilla_beamer2.tex",
		},
		h = {
			"<cmd>read ~/.config/nvim/templates/plantilla_beamer3.tex<CR>",
			"plantilla_beamer3.tex",
		},
		l = {
			"<cmd>read ~/.config/nvim/templates/isma_beamer.tex<CR>",
			"isma_beamer.tex",
		},
		r = {
			"<cmd>read ~/.config/nvim/templates/troubleshooting.tex<CR>",
			"troubleshooting.tex",
		},
		s = {
			"<cmd>read ~/.config/nvim/templates/isma_tikz.tex<CR>",
			"isma_tikz.tex",
		},
		p = {
			"<cmd>read ~/.config/nvim/templates/informes.tex<CR>",
			"informes.tex",
		},
		--m = {
		--  "<cmd>read ~/.config/nvim/templates/nombre.tex<CR>",
		--  "nombre.tex",
		--},
		z = { "<cmd>PackerCompile<CR>", "Compile" },
	},
}

-- Configuración sencilla de which-key
which_key_imp.setup(setup)
which_key_imp.register(mappings, opts)