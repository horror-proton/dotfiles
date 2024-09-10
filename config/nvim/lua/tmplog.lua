local uv = vim.uv or vim.loop

local files = {
    vim.lsp.get_log_path(),
}


if not string.sub(vim.fn.expand('$NVIM_LOG_FILE'), 1, 5) ~= '/tmp/' then
    table.insert(files, vim.fn.expand('$NVIM_LOG_FILE'))
end

local function move_log()
    if uv.os_uname().sysname ~= 'Linux' then
        return true
    end

    local tmp_dir = vim.fn.expand('/tmp/nvim/$UID')
    vim.fn.mkdir(tmp_dir, 'p')

    for _, file in ipairs(files) do
        vim.fn.mkdir(vim.fs.dirname(file), 'p')
        local fname = vim.fs.basename(file)
        local tmpfile = vim.fs.joinpath(tmp_dir, fname)
        if uv.fs_stat(file) then
            local dest = uv.fs_readlink(file)
            if dest and dest == tmpfile then
                local newfile = assert(io.open(tmpfile, 'a+'))
                newfile:write(string.format("Existing %s", tmpfile))
                newfile:close()
                goto continue
            end
            assert(uv.fs_copyfile(file, tmpfile))
        else
            local newfile = assert(io.open(tmpfile, 'a+'))
            newfile:write(string.format("Creating %s", tmpfile))
            newfile:close()
        end
        os.remove(file)
        assert(uv.fs_symlink(tmpfile, file))
        ::continue::
    end
end

-- in case link broken after reboot
local function remove_log_link()
    for _, file in ipairs(files) do
        if uv.fs_stat(file) and uv.fs_readlink(file) then
            uv.fs_unlink(file)
        end
    end
end

do
    local _, err = pcall(move_log)
    if err then
        vim.fn.input(err)
        remove_log_link()
    end
    vim.api.nvim_create_autocmd('VimLeave', { callback = function() remove_log_link() end, })
end
