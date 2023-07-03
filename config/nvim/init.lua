local utility = require('utility')

local opt = vim.opt
local cmd = vim.cmd
local uv = utility.uv

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
