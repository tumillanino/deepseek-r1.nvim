local M = {}

function M.open_assistant()
  local buf = vim.api.nvim_create_buf(false, true)

  vim.api.nvim_open_win(buf, true, {
    relative = "editor",
    width = 80,
    height = 20,
    col = (vim.o.columns - 80) / 2,
    row = (vim.o.lines - 20) / 2,
    style = "minimal",
    border = "single",
  })

  vim.api.nvim_set_option_value("buftype", "prompt", { buf = buf })
  vim.api.nvim_set_option_value("filetype", "deepseek_r1", { buf = buf })

  -- Prompt for user input
  vim.fn.prompt_setprompt(buf, "DeepSeek R1: ")
  vim.fn.prompt_setcallback(buf, function(input)
    if input == "" then
      return
    end

    -- Send the input to the DeepSeek R1 assistant
    local response = M.send_to_assistant(input)

    -- Display the response in the buffer
    vim.api.nvim_buf_set_lines(buf, -1, -1, false, { response })
  end)

  -- Enter insert mode
  vim.api.nvim_command("startinsert")
end

function M.send_to_assistant(input)
  local config = require("deepseek_r1").config

  if not config.api_key or not config.api_endpoint then
    return "Error: API key or endpoint not configured. Please run :DeepSeekR1Setup."
  end

  local curl_command = string.format(
    'curl -X POST -H "Authorization: Bearer %s" -d \'{"input": "%s"}\' %s',
    config.api_key,
    input,
    config.api_endpoint
  )

  local handle = io.popen(curl_command)
  local result = handle:read("*a")
  handle:close()

  local ok, json = pcall(vim.fn.json_decode, result)
  if not ok then
    return "Error: Failed to parse API response."
  end

  return json.response or "Error: No response from the API."
end

return M
