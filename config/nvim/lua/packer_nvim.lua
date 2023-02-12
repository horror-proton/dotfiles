vim.cmd [[packadd packer.nvim]]

vim.cmd([[
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost */nvim/lua/*.lua source <afile> | PackerCompile
  augroup end
]])

return require('packer').startup {

    config = {
        git = {
            depth = 100,
        },
    },

    function(use)

        use {
            "windwp/nvim-autopairs",
            config = [[require("plugins.nvim-autopairs")]]
        }

        use {
            "kylechui/nvim-surround",
            config = function()
                require("nvim-surround").setup()
            end
        }

        use {
            'shaunsingh/nord.nvim',
            config = function()
                vim.cmd [[colorscheme nord]]
            end
        }

        use {
            'SirVer/ultisnips',
            config = function()
                vim.cmd [[syntax enable]]
                vim.g.syntax = true
                vim.g.UltiSnipsExpandTrigger = "<tab>"
                vim.g.UltiSnipsJumpForwardTrigger = "<tab>"
                vim.g.UltiSnipsJumpBackwardTrigger = "<s-tab>"
                vim.g.UltiSnipsEditSplit = "vertical"
            end
        }

        use {
            'neovim/nvim-lspconfig',
            config = [[require('plugins.nvim-lspconfig')]],
        }

        use {
            'hrsh7th/nvim-cmp',
            config = function()
                local cmp = require('cmp')
                cmp.setup({
                    preselect = cmp.PreselectMode.Item,
                    window = {
                        -- completion = cmp.config.window.bordered(),
                        documentation = cmp.config.window.bordered(),
                    },
                })
            end,
        }

        use 'hrsh7th/cmp-nvim-lsp' -- LSP source for nvim-cmp
        use 'saadparwaiz1/cmp_luasnip' -- Snippets source for nvim-cmp

        use { 'L3MON4D3/LuaSnip',
            config = [[require('plugins.luasnip')]]
        }

        -- use 'hrsh7th/cmp-omni' -- disabled due to https://github.com/hrsh7th/cmp-omni/issues/8

        use {
            'p00f/clangd_extensions.nvim'
            -- configured in in plugins/nvim-lspconfig.lua
        }

        use {
            'simrat39/rust-tools.nvim',
            config = [[require('plugins.rust-tools_nvim')]],
        }

        use {
            'nvim-treesitter/nvim-treesitter',
            config = function()
                require("nvim-treesitter.install").prefer_git = true
                require 'nvim-treesitter.configs'.setup {
                    ensure_install = { "lua", "cpp", "rust", "python" },
                    sync_install = true,
                    auto_install = false,
                    highlight = {
                        enable = true,
                    },
                }
            end,
        }

        use {
            "glepnir/lspsaga.nvim",
            branch = "main",
            config = [[require('plugins.lspsaga_nvim')]],
        }

        -- ref: https://ejmastnak.github.io/tutorials/vim-latex/intro.html
        use {
            'lervag/vimtex',
            config = function()
                vim.cmd [[syntax enable]]
                vim.g.syntax = true
                vim.g.vimtex_syntax_conceal = { math_bounds = 0 }
                vim.g.vimtex_view_method = 'general'
            end
        }

        use {
            'nvim-lua/lsp-status.nvim',
        }

        use {
            'lewis6991/gitsigns.nvim',
            config = function()
                require('gitsigns').setup()
            end
        }

        use 'kyazdani42/nvim-web-devicons'

        use {
            'kyazdani42/nvim-tree.lua',
            tag = 'nightly',
            config = [[require('plugins.nvim-tree')]],
        }

        use {
            'glepnir/galaxyline.nvim',
            branch = 'main',
            config = [[require('plugins.galaxyline_nvim')]],
            after = 'nord.nvim',
        }

        use {
            'noib3/nvim-cokeline',
            config = [[require('plugins.nvim-cokeline')]],
            after = 'nord.nvim',
        }

        use {
            "akinsho/toggleterm.nvim",
            tag = '*',
            config = function()
                require("toggleterm").setup()
            end
        }

        use {
            'edluffy/specs.nvim',
            config = function()
                require('specs').setup {
                    show_jumps       = true,
                    min_jump         = 2,
                    popup            = {
                        delay_ms = 0, -- delay before popup displays
                        inc_ms = 10, -- time increments used for fade/resize effects
                        blend = 10, -- starting blend, between 0-100 (fully transparent), see :h winblend
                        width = 20,
                        winhl = "PMenu",
                        fader = require('specs').linear_fader,
                        resizer = require('specs').shrink_resizer
                    },
                    ignore_filetypes = {},
                    ignore_buftypes  = {
                        nofile = true,
                    },
                }
            end
        }

    end
}
