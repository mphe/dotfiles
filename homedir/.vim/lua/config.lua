local vim = vim

-- barbar.nvim {{{
-- config {{{
vim.g.barbar_auto_setup = false
require'bufferline'.setup {
  -- Enable/disable animations
  animation = true,

  -- Enable/disable auto-hiding the tab bar when there is a single buffer
  auto_hide = false,

  -- Enable/disable current/total tabpages indicator (top right corner)
  tabpages = true,

  -- Enables/disable clickable tabs
  --  - left-click: go to buffer
  --  - middle-click: delete buffer
  clickable = true,

  -- Excludes buffers from the tabline
  -- exclude_ft = {'javascript'},
  -- exclude_name = {'package.json'},

  -- A buffer to this direction will be focused (if it exists) when closing the current buffer.
  -- Valid options are 'left' (the default) and 'right'
  focus_on_close = 'left',

  -- Hide inactive buffers and file extensions. Other options are `alternate`, `current`, and `visible`.
  hide = {extensions = true, inactive = false},

  -- Disable highlighting alternate buffers
  highlight_alternate = false,

  -- Disable highlighting file icons in inactive buffers
  highlight_inactive_file_icons = false,

  -- Enable highlighting visible buffers
  highlight_visible = true,

  icons = {
    preset = "powerline",
    -- separator_at_end = false,
    -- Configure the base icons on the bufferline.
    buffer_index = false,
    buffer_number = false,
    button = '',
    -- Enables / disables diagnostic symbols
    diagnostics = {
      [vim.diagnostic.severity.ERROR] = {enabled = false},
      [vim.diagnostic.severity.WARN] = {enabled = false},
      [vim.diagnostic.severity.INFO] = {enabled = false},
      [vim.diagnostic.severity.HINT] = {enabled = false},
    },
    filetype = {
      -- Sets the icon's highlight group.
      -- If false, will use nvim-web-devicons colors
      custom_colors = false,

      -- Requires `nvim-web-devicons` if `true`
      enabled = true,
    },

    -- Configure the icons on the bufferline when modified or pinned.
    -- Supports all the base icon options.
    modified = {button = '●'},
    pinned = {button = ''},

    gitsigns = { enabled = false },

    -- separator = {left = '', right = ''},
    -- inactive = {separator = {left = '', right = ''}, button = '×'},

    -- separator = {left = '', right = ' '},
    -- inactive = {separator = {left = '', right = ' '}, button = '×'},
    -- inactive = {separator = {left = '🭛', right = '🭦'}, button = '×'},
    -- separator = {left = '🭛', right = '🭦'},
    -- separator = {left = '▎', right = ''},
    -- separator = {left = '', right = ''},
    -- inactive = {separator = {left = '', right = ''}, button = '×'},
    -- separator = {left = '', right = " \u{e0ba}"},
    -- inactive = {separator = {left = '', right = '\u{e0bd} '}, button = '×'},
    -- inactive = {separator = {left = '', right = ''}, button = '×'},
    -- separator = {left = '', right = ''},


    -- Configure the icons on the bufferline based on the visibility of a buffer.
    -- Supports all the base icon options, plus `modified` and `pinned`.
    -- alternate = {filetype = {enabled = false}},
    -- current = {buffer_index = false},
    -- inactive = {button = '×'},
    -- visible = {modified = {buffer_number = false}},
  },

  -- If true, new buffers will be inserted at the start/end of the list.
  -- Default is to insert after current buffer.
  insert_at_end = true,
  insert_at_start = false,

  -- Sets the maximum padding width with which to surround each tab
  maximum_padding = 2,

  -- Sets the minimum padding width with which to surround each tab
  minimum_padding = 1,

  -- Sets the maximum buffer name length.
  maximum_length = 30,

  -- If set, the letters for each buffer in buffer-pick mode will be
  -- assigned based on their name. Otherwise or in case all letters are
  -- already assigned, the behavior is to assign letters in order of
  -- usability (see order below)
  semantic_letters = true,

  -- New buffer letters are assigned in this order. This order is
  -- optimal for the qwerty keyboard layout but might need adjustement
  -- for other layouts.
  letters = 'asdfjkl;ghnmxcvbziowerutyqpASDFJKLGHNMXCVBZIOWERUTYQP',

  -- Sets the name of unnamed buffers. By default format is "[Buffer X]"
  -- where X is the buffer number. But only a static string is accepted here.
  no_name_title = nil,
}

-- }}}
-- mappings {{{

-- Aliases for muscle memory
vim.cmd [[
  cnoreabbrev bf BufferFirst
  cnoreabbrev bl BufferLast
  cnoreabbrev bd BufferClose
]]

-- Move to previous/next
vim.keymap.set("n", "<leader>bp", "<Cmd>BufferPrevious<CR>", { silent = true })
vim.keymap.set("n", "<leader>bn", "<Cmd>BufferNext<CR>", { silent = true })
-- Re-order to previous/next
vim.keymap.set("n", "<leader>b<", "<Cmd>BufferMovePrevious<CR>", { silent = true })
vim.keymap.set("n", "<leader>b>", "<Cmd>BufferMoveNext<CR>", { silent = true })
-- Goto buffer in position...
vim.keymap.set("n", "<leader>1", "<Cmd>BufferGoto 1<CR>", { silent = true })
vim.keymap.set("n", "<leader>2", "<Cmd>BufferGoto 2<CR>", { silent = true })
vim.keymap.set("n", "<leader>3", "<Cmd>BufferGoto 3<CR>", { silent = true })
vim.keymap.set("n", "<leader>4", "<Cmd>BufferGoto 4<CR>", { silent = true })
vim.keymap.set("n", "<leader>5", "<Cmd>BufferGoto 5<CR>", { silent = true })
vim.keymap.set("n", "<leader>6", "<Cmd>BufferGoto 6<CR>", { silent = true })
vim.keymap.set("n", "<leader>7", "<Cmd>BufferGoto 7<CR>", { silent = true })
vim.keymap.set("n", "<leader>8", "<Cmd>BufferGoto 8<CR>", { silent = true })
vim.keymap.set("n", "<leader>9", "<Cmd>BufferGoto 9<CR>", { silent = true })
vim.keymap.set("n", "<leader>0", "<Cmd>BufferLast<CR>", { silent = true })
vim.keymap.set("n", "<leader>bL", "<Cmd>BufferLast<CR>", { silent = true })
vim.keymap.set("n", "<leader>bF", "<Cmd>BufferFirst<CR>", { silent = true })
-- Pin/unpin buffer
vim.keymap.set("n", "<leader>p", "<Cmd>BufferPin<CR>", { silent = true })
-- Close buffer
vim.keymap.set("n", "<leader>bd", "<Cmd>BufferClose<CR>", { silent = true })
-- Wipeout buffer
--                          :BufferWipeout
-- Close commands
--                          :BufferCloseAllButCurrent
--                          :BufferCloseAllButPinned
--                          :BufferCloseAllButCurrentOrPinned
--                          :BufferCloseBuffersLeft
--                          :BufferCloseBuffersRight
-- Magic buffer-picking mode
vim.keymap.set("n", "<leader>B", "<Cmd>BufferPick<CR>", { silent = true })
-- Sort automatically by...
-- nnoremap <silent> <Space>bb <Cmd>BufferOrderByBufferNumber<CR>
-- nnoremap <silent> <Space>bd <Cmd>BufferOrderByDirectory<CR>
-- nnoremap <silent> <Space>bl <Cmd>BufferOrderByLanguage<CR>
-- nnoremap <silent> <Space>bw <Cmd>BufferOrderByWindowNumber<CR>
--
-- Other:
-- :BarbarEnable - enables barbar (enabled by default)
-- :BarbarDisable - very bad command, should never be used
-- }}}
-- }}}

