# git-graph.nvim

Usage:

```lua
return {
    {
        "martin-walls/git-graph.nvim",
        config = function()
            vim.keymap.set("n", "<leader>gg", require("git-graph").git_graph)
        end,
    },
}
```
