-- Mappings.
-- See `:help vim.diagnostic.*` for documentation on any of the below functions
local opts = { noremap = true, silent = true }
vim.keymap.set('n', '<space>e', vim.diagnostic.open_float, opts)
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts)
vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist, opts)

vim.api.nvim_create_autocmd('LspAttach', {
    group = vim.api.nvim_create_augroup('UserLspConfig', {}),
    callback = function(ev)
        -- Enable completion triggered by <c-x><c-o>
        vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'
        -- Buffer local mappings.
        -- See `:help vim.lsp.*` for documentation on any of the below functions
        local bufopts = { noremap = true, silent = true, buffer = ev.buf }
        vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, bufopts)
        vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts)
        vim.keymap.set('n', 'K', vim.lsp.buf.hover, bufopts)
        vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, bufopts)
        vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, bufopts)
        vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, bufopts)
        vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, bufopts)
        vim.keymap.set('n', '<space>wl', function()
            print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
        end, opts)
        vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, bufopts)
        vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, bufopts)
        vim.keymap.set({ 'n', 'v' }, '<space>ca', vim.lsp.buf.code_action, bufopts)
        vim.keymap.set('n', 'gr', vim.lsp.buf.references, bufopts)
        vim.keymap.set('n', '<space>f', vim.lsp.buf.format, bufopts)
        vim.keymap.set({ 'n', 'i' }, '<M-C-L>', vim.lsp.buf.format, bufopts)
    end
})

local lspconfig = require('lspconfig')

-- luasnip setup
require('plugins.luasnip')

-- nvim-cmp setup
local cmp = require 'cmp'
if cmp then
    local luasnip = require 'luasnip'
    cmp.setup {
        snippet = {
            expand = function(args)
                luasnip.lsp_expand(args.body)
            end,
        },
        preselect = cmp.PreselectMode.Item,
        window = {
            -- completion = cmp.config.window.bordered(),
            documentation = cmp.config.window.bordered(),
        },
        mapping = cmp.mapping.preset.insert({
            ['<C-d>'] = cmp.mapping.scroll_docs(-4),
            ['<C-f>'] = cmp.mapping.scroll_docs(4),
            ['<S-Tab>'] = cmp.mapping.complete(),
            ['<Tab>'] = cmp.mapping(function(fallback)
                if cmp.visible() then
                    if false then
                        -- if not cmp.get_selected_entry() then
                        cmp.select_next_item({ behavior = cmp.SelectBehavior.Select })
                    else
                        cmp.mapping.confirm {
                            behavior = cmp.ConfirmBehavior.Replace,
                            select = true,
                        } ()
                    end
                elseif luasnip.expand_or_jumpable() then
                    luasnip.expand_or_jump()
                else
                    fallback()
                end
            end, { 'i', 's' }),
            ['<Down>'] = cmp.mapping(function(fallback)
                if cmp.visible() then
                    cmp.select_next_item()
                else
                    fallback()
                end
            end, { 'i', 's' }),
            ['<Up>'] = cmp.mapping(function(fallback)
                if cmp.visible() then
                    cmp.select_prev_item()
                elseif luasnip.jumpable(-1) then
                    luasnip.jump(-1)
                else
                    fallback()
                end
            end, { 'i', 's' }),
        }),
        sources = {
            { name = 'nvim_lsp' },
            { name = 'luasnip' },
            { name = 'omni' }, -- for vimtex
        },
        sorting = {
            comparators = {
                cmp.config.compare.offset,
                cmp.config.compare.exact,
                cmp.config.compare.recently_used,
                require("clangd_extensions.cmp_scores"),
                cmp.config.compare.kind,
                cmp.config.compare.sort_text,
                cmp.config.compare.length,
                cmp.config.compare.order,
            },
        },
    }
end


local attach = function(_) end

-- Add additional capabilities supported by nvim-cmp
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)