-- nvim-scrollbar {{{
require("scrollbar").setup({
    handle = {
        text = " ",
        highlight = "Pmenu",
    },
    -- marks = {
    --     Search = { text = { "-", "=" }, priority = 0, highlight = "orange" },
    --     Error = { text = { "-", "=" }, priority = 1, highlight = "red" },
    --     Warn = { text = { "-", "=" }, priority = 2, highlight = "CocWarningSign" },
    --     Info = { text = { "-", "=" }, priority = 3, highlight = "CocInfoSign" },
    --     Hint = { text = { "-", "=" }, priority = 4, color = "green" },
    --     Misc = { text = { "-", "=" }, priority = 5, color = "purple" },
    -- },
    excluded_filetypes = {
        "",
        "prompt",
        "TelescopePrompt",
    },
    autocmd = {
        render = {
            "BufWinEnter",
            "TabEnter",
            "TermEnter",
            "WinEnter",
            "CmdwinLeave",
            "TextChanged",
            "VimResized",
            "WinScrolled",
            "InsertLeave",
        },
    },
    handlers = {
        diagnostic = true,
        search = false,
    },
})

local mark_type_map = {
    I = "Info",
    W = "Warn",
    E = "Error",
}

function ll_handler(bufnr)
    local winnr = vim.fn.get(vim.fn.win_findbuf(bufnr), 0, -1)
    if winnr == -1 then
        return {}
    end

    local ll = vim.fn.getloclist(winnr)
    local marks = {}

    for _, entry in pairs(ll) do
        if (entry.bufnr or bufnr) == bufnr then
            table.insert(marks, { line = entry.lnum, type = mark_type_map[entry.type]})
        end
    end
    return marks
end

require("scrollbar.handlers").register("locationlist", ll_handler)
-- }}}

