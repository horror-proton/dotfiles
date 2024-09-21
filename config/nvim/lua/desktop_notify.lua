local M = {}

local original_notify = vim.notify

function M.normal_notify()
    vim.notify = function(msg, level, ops)
        -- vim.fn.writefile({ msg }, 'log', 'a')
        original_notify(msg, level, ops)
    end
end

local function notify_send(summary, body, urgency, time)
    local cmdline = { 'notify-send' }

    if urgency ~= nil then
        table.insert(cmdline, '-u')
        table.insert(cmdline, urgency)
    end

    if time ~= nil then
        table.insert(cmdline, '-t')
        table.insert(cmdline, time)
    end

    table.insert(cmdline, summary)
    table.insert(cmdline, body)

    vim.system(cmdline)
end

function M.desktop_notify()
    vim.notify = function(msg, level, ops)
        -- vim.fn.writefile({ msg }, 'log', 'a')
        original_notify(msg, level, ops)

        local summary = vim.opt.titlestring:get()
        if summary == '' then
            summary = 'Neovim'
        end

        if level == vim.log.levels.ERROR then
            notify_send(summary, msg, 'critical', 5000)
        elseif level == vim.log.levels.WARN then
            notify_send(summary, msg, 'normal', 5000)
        elseif level == vim.log.levels.INFO then
            notify_send(summary, msg, 'low', 5000)
        else
            notify_send(summary, msg, 'low', 5000)
        end
    end
end

local session = os.getenv('XDG_SESSION_TYPE')
if session and session ~= 'tty' then
    M.desktop_notify()
else
    M.normal_notify()
end

return M
