if not vim.fn.executable('fcitx5-remote') then
    return
end

if os.getenv('SSH_TTY') ~= nil then
    return
end

local function starts_with(str, start)
    return str:sub(1, #start) == start
end

-- getenv('TTY') not working
if os.getenv('TERM') == 'linux' then
    return
end

local run_cmd_sync = function(args)
    local res = vim.system(args, { text = true, timeout = 1000 }):wait()
    if res.code ~= 0 then
        vim.notify('Failed to run ' .. table.concat(args, ' '), 'error')
    end
    if res.stderr ~= '' then
        vim.notify(res.stderr, 'error')
    end
    return res
end

local get_im_name = function()
    return run_cmd_sync({ 'fcitx5-remote', '-n' }).stdout:gsub('\n', '')
end

local input_method_name = get_im_name()

vim.api.nvim_create_autocmd('InsertLeave', {
    callback = function()
        input_method_name = get_im_name()
        if input_method_name == 'keyboard-us' then
            return
        end
        run_cmd_sync({ 'fcitx5-remote', '-c' })
    end
})

vim.api.nvim_create_autocmd('InsertEnter', {
    callback = function()
        if input_method_name == 'keyboard-us' then
            return
        end
        run_cmd_sync({ 'fcitx5-remote', '-s', input_method_name })
    end
})
