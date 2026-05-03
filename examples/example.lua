require("telescope").setup {
  extensions = {
    command_palette = {
      "Command Palette", -- top-level menu name
      {
        "File",
        {
          "entire selection",
          ':call feedkeys("GVgg")',
          "as you know OvO", -- the 3rd slot as description
        },
        { "save current file)", ":w" },
        { "save all files", ":wa" },
        { "quit", ":qa" },
        { "file browser", ":lua require'telescope'.extensions.file_browser.file_browser()" },
        { "search word", ":lua require('telescope.builtin').live_grep()" },
        { "git files", ":lua require('telescope.builtin').git_files()" },
        { "files", ":lua require('telescope.builtin').find_files()" },
      },
      {
        -- you could specify name obviously
        name = "Help",
        -- in this case where the operation is to open a
        -- submenu, desc must be specify this way
        desc = "help me plz",
        { "tips", ":help tips" },
        { "cheatsheet", ":help index" },
        { "tutorial", ":help tutor" },
        { "summary", ":help summary" },
        { "quick reference", ":help quickref" },
        { "search help", ":lua require('telescope.builtin').help_tags()" },
      },
      {
        "Vim",
        -- the third case is funny, we can assgin a table to `op` (slot 2)
        {
          { "reload vimrc", ":source $MYVIMRC" },
          { "check health", ":checkhealth" },
          { "jumps", ":lua require('telescope.builtin').jumplist()" },
          { "commands", ":lua require('telescope.builtin').commands()" },
          { "command history", ":lua require('telescope.builtin').command_history()" },
          { "registers (A-e)", ":lua require('telescope.builtin').registers()" },
          { "colorshceme", ":lua require('telescope.builtin').colorscheme()" },
          { "vim options", ":lua require('telescope.builtin').vim_options()" },
          { "keymaps", ":lua require('telescope.builtin').keymaps()" },
          { "buffers", ":Telescope buffers" },
          { "search history", ":lua require('telescope.builtin').search_history()" },
          { "paste mode", ":set paste!" },
          { "cursor line", ":set cursorline!" },
          { "cursor column", ":set cursorcolumn!" },
          { "spell checker", ":set spell!" },
          { "relative number", ":set relativenumber!" },
          { "search highlighting", ":set hlsearch!" },
        },
        -- in this case we can use slot 3
        "Let me do something for vim...",
      },
    },
  },
}
