local get_hex = require('cokeline.hlgroups').get_hl_attr
local Buffer  = require('cokeline.buffers').Buffer

---@param buffer Buffer
local tab_bg  = function(buffer)
    return buffer.is_focused and get_hex('TabLineSel', 'bg') or get_hex('Tabline', 'bg')
end

---@param buffer Buffer
local tab_fg  = function(buffer)
    return buffer.is_focused and get_hex('TabLineSel', 'fg') or get_hex('Tabline', 'fg')
end

local line_bg = function(_) return get_hex('TabLineFill', 'bg') end
local line_fg = function(_) return get_hex('TabLineFill', 'fg') end

---@param buffer Buffer
local click   = function(_, _, buttons, modifiers, buffer)
    if buttons == 'm' and modifiers == '    ' then
        buffer:delete()
    elseif buttons == 'l' then -- require('cokeline.handlers').default_click()
        if vim.bo.buftype == '' then
            vim.api.nvim_set_current_buf(buffer.number)
            return
        end
        for _, w in ipairs(vim.api.nvim_list_wins()) do
            local bufnr = vim.api.nvim_win_get_buf(w)
            if vim.bo[bufnr].buftype == '' then
                vim.api.nvim_set_current_win(w)
                vim.api.nvim_set_current_buf(buffer.number)
                return
            end
        end
        -- vim.cmd.split({ mods = { vertical = true } })
    end
end


require('cokeline').setup {
    fill_hl = 'TabLineFill',
    default_hl = {
        fg = tab_fg,
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
                fg = line_fg,
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
            ---@param buffer Buffer
            text = function(buffer)
                return buffer.devicon.icon
            end,
            ---@param buffer Buffer
            fg = function(buffer)
                return buffer.devicon.color
            end,
            on_click = click,
            truncation = { priority = 1, },
        },
        {
            ---@param buffer Buffer
            text = function(buffer)
                return buffer.unique_prefix .. buffer.filename
            end,
            ---@param buffer Buffer
            style = function(buffer)
                return ((buffer.is_focused and buffer.diagnostics.errors ~= 0)
                        and 'bold,underline')
                    or (buffer.is_focused and 'bold')
                    or (buffer.diagnostics.errors ~= 0 and 'underline')
                    or nil
            end,
            bold = function(buffer) return buffer.is_focused end,
            on_click = click,
            truncation = { priority = 2, },
        },
        {
            ---@param buffer Buffer
            text = function(buffer)
                return (buffer.diagnostics.errors ~= 0 and '⮾ ' .. buffer.diagnostics.errors) -- 
                    or (buffer.diagnostics.warnings ~= 0 and '⚠ ' .. buffer.diagnostics.warnings) -- 
                    or ' '
            end,
            ---@param buffer Buffer
            fg = function(buffer)
                return (buffer.diagnostics.errors ~= 0 and vim.g.terminal_color_1)
                    or (buffer.diagnostics.warnings ~= 0 and vim.g.terminal_color_3)
                    or nil
            end,
            on_click = click,
            truncation = { priority = 1, },
        },
        {
            ---@param buffer Buffer
            text = function(buffer) return buffer.is_modified and '+' or '×' end,
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
