vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

local opt = vim.opt

opt.mouse = 'a'
opt.mousemodel = 'extend'
opt.mousescroll = 'ver:1,hor:1'
opt.termguicolors = true
opt.fileencoding = 'utf-8'
opt.fsync = true
opt.showmode = false
opt.wrap = false
opt.wrapscan = true
opt.linebreak = true
opt.number = true
opt.relativenumber = true
opt.cursorline = true
opt.cursorlineopt = 'number'
opt.signcolumn = 'yes:1'
opt.undofile = true
vim.g.netrw_banner = 0 -- is this the correct var name?

-- used with autosession
-- removed 'localoptions' - autosession gets weird setting incorrect values
opt.sessionoptions = 'blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal'

-- See :h fo-table
-- (autocommands.lua overrides 'a' and 't' for certain filetypes)
opt.formatoptions = opt.formatoptions
  - 'a' -- disable automatic formatting of entire paragraphs insert-mode
  - 't' -- dont autowrap text...
  + 'c' -- ...but do autowrap comments
  - 'o' -- don't insert comment after o/O commands (also set in autocommands.lua)
  + 'r' -- do insert comment after enter in insert mode
  - 'q' -- allow formatting comments with gq
  + 'n' -- recognize numbered lists
  - '2' -- don't use second line's indent level for formatting rest of paragraph
  + 'j' -- remove comment leader when joining comments
-- Insert linebreak automatically after 80 chars
opt.textwidth = 80
-- When formatting text, recognize numbered lists AND unordered lists.
-- https://superuser.com/questions/99138/bulleted-lists-for-plain-text-documents-in-vim
opt.formatlistpat = [[^\s*\(\d\+[\]:.)}\t ]\|[*-][\t ]\)\s*]]

-- (lua and vimscript plugins only)
vim.g.loaded_perl_provider = 0
vim.g.loaded_ruby_provider = 0
vim.g.loaded_node_provider = 0
vim.g.loaded_python_provider = 0
vim.g.loaded_python3_provider = 0

opt.autoindent = true
opt.smartindent = true
opt.smarttab = true
opt.tabstop = 4
opt.shiftwidth = 4
opt.expandtab = true

opt.mousemoveevent = true
opt.splitbelow = true
opt.splitright = true
opt.cmdheight = 0
opt.cedit = '<C-f>'
opt.cmdwinheight = 3
opt.showcmdloc = 'statusline'
opt.laststatus = 3
opt.shortmess:append('IcCsS')
opt.updatetime = 200
opt.hidden = true
opt.scrolloff = 8
opt.sidescrolloff = 8
opt.inccommand = 'nosplit' -- split enables the preview winow when doing substitutions and similar things
opt.incsearch = true
opt.hlsearch = true
opt.ignorecase = true
opt.smartcase = true
opt.secure = true -- sometimes "ex:" is misread as an ex command in source files
opt.modelines = 2
opt.termguicolors = true
