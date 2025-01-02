---Splits the given string into an array of lines.
---@param str string
---@return table
local function lines(str)
    local result = {}
    for line in str:gmatch("[^\n]+") do
        table.insert(result, line)
    end
    return result
end

local HEIGHT_RATIO = 0.8
local WIDTH_RATIO = 0.8
local MIN_WIDTH = 60

local function open_git_graph_window()
    -- buflisted = false, scratch = true
    local bufnr = vim.api.nvim_create_buf(false, true)

    -- Limit the output to 1000 commits (cos otherwise it'd load every single commit in the history...)
    -- TODO: in future make it lazy load once first ones loaded?
    local gitgraph = vim.api.nvim_exec2("Git lgb -1000", { output = true }).output
    vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, lines(gitgraph))

    -- Basic syntax highlighting
    -- TODO: custom highlighting
    vim.bo[bufnr].filetype = "git"
    -- Don't allow editing the graph (this must be set *after* we write the lines to the buffer)
    vim.bo[bufnr].modifiable = false

    -- dimens of the entire editor window
    local screen_w = vim.opt.columns:get()
    local screen_h = vim.opt.lines:get() - vim.opt.cmdheight:get()

    -- dimens of the floating window
    local window_w = screen_w * WIDTH_RATIO
    -- don't go smaller than the min width ...
    window_w = math.max(window_w, MIN_WIDTH)
    -- ... but also not larger than the screen
    window_w = math.min(window_w, screen_w - 2)
    local window_h = screen_h * HEIGHT_RATIO
    window_w = math.floor(window_w)
    window_h = math.floor(window_h)

    -- offset of the floating window, such that it is centered on the screen
    local offset_x = (screen_w - window_w) / 2
    local offset_y = ((vim.opt.lines:get() - window_h) / 2) - vim.opt.cmdheight:get()

    local window_opts = {
        relative = "editor",
        width = window_w,
        height = window_h,
        row = offset_y,
        col = offset_x,
        border = "single",
        title = "Git Graph",
        anchor = "NW",
    }

    local window_id = vim.api.nvim_open_win(bufnr, true, window_opts)

    local function close_window()
        vim.api.nvim_win_close(window_id, true)
    end

    -- Set keymaps to close window
    vim.keymap.set("n", "q", close_window, { buffer = bufnr })
    vim.keymap.set("n", "<Esc>", close_window, { buffer = bufnr })

    -- Close window automatically on leave
    vim.api.nvim_create_autocmd("BufLeave", {
        group = vim.api.nvim_create_augroup("GitGraphFloatingWindow", { clear = true }),
        buffer = bufnr,
        once = true,
        callback = close_window,
    })
end

vim.keymap.set("n", "<leader>gg", open_git_graph_window, { desc = "[G]it [G]raph" })
