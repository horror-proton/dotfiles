local get_hex    = require('cokeline/utils').get_hex

local tab_bg     = get_hex('FloatShadow', 'bg');
local tab_sel_bg = get_hex('Normal', 'bg');

local line_bg    = get_hex('Tabline', 'bg')

local click      = function(_, _, buttons, modifiers, buffer)
    if buttons == 'm' and modifiers == '    ' then
        buffer:delete()
    elseif buttons == 'l' then -- require('cokeline.handlers').default_click()
        if vim.api.nvim_buf_get_option(0, 'buftype') == '' then
            vim.api.nvim_set_current_buf(buffer.number)
            return
        end
        for _, w in ipairs(vim.api.nvim_list_wins()) do
            local buf = vim.api.nvim_win_get_buf(w)
            if vim.api.nvim_buf_get_option(buf, 'buftype') == '' then
                vim.api.nvim_set_current_win(w)
                vim.api.nvim_set_current_buf(buffer.number)
                return
            end
        end
        -- vim.cmd.split({ mods = { vertical = true } })
    end
end


require('cokeline').setup {
    default_hl = {
        fg = function(buffer)
            return buffer.is_focused and get_hex('TablineFill', 'fg') or get_hex('Tabline', 'fg')
        end,
        bg = tab_bg,
    },
    sidebar = {
        filetype = { 'NvimTree', 'neo-tree' },
        components = {
            {
                text = function(buf)
                    return buf.filetype
                end,
                bg = get_hex('NvimTreeNormal', 'bg'),
            },
        }
    },
    buffers = {
        -- focus_on_delete = 'next',
    },
    components = {
        {
            text = function(buffer) return ((buffer.index ~= 1) and '-' or ' ') .. '' end, --┃
            fg = tab_bg,
            bg = line_bg,
            on_click = nil,
            truncation = { priority = 1, },
        },
        {
            text = function(buffer)
                return buffer.devicon.icon
            end,
            fg = function(buffer)
                return buffer.devicon.color
            end,
            on_click = click,
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
            on_click = click,
            truncation = { priority = 2, },
        },
        {
            text = function(buffer)
                return (buffer.diagnostics.errors ~= 0 and '⮾ ' .. buffer.diagnostics.errors) -- 
                    or (buffer.diagnostics.warnings ~= 0 and '⚠ ' .. buffer.diagnostics.warnings) -- 
                    or ' '
            end,
            fg = function(buffer)
                return (buffer.diagnostics.errors ~= 0 and vim.g.terminal_color_1)
                    or (buffer.diagnostics.warnings ~= 0 and vim.g.terminal_color_3)
                    or nil
            end,
            on_click = click,
            truncation = { priority = 1, },
        },
        {
            text = '×',
            delete_buffer_on_left_click = true,
            truncation = { priority = 1, },
        },
        {
            text = '',
            fg = tab_bg,
            bg = line_bg,
            on_click = nil,
            truncation = { priority = 1, },
        },
    },
}
