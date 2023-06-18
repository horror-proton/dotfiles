local opt = vim.opt
local cmd = vim.cmd


opt.scrolloff = 5
opt.sidescrolloff = 3
opt.relativenumber = true
opt.number = true
opt.wrap = false
opt.tabstop = 8
opt.shiftwidth = 4
opt.expandtab = true
opt.smarttab = true
opt.showbreak = '↪ '
opt.list = true
--opt.listchars = 'tab:╶─╴,eol:🢱,nbsp:␣,trail:•,extends:⟩,precedes:⟨,space:•'
opt.listchars = {
  tab = '╶─╴',
  eol = '🞗', --↵🢱
  nbsp = '␣',
  trail = '•',
  extends = '⟩',
  precedes = '⟨',
  space = '•',
}

opt.signcolumn = 'yes'


cmd('syntax enable')
opt.conceallevel = 2
opt.spelllang = { 'en_us', 'cjk', }

opt.mouse = 'a'


vim.keymap.set({ '', 'i' }, '<C-s>', function() print(cmd('update')) end)


require('lazy_nvim')
