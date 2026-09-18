vim.keymap.set('n', 'gd', vim.lsp.buf.definition, { desc = "Go to definition" })

local function format_buffer(bufnr)
    local clients = vim.lsp.get_clients({
        bufnr = bufnr,
        method = "textDocument/formatting",
    })

    -- Save normally if no formatter is attached.
    if #clients == 0 then
        return
    end

    local formatter = nil
    for _, client in ipairs(clients) do
        if client.name == "biome" then
            formatter = "biome"
            break
        end
    end

    vim.lsp.buf.format({
        bufnr = bufnr,
        name = formatter,
        async = false,
        timeout_ms = 3000,
    })
end

-- Manual formatting.
vim.keymap.set("n", "<leader>f", function()
    format_buffer(vim.api.nvim_get_current_buf())
end, { desc = "Format local buffer" })

-- Automatic formatting before saving.
vim.api.nvim_create_autocmd("BufWritePre", {
    group = vim.api.nvim_create_augroup("LspFormatOnSave", {
        clear = true,
    }),
    callback = function(args)
        if vim.b[args.buf].autoformat == false then
            return
        end

        format_buffer(args.buf)
    end,
    desc = "Format before saving",
})

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
