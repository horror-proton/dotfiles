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
    }
end

local colors = setup_colors()

vim.api.nvim_create_augroup("Heirline", { clear = true })
vim.api.nvim_create_autocmd("ColorScheme", {
    callback = function()
        utils.on_colorscheme(setup_colors)
    end,
    group = "Heirline",
})


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
            fg = 'bright_fg',
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
    provider = "%f :%l :%c %m%r%h%y%q",
    hl = 'Title',
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


heirline.setup({
    opts = {
        colors = colors,
    },
    statusline = {
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
    },
})
