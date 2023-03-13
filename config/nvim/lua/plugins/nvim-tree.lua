require('nvim-tree').setup {
    open_on_tab = true,
    git = {
        ignore = false,
    },
    renderer = {
        indent_markers = { enable = true },
        icons = { git_placement = 'after' },
    },
}

vim.keymap.set('n', '<C-t>', ':NvimTreeToggle<CR>')
