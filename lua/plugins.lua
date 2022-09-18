vim.cmd [[packadd packer.nvim]]

return require('packer').startup(function(use)
    
    use 'rstacruz/vim-closer'

    use {
        'shaunsingh/nord.nvim',
        config = function()
            vim.cmd[[colorscheme nord]]
        end
    }

    use {
        'SirVer/ultisnips',
        config = function()
            vim.cmd[[syntax enable]]
            vim.g.syntax = true
            vim.g.UltiSnipsExpandTrigger="<tab>"
            vim.g.UltiSnipsJumpForwardTrigger="<tab>"
            vim.g.UltiSnipsJumpBackwardTrigger="<s-tab>"
            vim.g.UltiSnipsEditSplit="vertical"
        end
    }

    -- ref: https://ejmastnak.github.io/tutorials/vim-latex/intro.html
    use {
        'lervag/vimtex',
        config = function()
            vim.cmd[[syntax enable]]
            vim.g.syntax = true
            vim.g.vimtex_syntax_conceal={math_bounds=0}
            vim.g.vimtex_view_method='general'
        end
    }

end)

