local M = {}

---@diagnostic disable-next-line: deprecated
M.uv = vim.version().minor >= 10 and vim.uv or vim.loop

return M
