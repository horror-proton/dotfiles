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
            vim.cmd([[colorscheme tokyonight-night]])
        end,
    },

    {
        'rcarriga/nvim-notify',
        priority = 1000,
        config = function()
            require('notify').setup {
                stages = 'fade_in_slide_out',
                background_colour = 'FloatShadow',
                timeout = 3000,
            }
            vim.notify = require('notify')
        end
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
        build = "make install_jsregexp",
        config = function()
            -- require('plugins.luasnip') -- run in plugins/nvim-lspconfig.lua
        end,
    },

    { 'hrsh7th/cmp-omni' },

    {
        'p00f/clangd_extensions.nvim',
        -- configured in plugins/nvim-lspconfig.lua
    },

    {
        'simrat39/rust-tools.nvim',
        config = function() require('plugins.rust-tools_nvim') end,
    },

    {
        'mfussenegger/nvim-dap',
        config = function()
            local dap = require('dap')

            dap.adapters.lldb = {
                type = 'executable',
                command = '/usr/bin/lldb-vscode',
                name = 'lldb',
            }

            dap.configurations.cpp = {
                {
                    name = 'Launch',
                    type = 'lldb',
                    request = 'launch',
                    program = function()
                        return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
                    end,
                    cwd = '${workspaceFolder}',
                    stopOnEntry = false,
                    args = {},
                },
            }

            dap.configurations.c = dap.configurations.cpp
            dap.configurations.rust = dap.configurations.cpp


            local kmap = require('utility').kmap;

            kmap('n', '<leader><F10>', function() require('dap').continue() end, { desc = 'Debug Continue' })
            kmap('n', { '<F7>', '<leader>di' }, function() require('dap').step_into() end, { desc = 'Step Into' })
            kmap('n', { '<F8>', '<leader>do' }, function() require('dap').step_out() end, { desc = 'Step Out' })
            kmap('n', { '<F20>', '<leader>dv' }, function() require('dap').step_over() end, { desc = 'Step Over' }) -- Shift + f8
            kmap('n', { '<M-(>', '<leader>dc' }, function() require('dap').run_to_cursor() end)                     -- Alt + Shift + 9
            kmap('n', { '<F32>', '<leader>b' }, function() require('dap').toggle_breakpoint() end,
                { desc = 'Toggle Break' })
            kmap({ 'n', 'v' }, '<leader>dh', function() require('dap.ui.widgets').hover() end)
            kmap({ 'n', 'v' }, '<leader>dp', function() require('dap.ui.widgets').preview() end)
            kmap({ 'n', 'v' }, '<leader>df', function()
                local widgets = require('dap.ui.widgets')
                widgets.centered_float(widgets.frames)
            end)
        end,
    },

    {
        "rcarriga/nvim-dap-ui",
        dependencies = { "mfussenegger/nvim-dap", "nvim-neotest/nvim-nio" },
        config = function()
            require('dapui').setup()

            vim.keymap.set('n', '<leader>dd', function()
                require('dapui').toggle()
            end)
        end,
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
                ensure_installed = { "lua", "cpp", "rust", "python" },
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
        'elkowar/yuck.vim'
    },

    {
        'nvim-lua/lsp-status.nvim',
    },

    {
        'lewis6991/gitsigns.nvim',
        config = function()
            require('gitsigns').setup({
                numhl = true,
                linehl = true,
                on_attach = function(bufnr)
                    local gitsigns = require('gitsigns')

                    local function map(mode, l, r, opts)
                        opts = opts or {}
                        opts.buffer = bufnr
                        vim.keymap.set(mode, l, r, opts)
                    end

                    map('n', ']c', function()
                        if vim.wo.diff then
                            vim.cmd.normal({ ']c', bang = true })
                        else
                            gitsigns.nav_hunk('next')
                        end
                    end)

                    map('n', '[c', function()
                        if vim.wo.diff then
                            vim.cmd.normal({ '[c', bang = true })
                        else
                            gitsigns.nav_hunk('prev')
                        end
                    end)

                    map('n', '<leader>tb', gitsigns.toggle_current_line_blame)
                    map('n', '<leader>hd', gitsigns.diffthis)
                    map('n', '<leader>hD', function() gitsigns.diffthis('~') end)
                    map('n', '<leader>td', gitsigns.toggle_deleted)
                end,
            })
        end,
    },

    {
        "dstein64/nvim-scrollview",
        config = function()
            require('scrollview').setup({
                excluded_filetypes = { 'NvimTree' },
                current_only = true,
                winblend = 75,
                base = 'right',
                signs_on_startup = { 'all' },
                diagnostics_severities = { vim.diagnostic.severity.ERROR }
            })
        end,
    },

    { 'github/copilot.vim' },

    { 'nvim-tree/nvim-web-devicons' },

    {
        'nvim-tree/nvim-tree.lua',
        tag = 'nightly',
        config = function() require('plugins.nvim-tree') end,
        enabled = false,
    },

    {
        'nvim-neo-tree/neo-tree.nvim',
        dependencies = {
            "nvim-lua/plenary.nvim",
            "MunifTanjim/nui.nvim",
        },
        config = function()
            require('neo-tree').setup({
                source_selector = {
                    winbar = true,
                    statusline = false,
                },
                filesystem = {
                    filtered_items = {
                        visible = true,
                        hide_dotfiles = false,
                        hide_gitignored = false,
                    }
                }
            })

            vim.keymap.set("n", "<leader>t", function()
                vim.cmd([[:Neotree toggle]])
            end)
        end
    },

    {
        'rebelot/heirline.nvim',
        config = function()
            require('plugins.heirline-nvim')
        end
    },

    {
        'willothy/nvim-cokeline',
        config = function() require('plugins.nvim-cokeline') end,
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-tree/nvim-web-devicons",
        },
    },

    {
        'nvim-telescope/telescope.nvim',
        dependencies = { 'nvim-lua/plenary.nvim' },
        config = function()
            local builtin = require('telescope.builtin')
            vim.keymap.set("n", "<A-x>", function()
                builtin.commands(require("telescope.themes").get_ivy({
                    winblend = 5,
                    previewer = false,
                }))
            end, { desc = "[/keys] execute keymaps or functions]" })

            vim.keymap.set("n", "<leader>ff", builtin.find_files, { desc = "Find files" })
            vim.keymap.set('n', '<leader>fg', builtin.live_grep, { desc = "Live grep" })
            vim.keymap.set('n', '<leader>fb', builtin.buffers, { desc = "Buffers" })
            vim.keymap.set('n', '<leader>fh', builtin.help_tags, { desc = "Help tags" })
        end
    },

    {
        "akinsho/toggleterm.nvim",
        version = "*",
        config = true,
    },

    {
        'folke/which-key.nvim',
        event = 'VeryLazy',
        init = function()
            vim.o.timeout = true
            vim.o.timeoutlen = 300
        end,
        opts = {
        },
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
