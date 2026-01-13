-- navigate without expanding the block
vim.cmd('nmap j gj')
vim.cmd('nmap k gk')

-- jump between angle brackets
vim.cmd('set matchpairs+=<:>')

-- vim.cmd('set relativenumber<cr>')
vim.opt.clipboard = 'unnamedplus'

-- search ignoring case
vim.opt.ignorecase = true

-- disable "ignorecase" option if the search pattern contains upper case characters
vim.opt.smartcase = true

-- set leader key to space
vim.g.mapleader = ' '

-- leader + c -> edit neovim config file
vim.cmd('nmap <leader>c :e ~/.config/nvim/init.lua<cr>')

-- -- load plugins
-- local Plug = vim.fn['plug#']
-- vim.call('plug#begin')
-- -- easy motion
-- Plug('easymotion/vim-easymotion')
-- vim.call('plug#end')

-- -- <Leader>f{char} to move to {char}
-- vim.keymap.set('n', '<Leader>f', '<Plug>(easymotion-overwin-f)')
-- vim.keymap.set('', '<Leader>f', '<Plug>(easymotion-bd-f)')

-- -- s{char}{char} to move to {char}{char}
-- vim.keymap.set('n', 's', '<Plug>(easymotion-overwin-f2)')

-- -- Move to line
-- vim.keymap.set('n', '<Leader>L', '<Plug>(easymotion-overwin-line)')
-- vim.keymap.set('', '<Leader>L', '<Plug>(easymotion-bd-jk)')

-- -- Move to word
-- vim.keymap.set('n', '<Leader>w', '<Plug>(easymotion-overwin-w)', {
--     silent = true
-- })
-- vim.keymap.set('', '<Leader>w', '<Plug>(easymotion-bd-w)', {
--     silent = true
-- })

if vim.g.vscode then
    -- vscode keybindings
    local vscode = require('vscode')

    -- g + s -> go to symbol
    vim.keymap.set('n', 'gs', function()
        vscode.action("workbench.action.gotoSymbol")
    end)

    -- [ + e -> prev problem
    vim.keymap.set({ 'n', 'i' }, '[e', function()
        vscode.action("editor.action.marker.prevInFiles")
    end)

    -- ] + e -> next problem
    vim.keymap.set({ 'n', 'i' }, ']e', function()
        vscode.action("editor.action.marker.nextInFiles")
    end)

    -- leader + x -> view extensions
    vim.keymap.set('n', '<leader>x', function()
        vscode.action("workbench.view.extensions")
    end)

    -- leader + g -> open git (source control)
    vim.keymap.set('n', '<leader>g', function()
        vscode.action("workbench.view.scm")
    end)

    -- leader + g + g -> open git graph
    vim.keymap.set('n', '<leader>gg', function()
        vscode.action("git-graph.view")
    end)

    -- leader + g + , -> diff
    vim.keymap.set('n', '<leader>g,', function()
        vscode.action("gitlens.diffWithPrevious")
    end)

    -- leader + r -> reload window
    vim.keymap.set('n', '<leader>r', function()
        vscode.action("workbench.action.reloadWindow")
    end)

    -- leader + t -> theme
    vim.keymap.set('n', '<leader>t', function()
        vscode.action("workbench.action.selectTheme")
    end)

    -- leader + 2 -> two panel
    vim.keymap.set('n', '<leader>2', function()
        vscode.action("workbench.action.editorLayoutTwoColumns")
    end)

    -- leader + 3 -> 3 panel
    vim.keymap.set('n', '<leader>3', function()
        vscode.action("workbench.action.editorLayoutThreeColumns")
    end)

    -- leader + , -> open use settings in json
    vim.keymap.set('n', '<leader>,', function()
        vscode.action("workbench.action.openSettingsJson")
    end)

    -- leader + f -> quick search
    vim.keymap.set('n', '<leader>f', function()
        vscode.action("workbench.action.quickTextSearch")
    end)

    -- leader + a -> new file
    vim.keymap.set('n', '<leader>a', function()
        vscode.action("fileutils.newFileAtRoot")
    end)

    -- leader + A -> new folder
    vim.keymap.set('n', '<leader>A', function()
        vscode.action("fileutils.newFolderAtRoot")
    end)

    -- leader + e + o -> focus on outline view
    vim.keymap.set('n', '<leader>eo', function()
        vscode.action("outline.focus")
    end)

    -- leader + e + f -> focus on folders view
    vim.keymap.set('n', '<leader>ef', function()
        vscode.action("workbench.explorer.fileView.focus")
    end)

    -- leader + k -> show commands
    vim.keymap.set('n', '<leader>p', function()
        vscode.action("workbench.action.showCommands")
    end)
else
    -- ordinary neovim

    -- transparent background
    vim.cmd("set background=dark")
    vim.cmd("hi Normal guibg=NONE ctermbg=NONE")
    vim.cmd("hi NonText guibg=NONE ctermbg=NONE")
end