-- nvim-notify {{{
require("notify").setup({
    stages = "slide",   -- Animation style (see below for details)
    -- stages = "fade_in_slide_out",
    on_open = nil,      -- Function called when a new window is opened, use for changing win settings/config
    on_close = nil,     -- Function called when a window is closed
    render = "default", -- Render function for notifications. See notify-render()
    timeout = 5000,     -- Default timeout for notifications
    max_width = nil,    -- Max number of columns for messages
    max_height = nil,   -- Max number of lines for a message
    minimum_width = 50, -- Minimum width for notification windows

    -- For stages that change opacity this is treated as the highlight behind the window
    -- Set this to either a highlight group, an RGB hex value e.g. "#000000" or a function returning an RGB code for dynamic values
    background_colour = "Normal",

    -- Icons for the different levels
    icons = {
        ERROR = " ",
        WARN = " ",
        INFO = "",
        DEBUG = "",
        TRACE = "✎",
    },
})

-- Use plugin for all notifications
vim.notify = require("notify")
-- }}}

-- paint.nvim {{{
require("paint").setup({
    highlights = {
        {
            -- filter can be a table of buffer options that should match,
            -- or a function called with buf as param that should return true.
            -- The example below will paint @something in comments with Constant
            -- filter = { filetype = "lua" },
            -- pattern = "%s*%-%-%-%s*(@%w+)",
            -- hl = "Constant",
            filter = {},
            pattern = "%s+$",
            hl = "Error",
        },
        {
            -- Highlight tags in C++
            filter = { filetype = "cpp" },
            pattern = "%[%[(.-)%]%]",
            hl = "Keyword",
        },
        {
            -- Highlight links in markdown that do not have a URL part.
            filter = { filetype = "markdown" },
            pattern = "%[(.-)%]",
            hl = "markdownLinkText",
        },
    },
})
-- }}}


-- copilot-client.lua {{{
if vim.g.config_use_copilot == 1 then
    require("copilot").setup()

    function copilot_show()
      require("copilot.suggestion").next()
      vim.api.nvim_buf_set_keymap(0, 'i', '<CR>', '<cmd>lua copilot_accept()<CR>', { noremap = true, silent = true })
    end

    function copilot_accept()
      require("copilot.suggestion").accept()
      copilot_cancel()
    end

    function copilot_cancel()
      if require("copilot.suggestion").is_visible() then
        require("copilot.suggestion").dismiss()
      end
      vim.api.nvim_buf_del_keymap(0, 'i', '<CR>')
    end

    vim.api.nvim_create_autocmd("InsertLeave", {
      command = "silent! lua copilot_cancel()",
      group = vim.api.nvim_create_augroup("custom_copilot_trigger", { clear = true }),
    })

    vim.api.nvim_set_keymap('i', '<C-c>', '<cmd>lua copilot_show()<CR>', { noremap = true, silent = true })

    -- require('copilot-client').setup {
    --   mapping = {
    --     accept = '<CR>',
    --     -- Next and previos suggestions to be added
    --     -- suggest_next = '<C-n>',
    --     -- suggest_prev = '<C-p>',
    --   },
    -- }

    -- Create a keymap that triggers the suggestion.
    -- vim.api.nvim_set_keymap('i', '<C-c>', '<cmd>lua require("copilot-client").suggest()<CR>', { noremap = true, silent = true })
end
-- }}}