-- `paru -S lua-language-server`
local nvim_runtime = vim.api.nvim_list_runtime_paths()
-- in case runtime paths for some plugins hasn't been set yet
if pcall(require, 'lazy') then
    local lazy_root = require("lazy.core.config").options.root
    for dir in vim.fs.dir(lazy_root) do
        table.insert(nvim_runtime, vim.fs.normalize(lazy_root .. '/' .. dir))
    end
end
lspconfig.lua_ls.setup {
    on_attach = attach,
    capabilities = capabilities,
    settings = {
        Lua = {
            runtime = {
                -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
                version = 'LuaJIT',
            },
            hint = {
                enable = true,
            },
            workspace = {
                -- Make the server aware of Neovim runtime files
                library = nvim_runtime,
            },
            -- Do not send telemetry data containing a randomized but unique identifier
            telemetry = {
                enable = false,
            },
        },
    },
}

require("clangd_extensions").setup {
    server = {
        on_attach = attach,
        capabilities = capabilities,
        cmd = {
            "clangd",
            "--background-index",
            "--clang-tidy",
            "--enable-config",
            "--fallback-style=llvm",
            "--all-scopes-completion",
            "--completion-style=detailed",
            "--header-insertion=iwyu",
            "--header-insertion-decorators",
            "--pch-storage=memory",
        },
        -- options to pass to nvim-lspconfig
        -- i.e. the arguments to require("lspconfig").clangd.setup({})
    },
    extensions = {
        -- defaults:
        -- Automatically set inlay hints (type hints)
        autoSetHints = true,
        -- These apply to the default ClangdSetInlayHints command
        inlay_hints = {
            -- Only show inlay hints for the current line
            only_current_line = false,
            -- Event which triggers a refersh of the inlay hints.
            -- You can make this "CursorMoved" or "CursorMoved,CursorMovedI" but
            -- not that this may cause  higher CPU usage.
            -- This option is only respected when only_current_line and
            -- autoSetHints both are true.
            only_current_line_autocmd = "CursorHold",
            -- whether to show parameter hints with the inlay hints or not
            show_parameter_hints = true,
            -- prefix for parameter hints
            parameter_hints_prefix = "<- ",
            -- prefix for all the other hints (type, chaining)
            other_hints_prefix = "=> ",
            -- whether to align to the length of the longest line in the file
            max_len_align = false,
            -- padding from the left if max_len_align is true
            max_len_align_padding = 1,
            -- whether to align to the extreme right or not
            right_align = false,
            -- padding from the right if right_align is true
            right_align_padding = 7,
            -- The color of the hints
            highlight = "Comment",
            -- The highlight group priority for extmark
            priority = 100,
        },
        ast = {
            role_icons = {
                type = "",
                declaration = "",
                expression = "",
                specifier = "",
                statement = "",
                ["template argument"] = "",
            },
            kind_icons = {
                Compound = "",
                Recovery = "",
                TranslationUnit = "",
                PackExpansion = "",
                TemplateTypeParm = "",
                TemplateTemplateParm = "",
                TemplateParamObject = "",
            },
            highlights = {
                detail = "Comment",
            },
        },
        memory_usage = {
            border = "none",
        },
        symbol_info = {
            border = "none",
        },
    },
}

lspconfig.rust_analyzer.setup {
    on_attach = attach,
    capabilities = capabilities,
    settings = {
        imports = {
            granularity = {
                group = 'module',
            },
            prefix = 'self',
        },
        cargo = {
            buildScripts = {
                enable = true,
            },
        },
        procMacro = {
            enable = true,
        },
    },
}

-- paru -S python-lsp-server
-- paru -S yapf python-whatthepatch python-toml
-- paru -S python-pycodestyle
lspconfig.pylsp.setup {
    on_attach = attach,
    capabilities = capabilities,
    settings = {
        pylsp = {
            plugins = {
                pycodestyle = {
                    maxLineLength = 120
                }
            }
        },
    },
    cmd = { "pylsp", "-v" },
}

-- Enable some language servers with the additional completion capabilities offered by nvim-cmp
local servers = { 'cmake', 'bashls', 'tsserver' }
for _, lsp in ipairs(servers) do
    lspconfig[lsp].setup {
        on_attach = attach,
        capabilities = capabilities,
    }
end
