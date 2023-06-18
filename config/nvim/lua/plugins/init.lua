-- Plugin spec for lazy.nvim
return {

    {
        'shaunsingh/nord.nvim',
        enabled = false,
        lazy = false,
        priority = 1000,
        config = function()
            -- vim.cmd([[colorscheme nord]])
        end,
    },

    {
        "folke/tokyonight.nvim",
        lazy = false,
        priority = 1000,
        config = function()
            vim.cmd([[colorscheme tokyonight]])
        end,
    },

    {
        "windwp/nvim-autopairs",
        config = function() require('plugins.nvim-autopairs') end,
    },

    {
        "kylechui/nvim-surround",
        config = true,
    },

    {
        'SirVer/ultisnips',
        config = function()
            vim.cmd [[syntax enable]]
            vim.g.syntax = true
            vim.g.UltiSnipsExpandTrigger = "<tab>"
            vim.g.UltiSnipsJumpForwardTrigger = "<tab>"
            vim.g.UltiSnipsJumpBackwardTrigger = "<s-tab>"
            vim.g.UltiSnipsEditSplit = "vertical"
        end,
    },

    {
        'neovim/nvim-lspconfig',
        config = function() require('plugins.nvim-lspconfig') end,
        dependencies = {
            'hrsh7th/nvim-cmp',
            'hrsh7th/cmp-nvim-lsp',
            'saadparwaiz1/cmp_luasnip',
            'hrsh7th/cmp-omni',
            'onsails/lspkind.nvim'
        },
    },

    {
        'hrsh7th/nvim-cmp',
        config = function()
            -- configured in plugins.nvim-lspconfig
        end,
    },

    {
        'onsails/lspkind.nvim',
    },

    { 'hrsh7th/cmp-nvim-lsp' },     -- LSP source for nvim-cmp

    { 'saadparwaiz1/cmp_luasnip' }, -- Snippets source for nvim-cmp

    {
        'L3MON4D3/LuaSnip',
        config = function()
            -- require('plugins.luasnip') -- run in plugins/nvim-lspconfig.lua
        end,
    },

    { 'hrsh7th/cmp-omni' },

    {
        'p00f/clangd_extensions.nvim'
        -- configured in plugins/nvim-lspconfig.lua
    },

    {
        'simrat39/rust-tools.nvim',
        config = function() require('plugins.rust-tools_nvim') end,
    },

    {
        "iamcco/markdown-preview.nvim",
        build = function() vim.fn["mkdp#util#install"]() end,
    },

    {
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
    },

    {
        "glepnir/lspsaga.nvim",
        branch = "main",
        config = function() require('plugins.lspsaga_nvim') end,
    },

    -- ref: https://www.ejmastnak.com/tutorials/vim-latex/intro/
    {
        'lervag/vimtex',
        config = function()
            vim.cmd [[syntax enable]]
            vim.g.syntax = true
            vim.g.vimtex_syntax_conceal = { math_bounds = 0 }
            vim.g.vimtex_view_method = 'general'
        end,
    },

    {
        'nvim-lua/lsp-status.nvim',
    },

    {
        'lewis6991/gitsigns.nvim',
        config = true,
    },

    { 'github/copilot.vim' },

    { 'kyazdani42/nvim-web-devicons' },

    {
        'kyazdani42/nvim-tree.lua',
        tag = 'nightly',
        config = function() require('plugins.nvim-tree') end,
    },

    {
        'glepnir/galaxyline.nvim',
        branch = 'main',
        config = function() require('plugins.galaxyline_nvim') end,
    },

    {
        'noib3/nvim-cokeline',
        config = function() require('plugins.nvim-cokeline') end,
    },

    {
        "akinsho/toggleterm.nvim",
        version = "*",
        config = true,
    },

    {
        'edluffy/specs.nvim',
        enabled = false,
        config = function()
            require('specs').setup {
                show_jumps       = true,
                min_jump         = 2,
                popup            = {
                    delay_ms = 0, -- delay before popup displays
                    inc_ms = 10,  -- time increments used for fade/resize effects
                    blend = 10,   -- starting blend, between 0-100 (fully transparent), see :h winblend
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
        end,
    },

}
