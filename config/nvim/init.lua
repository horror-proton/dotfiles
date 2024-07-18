local utility = require('utility')

local opt = vim.opt
local cmd = vim.cmd
local uv = utility.uv
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


kmap({ '', 'i' }, '<C-s>', function() print(cmd('update')) end)

kmap("n", { "<M-S-j>", "<M-S-Down>" }, "<cmd>m .+1<cr>==", { desc = "Move down" })
kmap("n", { "<M-S-k>", "<M-S-Up>" }, "<cmd>m .-2<cr>==", { desc = "Move up" })
kmap("i", { "<M-S-j>", "<M-S-Down>" }, "<esc><cmd>m .+1<cr>==gi", { desc = "Move down" })
kmap("i", { "<M-S-k>", "<M-S-Up>" }, "<esc><cmd>m .-2<cr>==gi", { desc = "Move up" })
kmap("v", { "<M-S-j>", "<M-S-Down>" }, ":m '>+1<cr>gv=gv", { desc = "Move down" })
kmap("v", { "<M-S-k>", "<M-S-Up>" }, ":m '<-2<cr>gv=gv", { desc = "Move up" })


for type, icon in pairs({ Error = "►", Warn = "⚠", Hint = "", Info = "", }) do
    local hl = "DiagnosticSign" .. type
    vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
end

local function _move_lsplog()
    if uv.os_uname().sysname ~= 'Linux' then
        return true
    end
    local tmplogpath = vim.fs.normalize(vim.fn.expand('/tmp/nvim/$USER/lsp.log'))
    vim.fn.mkdir(vim.fs.dirname(tmplogpath), 'p')
    local logpath = vim.lsp.get_log_path()
    vim.fn.mkdir(vim.fs.dirname(logpath), 'p')
    if not uv.fs_stat(logpath) then
        local lf = assert(io.open(tmplogpath, 'a+'))
        lf:write(string.format("Creating %s", tmplogpath))
    elseif not uv.fs_readlink(logpath) then
        assert(uv.fs_copyfile(logpath, tmplogpath))
    else
        assert(io.open(tmplogpath, 'a+')):close() -- is it writable?
    end
    os.remove(logpath)
    assert(uv.fs_symlink(tmplogpath, logpath))
end

do
    local _, err = pcall(_move_lsplog)
    if err then vim.fn.input(err) end
end

require('lazy_nvim')
require('fcitx')

