local _M = {}

local function bootstrap_lazy()
    local success, lazy = pcall(require, 'lazy')
    if success then return lazy end

    local lazy_path = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'

    if vim.loop.fs_stat(lazy_path) then
        vim.opt.rtp:prepend(lazy_path)
        success, lazy = pcall(require, 'lazy')
        if success then return lazy end
        vim.opt.rtp:remove(lazy_path)
    end

    -- vim.fn.system("false")
    -- print(vim.v.shell_error)

    local command =
        table.concat({
            'git',
            'clone',
            '--filter=tree:0',
            'https://github.com/folke/lazy.nvim.git',
            '--branch=stable',
            lazy_path,
            '2>&1',
        }, ' ')

    local handle = assert(io.popen(command .. ';echo $?'))
    local last_line = ''
    for line in handle:lines() do
        io.write('\t' .. line .. '\r\n')
        last_line = line
    end

    -- workarund for handle:close() in Lua 5.2
    handle:close()
    assert(tonumber(last_line) == 0, 'Failed to clone lazy.nvim into' .. lazy_path)

    vim.opt.rtp:prepend(lazy_path)

    success, lazy = pcall(require, 'lazy')
    assert(success, 'Broken lazy.nvim' .. lazy)

    return lazy
end

local lazy = assert(bootstrap_lazy())

local opts = {
    git = {
        url_format = "git@github.com:%s.git",
    },
}

lazy.setup(require('plugins'), opts)
