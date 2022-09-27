require('nvim-tree').setup {
    open_on_setup = true,
    open_on_tab = true,
    git = {
        ignore = false,
    },
    renderer = {
        indent_markers = { enable = true },
        icons = { git_placement = 'after' },
    },
}
