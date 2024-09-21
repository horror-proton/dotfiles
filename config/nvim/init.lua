local utility = require('utility')

local opt = vim.opt
local cmd = vim.cmd
local kmap = utility.kmap

opt.scrolloff = 5
opt.sidescrolloff = 8
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
opt.termguicolors = true
opt.signcolumn = 'yes'

opt.conceallevel = 2
opt.spelllang = { 'en_us', 'cjk', }
vim.g.load_doxygen_syntax = 1

opt.mouse = 'a'

if os.getenv('SSH_TTY') ~= nil then
    opt.scrolljump = -40
end

vim.g.python3_host_prog = '/usr/bin/python3' -- in case in venv

kmap({ '', 'i' }, '<C-s>', function() print(cmd('update')) end)

kmap("n", { "<M-S-j>", "<M-S-Down>" }, "<cmd>m .+1<cr>==", { desc = "Move down" })
kmap("n", { "<M-S-k>", "<M-S-Up>" }, "<cmd>m .-2<cr>==", { desc = "Move up" })
kmap("i", { "<M-S-j>", "<M-S-Down>" }, "<esc><cmd>m .+1<cr>==gi", { desc = "Move down" })
kmap("i", { "<M-S-k>", "<M-S-Up>" }, "<esc><cmd>m .-2<cr>==gi", { desc = "Move up" })
kmap("v", { "<M-S-j>", "<M-S-Down>" }, ":m '>+1<cr>gv=gv", { desc = "Move down" })
kmap("v", { "<M-S-k>", "<M-S-Up>" }, ":m '<-2<cr>gv=gv", { desc = "Move up" })


for type, icon in pairs({ Error = "►", Warn = "⚠", Hint = "", Info = "", }) do
    local hl = "DiagnosticSign" .. type
    vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
end

require('tmplog')
require('desktop_notify')

require('fcitx')
require('lazy_nvim')
