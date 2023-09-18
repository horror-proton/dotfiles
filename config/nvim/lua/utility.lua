local M = {}

---@diagnostic disable-next-line: deprecated
M.uv    = vim.fn.has("nvim-0.10.0") and vim.uv or vim.loop

M.kmap  = function(mode, lhs, rhs, opts)
    if (type(lhs) == 'string') then
        return vim.keymap.set(mode, lhs, rhs, opts)
    end
    for _, v in ipairs(lhs) do
        vim.keymap.set(mode, v, rhs, opts)
    end
end

return M
