## Description
This is an DeepSeek R1 AI assistant for Neovim. This is in early development and testing stages.

## Still to do 
- Add API is the most important thing to make this plugin usable

## Installation
```Bash
git clone https://github.com/tumillanino/deepseek-r1.nvim ~/.config/nvim/pack/plugins/start/deepseek-r1.nvim
```
Add the following to your init.lua ----------
```lua
require("deepseek_r1").setup({
  api_key = "your-api-key-here",
  api_endpoint = "https://api.deepseek.com/v1/assistant",
})

-- Optional: Add a keybinding
vim.keymap.set("n", "<leader>ds", "<cmd>DeepSeekR1<cr>", { desc = "Open DeepSeek R1 Assistant" })

```
### If you are using LazyVim, NVChad or AstroVim
```lua
return {
  {
    "tumillanino/deepseek-r1.nvim",
    config = function():
      require("deepseek_r1").setup({
        api_key = "your-api-key-here",
        api_endpoint = "https://api.deepseek.com/v1/assistant",
      })
    end,
    keys = {
      { "<leader>ds", "<cmd>DeepSeekR1<cr>", desc = "Open DeepSeek R1 Assistant" },
    },
  },
}
```
### If you are using Packer
```lua
use {
  "tumillanino/deepseek-r1.nvim",
  config = function()
    require("deepseek_r1").setup({
      api_key = "your-api-key-here",
      api_endpoint = "https://api.deepseek.com/v1/assistant",
    })
  end,
}
```
### For Plug
```vim
Plug 'tumillanino/deepseek-r1.nvim'
```

### Troubleshooting
Error: API key or endpoint not configured:
Run :DeepSeekR1Setup to configure your API key and endpoint.

Error: Command not found:
Ensure the plugin is installed and loaded correctly. Check your plugin manager logs for errors.

### Contributing
Contributions are welcome! Feel free to open an issue or submit a pull request.

### License
This project is licensed under the MIT License. See the LICENSE file for details.
