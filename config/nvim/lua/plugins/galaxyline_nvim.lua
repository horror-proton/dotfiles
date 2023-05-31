local status_ok, galaxyline = pcall(require, 'galaxyline')
if not status_ok then
    return
end

local colors = require('galaxyline.theme').default
local condition = require('galaxyline.condition')

galaxyline.short_line_list = { 'NvimTree', 'packer', 'lspsagaoutline', 'toggleterm' }

galaxyline.section.left[1] = {
    RainbowRed = {
        provider = function()
            return '▊'
        end,
        highlight = { colors.blue, colors.bg },
    },
}

galaxyline.section.left[2] = {
    LinePercent = {
        provider = function()
            return string.format("↕%5s", require('galaxyline.provider_fileinfo').current_line_percent())
        end,
        highlight = { colors.violet, 'NONE' },
    },
}

galaxyline.section.left[3] = {
    GitBranch = {
        provider = 'GitBranch',
        condition = condition.check_git_workspace,
        icon = '   ',
        highlight = { colors.darkblue, colors.violet },
        separator = '█',
        separator_highlight = { colors.violet, colors.darkblue },
    },
}

galaxyline.section.left[4] = {
    FileIcon = {
        provider = 'FileIcon',
        condition = condition.buffer_not_empty,
        highlight = { require('galaxyline.provider_fileinfo').get_file_icon_color, colors.darkblue },
        icon = ' ',
    },
}

galaxyline.section.left[5] = {
    FileName = {
        provider = function() return require('galaxyline.provider_fileinfo').get_current_file_name('', '') end,
        condition = condition.buffer_not_empty,
        highlight = { require('galaxyline.provider_fileinfo').get_file_icon_color, colors.darkblue },
        separator = '',
        separator_highlight = { colors.bg, colors.darkblue },
    },
}

galaxyline.section.left[6] = {
    LineColumn = {
        provider = 'LineColumn',
        highlight = { colors.yellow, colors.bg },
    },
}

galaxyline.section.left[7] = {
    DiagnosticError = {
        provider = 'DiagnosticError',
        icon = '  ',
        highlight = { colors.red, colors.bg },
    },
}

galaxyline.section.left[8] = {
    DiagnosticWarn = {
        provider = 'DiagnosticWarn',
        icon = '  ',
        highlight = { colors.yellow, colors.bg },
    },
}

galaxyline.section.left[9] = {
    DiagnosticHint = {
        icon = '  ',
        provider = 'DiagnosticHint',
        highlight = { colors.cyan, colors.bg },
    },
}

galaxyline.section.left[10] = {
    DiagnosticInfo = {
        icon = '  ',
        provider = 'DiagnosticInfo',
        highlight = { colors.blue, colors.bg },
    },
}

galaxyline.section.mid[3] = {
    GetLspClient = {
        provider = 'GetLspClient',
        highlight = { colors.green, colors.bg },
    },
}

galaxyline.section.mid[1] = {
    WhiteSpace = {
        provider = 'WhiteSpace',
        highlight = { colors.bg, colors.bg },
    },
}

galaxyline.section.right[1] = {
    DiffAdd = {
        provider = 'DiffAdd',
        condition = condition.hide_in_width,
        icon = '  ',
        highlight = { colors.green },
    },
}

galaxyline.section.right[2] = {
    DiffModified = {
        provider = 'DiffModified',
        condition = condition.hide_in_width,
        icon = '  ',
        highlight = { colors.blue },
    },
}

galaxyline.section.right[3] = {
    DiffRemove = {
        provider = 'DiffRemove',
        condition = condition.hide_in_width,
        icon = '  ',
        highlight = { colors.red },
    },
}

galaxyline.section.right[4] = {
    FileFormat = {
        provider = function()
            local fmt = vim.bo.fileformat
            return fmt == 'unix' and ' LF '
                or fmt == 'dos' and ' CRLF '
                or fmt == 'mac' and ' CR '
                or fmt
        end,
        icon = ' ',
        condition = condition.hide_in_width,
        highlight = { colors.blue, colors.bg },
    },
}

galaxyline.section.right[5] = {
    FileEncode = {
        provider = 'FileEncode',
        icon = '',
        condition = condition.hide_in_width,
        highlight = { colors.blue, colors.bg },
    },
}

galaxyline.section.right[6] = {
    FileSize = {
        provider = 'FileSize',
        highlight = { colors.violet, 'NONE' },
        icon = ' 󰋊 ',
        separator = ' ',
        separator_highlight = { 'NONE', colors.darkblue },
    },
}

galaxyline.section.right[7] = {
    RainbowBlue = {
        provider = function()
            return ' ▊'
        end,
        highlight = { colors.blue, colors.bg },
    },
}

vim.api.nvim_set_hl(0, 'StatusLine', { bg = colors.bg, })
