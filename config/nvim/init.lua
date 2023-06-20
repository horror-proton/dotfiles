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

-- store lsplog in tmpfs
if vim.loop.os_uname().sysname == 'Linux' then
    local tmplogpath = vim.fs.normalize('/tmp/nvim/lsp.log')
    vim.fn.mkdir(vim.fs.dirname(tmplogpath), 'p')
    local logpath = vim.lsp.get_log_path()
    vim.fn.mkdir(vim.fs.dirname(logpath), 'p')
    if not vim.loop.fs_stat(logpath) then
        local lf, err = io.open(tmplogpath, 'a+')
        assert(lf):write(string.format("Creating %s", tmplogpath))
    else
        if not vim.loop.fs_readlink(logpath) then
            assert(vim.loop.fs_copyfile(logpath, tmplogpath))
        end
    end
    os.remove(logpath)
    assert(vim.loop.fs_symlink(tmplogpath, logpath))
end

require('lazy_nvim')
