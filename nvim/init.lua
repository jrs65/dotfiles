local cmd = vim.cmd  -- to execute Vim commands e.g. cmd('pwd')
local fn = vim.fn    -- to call Vim functions e.g. fn.bufnr()
local g = vim.g      -- a table to access global variables
local opt = vim.opt  -- to set options

local function map(mode, lhs, rhs, opts)
  local options = {noremap = true}
  if opts then options = vim.tbl_extend('force', options, opts) end
  vim.api.nvim_set_keymap(mode, lhs, rhs, options)
end

-- Core options
--cmd 'colorscheme gruvbox'            -- Put your favorite colorscheme here
--
-- Set leader keys
g.mapleader = " "
g.localleader = ","

opt.completeopt = {'menuone', 'noinsert', 'noselect'}  -- Completion options (for deoplete)
opt.expandtab = true                -- Use spaces instead of tabs
opt.hidden = true                   -- Enable background buffers
opt.ignorecase = true               -- Ignore case
opt.backup = false                  -- Don't use backup files
opt.writebackup = false
--opt.joinspaces = false              -- No double spaces with join
opt.list = true                     -- Show some invisible characters
opt.number = true                   -- Show line numbers
opt.cursorline = true               -- Highlight the current cursor position
opt.scrolloff = 4                   -- Lines of context
opt.shiftround = true               -- Round indent
opt.shiftwidth = 4                  -- Size of an indent
opt.tabstop = 4                     -- Number of spaces tabs count for

opt.sidescrolloff = 8               -- Columns of context
opt.smartcase = true                -- Do not ignore case with capitals
opt.smartindent = true              -- Insert indents automatically

opt.splitbelow = true               -- Put new windows below current
opt.splitright = true               -- Put new windows right of current

opt.termguicolors = true            -- True color support
opt.wildmode = {'list', 'longest'}  -- Command-line completion mode
opt.wrap = false                    -- Disable line wrap

-- Plugins
-- Relevant commands:
--   :PackerInstall
--   :PackerUpdate
--   :PackerClean

cmd 'packadd packer.nvim'


require("packer").startup(function()
    use 'wbthomason/packer.nvim'  -- packer manages itself

    use 'nvim-treesitter/nvim-treesitter'
    use 'tpope/vim-commentary'
    use 'ap/vim-buftabline'

    -- Colorschemes
    use {
        "npxbr/gruvbox.nvim",
        requires = {"rktjmp/lush.nvim"},
        config = function()
            vim.o.background = "dark"
            vim.cmd [[colorscheme gruvbox]]
        end
    }
    use 'ishan9299/nvim-solarized-lua'

    use {
        'nvim-telescope/telescope.nvim',
        requires = {{'nvim-lua/popup.nvim'}, {'nvim-lua/plenary.nvim'}},
    }

    -- LSP related plugins
    use 'neovim/nvim-lspconfig'
    use 'hrsh7th/nvim-compe'
    use 'ray-x/lsp_signature.nvim'
    use {
        'numToStr/Navigator.nvim',
        config = function()
            require('Navigator').setup()
        end
    }

    use 'inkarkat/vim-CursorLineCurrentWindow'
    use 'tpope/vim-surround'
    use 'tpope/vim-fugitive'

    -- Black, replace with LSP solution in the future
    use 'psf/black'
end)

-- status line

opt.foldcolumn = "0"  -- Set styling of the line number column
opt.fillchars = "vert: ,stl: ,stlnc: "  -- Make the split invisible (need weird quoting relative to VimL version)
opt.showmode = false
opt.laststatus = 2
opt.statusline = '%=%P - L%l:%c - %f %m'
-- It's unclear why just doind cmd hi doesn't work here
cmd 'au VimEnter * hi StatusLine gui=None guibg=#282828 guifg=#928374'
cmd 'au VimEnter * hi StatusLineNC gui=None guibg=#282828 guifg=#3c3836'


-- buftabline
g.buftabline_show = 1
g.buftabline_numbers = 1
g.buftabline_indicators = 1
-- It's unclear why just doind cmd hi doesn't work here
cmd "au VimEnter * highlight BufTabLineCurrent gui=None guibg=#282828 guifg=#FB4934"
cmd "au VimEnter * highlight BufTabLineHidden gui=None guibg=#282828 guifg=#928374"

cmd "au VimEnter * highlight LineNR gui=None guibg=#282828 guifg=#504540"
cmd "au VimEnter * highlight SignColumn gui=None guibg=#282828 guifg=#928374"
cmd "au VimEnter * highlight CursorLineNR gui=None guibg=#282828 guifg=#FB4934"

-- Configure treesitter
require'nvim-treesitter.configs'.setup {
    highlight = {
        enable = true,
        disable = {},
    },
    indent = {
        enable = true,
        disable = {},
    },
    ensure_installed = "maintained",
}

-- Telescope keymapping
map("n", " ", "<leader>")
map("n", "<leader>ff", "<cmd>lua require('telescope.builtin').find_files()<cr>")
map("n", "<leader>fg", "<cmd>lua require('telescope.builtin').live_grep()<cr>")
map("n", "<leader>fb", "<cmd>lua require('telescope.builtin').buffers()<cr>")

map("n", "<leader>fs", "<cmd>lua require('telescope.builtin').lsp_document_symbols()<cr>")
map("n", "<leader>fw", "<cmd>lua require('telescope.builtin').lsp_dynamic_workspace_symbols()<cr>")

-- LSP keybindings
map('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>')
map('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>')
map('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>')
map('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>')
map('n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>')
map('n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>')
map('n', '<C-n>', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>')
map('n', '<C-p>', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>')


-- Compe setup
require'compe'.setup {
  enabled = true;
  autocomplete = true;
  debug = false;
  min_length = 1;
  preselect = 'enable';
  throttle_time = 100;
  source_timeout = 200;
  incomplete_delay = 400;
  max_abbr_width = 100;
  max_kind_width = 100;
  max_menu_width = 100;
  documentation = true;

  source = {
    path = true;
    buffer = true;
    --calc = true;
    --vsnip = true;
    nvim_lsp = true;
    nvim_lua = true;
    --spell = true;
    --tags = true;
    --snippets_nvim = true;
    --treesitter = true;
  };
}

-- map("i", "<Tab>", "v:lua.tab_complete()", {expr = true})
-- map("s", "<Tab>", "v:lua.tab_complete()", {expr = true})
-- map("i", "<S-Tab>", "v:lua.s_tab_complete()", {expr = true})
-- map("s", "<S-Tab>", "v:lua.s_tab_complete()", {expr = true})

require'lspconfig'.pyright.setup{}

require'lsp_signature'.on_attach()


map('n', "<C-h>", "<CMD>lua require('Navigator').left()<CR>")
map('n', "<C-k>", "<CMD>lua require('Navigator').up()<CR>")
map('n', "<C-l>", "<CMD>lua require('Navigator').right()<CR>")
map('n', "<C-j>", "<CMD>lua require('Navigator').down()<CR>")
map('n', "<C-p>", "<CMD>lua require('Navigator').previous()<CR>")

g.CursorLineCurrentWindow_OptionNames = {'cursorline'}

function dark_mode()
    vim.o.background = "dark"
    vim.cmd [[colorscheme gruvbox]]
end

function light_mode()
    vim.o.background = "light"
    vim.cmd [[colorscheme solarized]]
end

map('n', "<leader>d", "<CMD>lua dark_mode()<CR>")
map('n', "<leader>l", "<CMD>lua light_mode()<CR>")

