vim.pack.add({
    { src = "https://github.com/catppuccin/nvim",                 name = "catppuccin" },
    "https://github.com/nvim-mini/mini.nvim",
    "https://github.com/rafamadriz/friendly-snippets",
    { src = "https://github.com/nvim-treesitter/nvim-treesitter", branch = "main" },
    "https://github.com/neovim/nvim-lspconfig",
    "https://github.com/tpope/vim-fugitive",
    "https://github.com/smart-splits-nvim/smart-splits.nvim",
    "https://github.com/stevearc/conform.nvim",
})

-- mini files ----
local MiniFiles = require("mini.files")
MiniFiles.setup({
    mappings = {
        go_in = "<CR>",
        go_in_plus = "L",
        go_out = "_",
        go_out_plus = "H",
    },
})

vim.keymap.set("n", "-", "<cmd>lua MiniFiles.open()<CR>", { desc = "Toggle mini file explorer" })
vim.keymap.set("n", "<leader>e", function()
    MiniFiles.open(vim.api.nvim_buf_get_name(0), false)
    MiniFiles.reveal_cwd()
end, { desc = "Toggle into currently opened file" })

---- mini notify ----
require("mini.notify").setup({
    -- only show messages
    content = {
        format = function(notif)
            return notif.msg
        end,
    },
})

--- mini cmdline completion ---
require("mini.cmdline").setup({
    autocorrect = { enable = false }
})

--- mini surround ---
require("mini.surround").setup()
-- Default Keymaps
-- | `sa` | Add surrounding or Direct with 'saiw' |
-- | `sd` | Delete surrounding |
-- | `sr` | Replace surrounding |
-- | `sf` | Find surrounding (right) |
-- | `sF` | Find surrounding (left) |
-- | `sh` | Highlight surrounding |
-- | `sn` | Update n_lines |
-- | `l` / `n` | as suffix for prev/next |

--- mini picker ---
local MiniPick = require("mini.pick")
local MiniExtra = require("mini.extra")
MiniPick.setup()
MiniExtra.setup()

-- keymaps
vim.keymap.set("n", "<leader><space>", function() MiniPick.builtin.files() end, { desc = "Mini File Picker" })
vim.keymap.set("n", "<leader>ps", function() MiniPick.builtin.grep({ pattern = vim.fn.expand("<cword>") }) end,
    { desc = "Grep word/Search word" })
vim.keymap.set("n", "<leader>vh", function() MiniPick.builtin.help() end, { desc = "Mini Help" })

vim.keymap.set("n", "<leader>xx", function() MiniExtra.pickers.diagnostic() end, { desc = "Mini Picker Diagnostics" })
vim.keymap.set("n", "<leader>pk", function() MiniExtra.pickers.keymaps() end, { desc = 'Search keymaps' })

--- mini completions ---
require("mini.completion").setup({
    lsp_completion = {
        auto_setup = true,
    }
})

--- mini snippets ---
local MiniSnippets = require("mini.snippets")
MiniSnippets.setup({
    snippets = {
        MiniSnippets.gen_loader.from_lang(), -- loads friendly-snippets
    },
})
MiniSnippets.start_lsp_server({ match = false })

--- mini diff and fugitive ---
local MiniDiff = require("mini.diff")
MiniDiff.setup({
    source = MiniDiff.gen_source.git({ index = false }),
})

vim.keymap.set("n", "<leader>gg", "<cmd>tabnew | Git | only<cr>", { desc = "Fugitive Full Page New Tab" })
vim.keymap.set("n", "<leader>gd", "<cmd>Gvdiffsplit<CR>", { desc = "Git diff split", })

--- smart-splits ---
local SmartSplit = require("smart-splits")
SmartSplit.setup({ at_edge = "stop" })

vim.keymap.set('n', '<C-h>', SmartSplit.move_cursor_left)
vim.keymap.set('n', '<C-j>', SmartSplit.move_cursor_down)
vim.keymap.set('n', '<C-k>', SmartSplit.move_cursor_up)
vim.keymap.set('n', '<C-l>', SmartSplit.move_cursor_right)

--- conform ---
local conform = require("conform")

conform.setup({
    formatters_by_ft = {
        python = { "ruff_format" },
        javascript = { "biome" },
        javascriptreact = { "biome" },
        typescript = { "biome" },
        typescriptreact = { "biome" },
        json = { "biome" },
        jsonc = { "biome" },
        css = { "biome" },
        go = { "goimports" },
    },
    default_format_opts = {
        lsp_format = "fallback",
        timeout_ms = 3000,
    },
    format_on_save = function(bufnr)
        if vim.b[bufnr].autoformat == false then
            return
        end
        return {}
    end,
})

vim.keymap.set("n", "<leader>f", function()
    conform.format()
end, { desc = "Format local buffer" })

vim.keymap.set("n", "<leader>tf", function()
    local enabled = vim.b.autoformat == false
    vim.b.autoformat = enabled
    vim.notify("Autoformat on save " .. (enabled and "enabled" or "disabled") .. " for this buffer")
end, { desc = "Toggle autoformat on save (buffer)" })
