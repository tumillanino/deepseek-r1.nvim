local M = {}

local default_config = {
  api_key = nil,
  api_endpoint = nil,
}

function M.setup(user_config)
  M.config = vim.tbl_deep_extend("force", default_config, user_config or {})

  vim.api.nvim_create_user_command("DeepSeekR1", function()
    require("deepseek_r1.assistant").open_assistant()
  end, {})

  vim.api.nvim_create_user_command("DeepSeekR1Setup", function()
    local api_key = vim.fn.input("Enter your API key: ")
    local api_endpoint = vim.fn.input("Enter the API endpoint: ")

    M.config.api_key = api_key
    M.config.api_endpoint = api_endpoint

    print("DeepSeek R1: API key and endpoint configured.")
  end, {})
end

return M
