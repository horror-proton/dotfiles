local heirline = require('heirline')
local utils = require('heirline.utils')
local conditions = require('heirline.conditions')

local function setup_colors()
    return {
        bright_bg = utils.get_highlight("Folded").bg,
        bright_fg = utils.get_highlight("Folded").fg,
        red = utils.get_highlight("DiagnosticError").fg,
        dark_red = utils.get_highlight("DiffDelete").bg,
        green = utils.get_highlight("String").fg,
        blue = utils.get_highlight("Function").fg,
        gray = utils.get_highlight("NonText").fg,
        orange = utils.get_highlight("Constant").fg,
        purple = utils.get_highlight("Statement").fg,
        cyan = utils.get_highlight("Special").fg,
        dir_fg = utils.get_highlight("Directory").fg,
    }
end

vim.api.nvim_create_augroup("Heirline", { clear = true })
vim.api.nvim_create_autocmd("ColorScheme", {
    callback = function()
        utils.on_colorscheme(setup_colors)
    end,
    group = "Heirline",
})

---@diagnostic disable: missing-fields

---@class StatusLine
---@field devicon string
---@field devicon_color string

local Space = { provider = ' ' }
local Align = { provider = "%=" }

local Percentage = {
    provider = '   %P',
    hl = 'CursorLineSign'
}

local ViMode = utils.surround({ "", "" }, "bright_bg",
    {
        init = function(self)
            self.mode = vim.fn.mode(1)
        end,
        provider = function(self)
            return self.mode
        end,
        update = {
            'ModeChanged'
        },
        hl = {
            bg = 'bright_bg',
            fg = 'green',
        },
    }
)

---@type StatusLine
local DevIcon = {
    init = function(self)
        local ftype = vim.bo.filetype
        self.devicon, self.devicon_color =
            require('nvim-web-devicons').get_icon_color_by_filetype(ftype, { default = true })
    end,
    provider = function(self)
        return self.devicon
    end,
    hl = function(self)
        return { fg = self.devicon_color, }
    end,
}

local FileName = {
    provider = function()
        local filename = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(0), ":.")
        if not conditions.width_percent_below(#filename, 0.25) then
            filename = vim.fn.pathshorten(filename)
        end
        return filename .. " :%l :%c %m%r%h%q"
    end,
    hl = { fg = 'dir_fg', bold = true },
}

---@type StatusLine
local FileEncoding = {
    provider = function()
        local enc = (vim.bo.fenc ~= '' and vim.bo.fenc) or vim.o.enc -- :h 'enc'
        -- return enc ~= 'utf-8' and enc:upper()
        return enc:upper()
    end
}

local LSPActive = {
    condition = conditions.lsp_attached,
    update = { 'LspAttach', 'LspDetach' },

    provider = function()
        local names = {}
        for _, server in pairs(vim.lsp.get_clients({ bufnr = 0 })) do
            table.insert(names, server.name)
        end
        return " [" .. table.concat(names, ", ") .. "]"
    end,
    hl = { fg = "green", bold = true },
}

local DefaultStatusline = {
    Percentage,
    Space,
    ViMode,
    Space,
    DevIcon,
    Space,
    FileName,
    Align,
    LSPActive,
    Align,
    FileEncoding,
}

local TerminalName = {
    provider = function()
        local tname, _ = vim.api.nvim_buf_get_name(0) --:gsub(".*:", "")
        return " " .. tname
    end,
    hl = { fg = "blue", bold = true },
}

local SpecialStatusline = {
    condition = function()
        return conditions.buffer_matches({
            buftype = { "nofile", "prompt", "help", "quickfix" },
            filetype = { "^git.*", "fugitive" },
        })
    end,

    { provider = '%y' },
    Space,
    { provider = '%f' },
    Align
}

local TerminalStatusline = {
    condition = function()
        return conditions.buffer_matches({ buftype = { "terminal" } })
    end,

    ViMode,
    Space,
    { provider = "%y" },
    Space,
    TerminalName,
    Align,
}


heirline.setup({
    opts = {
        colors = setup_colors(),
    },
    statusline = {
        fallthrough = false,
        SpecialStatusline,
        TerminalStatusline,
        DefaultStatusline,
    },
})
