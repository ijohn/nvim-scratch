local is_mac = vim.fn.has("mac") == 1

if is_mac then
    -- Use the native macOS clipboard automatically.
    vim.g.clipboard = nil
    vim.opt.clipboard = "unnamedplus"
else
    -- Keep normal edits internal and send yanks through OSC 52 below.
    vim.g.clipboard = "osc52"
    vim.opt.clipboard = ""
end

vim.g.netrw_banner = 0

vim.opt.nu = true
vim.opt.relativenumber = true

vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true

vim.opt.wrap = false
vim.opt.smartindent = true
vim.opt.inccommand = "split"

vim.opt.splitbelow = true
vim.opt.splitright = true

vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.laststatus = 3

vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undodir = vim.fn.stdpath("data") .. "/undodir"
vim.opt.undofile = true

vim.opt.completeopt = "menuone,noselect,fuzzy,nosort"
vim.opt.shortmess:append("c")
vim.opt.isfname:append("@-@")
vim.opt.guicursor = ""
vim.opt.scrolloff = 8

vim.opt.colorcolumn = "0"
vim.opt.signcolumn = "yes"
vim.o.cmdheight = 0
vim.opt.termguicolors = true

vim.api.nvim_create_autocmd("TextYankPost", {
    desc = "Highlight when yanking (copying) text",
    callback = function()
        vim.hl.on_yank()
    end,
})

if not is_mac then
    vim.api.nvim_create_autocmd("TextYankPost", {
        group = vim.api.nvim_create_augroup("YankToClipboard", { clear = true }),
        desc = "Copy yanked text to the terminal clipboard via OSC 52",
        callback = function()
            local event = vim.v.event
            -- Explicit clipboard yanks are already handled by the provider.
            if event.operator ~= "y" or event.regname == "+" or event.regname == "*" then
                return
            end

            local lines = vim.deepcopy(event.regcontents)
            if event.regtype == "V" then
                table.insert(lines, "") -- Preserve the trailing newline for whole lines.
            end
            require("vim.ui.clipboard.osc52").copy("+")(lines)
        end,
    })
end
