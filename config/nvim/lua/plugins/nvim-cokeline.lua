local get_hex    = require('cokeline/utils').get_hex

local tab_bg     = get_hex('FloatShadow', 'bg');
local tab_sel_bg = get_hex('Normal', 'bg');

local line_bg    = get_hex('Tabline', 'bg')

require('cokeline').setup {
    default_hl = {
        fg = function(buffer)
            return buffer.is_focused and get_hex('TablineFill', 'fg') or get_hex('Tabline', 'fg')
        end,
        bg = tab_bg,
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
            text = function(buffer) return ((buffer.index ~= 1) and '┃' or ' ') .. '' end,
            fg = tab_bg,
            bg = line_bg,
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
                return buffer.filename .. ' '
            end,
            style = function(buffer)
                return ((buffer.is_focused and buffer.diagnostics.errors ~= 0)
                        and 'bold,underline')
                    or (buffer.is_focused and 'bold')
                    or (buffer.diagnostics.errors ~= 0 and 'underline')
                    or nil
            end,
            on_click = function(_, _, buttons, modifiers, buffer)
                if buttons == 'm' and modifiers == '    ' then
                    buffer:delete()
                elseif buttons == 'l' then -- require('cokeline.handlers').default_click()
                    vim.api.nvim_set_current_buf(buffer.number)
                end
            end,
            truncation = { priority = 2, },
        },
        {
            text = function(buffer)
                return (buffer.diagnostics.errors ~= 0 and '⮾ ' .. buffer.diagnostics.errors)   -- 
                    or (buffer.diagnostics.warnings ~= 0 and '⚠ ' .. buffer.diagnostics.warnings) -- 
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
            text = '×',
            delete_buffer_on_left_click = true,
            truncation = { priority = 1, },
        },
        {
            text = '',
            fg = tab_bg,
            bg = line_bg,
            truncation = { priority = 1, },
        },
    },
}
