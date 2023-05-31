local get_hex = require('cokeline/utils').get_hex

require('cokeline').setup {
    default_hl = {
        fg = function(buffer)
            return buffer.is_focused and get_hex('Normall', 'fg') or get_hex('Comment', 'fg')
        end,
        bg = get_hex('ColorColumn', 'bg')
    },
    sidebar = {
        filetype = 'NvimTree',
        components = {
            {
                text = ' -- NvimTree --',
                bg = get_hex('NvimTreeNormal', 'bg'),
            },
        }
    },
    buffers = {
        -- focus_on_delete = 'next',
    },
    components = {
        {
            text = function(buffer) return ((buffer.index ~= 1) and '|' or ' ') .. '' end,
            fg = require('cokeline/utils').get_hex('ColorColumn', 'bg'),
            bg = require('cokeline/utils').get_hex('Normal', 'bg'),
            truncation = { priority = 1, },
        },
        {
            text = function(buffer)
                return buffer.devicon.icon
            end,
            fg = function(buffer)
                return buffer.devicon.color
            end,
            truncation = { priority = 1, },
        },
        {
            text = function(buffer)
                return buffer.filename
            end,
            style = function(buffer)
                return ((buffer.is_focused and buffer.diagnostics.errors ~= 0)
                    and 'bold,underline')
                    or (buffer.is_focused and 'bold')
                    or (buffer.diagnostics.errors ~= 0 and 'underline')
                    or nil
            end,
            truncation = { priority = 2, },
        },
        {
            text = function(buffer)
                return (buffer.diagnostics.errors ~= 0 and ' ' .. buffer.diagnostics.errors)
                    or (buffer.diagnostics.warnings ~= 0 and ' ' .. buffer.diagnostics.warnings)
                    or ''
            end,
            fg = function(buffer)
                return (buffer.diagnostics.errors ~= 0 and vim.g.terminal_color_1)
                    or (buffer.diagnostics.warnings ~= 0 and vim.g.terminal_color_3)
                    or nil
            end,
            truncation = { priority = 1, },
        },
        {
            text = ' ×',
            delete_buffer_on_left_click = true,
            truncation = { priority = 1, },
        },
        {
            text = '',
            fg = get_hex('ColorColumn', 'bg'),
            bg = get_hex('Normal', 'bg'),
            truncation = { priority = 1, },
        },
    },
}

-- TODO: https://github.com/noib3/nvim-cokeline/issues/56
function delete_curr_buffer()
    local cbn = vim.api.nvim_get_current_buf()
    local buffers = vim.fn.getbufinfo({ buflisted = true })
    local size = 0
    local idx = 0
    for n, e in ipairs(buffers) do
        size = size + 1
        if e.bufnr == cbn then
            idx = n
        end
    end

    if idx == 0 then return end

    if idx == size then
        vim.cmd("bprevious")
    else
        vim.cmd("bnext")
    end
    vim.cmd("bdelete " .. cbn)
end

-- overwrite function in cokeline.setup to force redraw after a bdelete
vim.cmd [[
    function! CokelineHandleCloseButtonClick(minwid, clicks, button, modifiers)
        if a:button != 'l' | return | endif
        execute printf('bdelete %s', a:minwid)
        redraw!
    endfunction
]]
