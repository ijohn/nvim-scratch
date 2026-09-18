vim.keymap.set('n', 'gd', vim.lsp.buf.definition, { desc = "Go to definition" })
vim.keymap.set("n", "<leader>f", function()
    local has_biome = #vim.lsp.get_clients({
        bufnr = 0,
        name = "biome",
        method = "textDocument/formatting",
    }) > 0

    vim.lsp.buf.format({
        name = has_biome and "biome" or nil,
        timeout_ms = 3000,
    })
end, { desc = "Format Local buffer" })
vim.keymap.set("n", "df", vim.diagnostic.open_float, { desc = "Show line diagnostics" })

vim.diagnostic.config({ virtual_text = true })

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = vim.tbl_deep_extend("force", capabilities, require("mini.completion").get_lsp_capabilities())

vim.lsp.config("*", { capabilities = capabilities })

vim.lsp.config("lua_ls", {
    settings = {
        Lua = {
            diagnostics = { globals = { "vim" } },
        },
    },
})

vim.lsp.enable({
    "lua_ls",
    "biome",
    "tsc",
    "gopls",
    "rust-analyzer",
    "ty",
    "ruff",
})
