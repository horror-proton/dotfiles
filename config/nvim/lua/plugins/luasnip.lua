vim.cmd([[
imap <silent><expr> <Tab> luasnip#expand_or_jumpable() ? '<Plug>luasnip-expand-or-jump' : '<Tab>' 
inoremap <silent> <S-Tab> <cmd>lua require'luasnip'.jump(-1)<Cr>
snoremap <silent> <Tab> <cmd>lua require('luasnip').jump(1)<Cr>
snoremap <silent> <S-Tab> <cmd>lua require('luasnip').jump(-1)<Cr>
imap <silent><expr> <C-E> luasnip#choice_active() ? '<Plug>luasnip-next-choice' : '<C-E>'
smap <silent><expr> <C-E> luasnip#choice_active() ? '<Plug>luasnip-next-choice' : '<C-E>'
]])

local ls = require("luasnip")
local s = ls.snippet
local sn = ls.snippet_node
local isn = ls.indent_snippet_node
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
local c = ls.choice_node
local d = ls.dynamic_node
local r = ls.restore_node
local events = require("luasnip.util.events")
local ai = require("luasnip.nodes.absolute_indexer")
local fmt = require("luasnip.extras.fmt").fmt
local extras = require("luasnip.extras")
local m = extras.m
local l = extras.l
local rep = extras.rep
local postfix = require("luasnip.extras.postfix").postfix

ls.config.setup({ enable_autosnippets = true })

ls.add_snippets("cpp", {
    s("template", {
        t("template"), t("<"), i(1), t(">")
    }),
    s({ trig = "^class ", regTrig = true }, {
        t("class "), i(1), t("{};")
    }),
}, { type = "autosnippets" })

ls.add_snippets("diff", {
    s({ trig = "^(%d+)c", regTrig = true }, {
        f(function(_, snip) return snip.captures[1] .. "c" .. snip.captures[1] end, {}),
        t({ "", "< " }), i(1),
        t({ "", "---" }),
        t({ "", "> " }),
    }),
}, { type = "autosnippets" })
