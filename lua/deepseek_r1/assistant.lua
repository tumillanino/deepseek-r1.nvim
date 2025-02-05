local M = {}

function M.open_assistant()
	local buf = vim.api.nvim_create_buf(false, true)
	local win = vim.api.nvim_open_win(buf, true, {
		relative = "editor",
		width = 80,
		height = 20,
		col = (vim.o.columns - 80) / 2,
		row = (vim.o.lines - 20) / 2,
		style = "minimal",
		border = "single",
	})

	vim.api.nvim_buf_set_option(buf, "buftype", "prompt")
	vim.api.nvim_buf_set_option(buf, "filetype", "deepseek_r1")
	vim.fn.prompt_setprompt(buf, "User: ")

	vim.fn.prompt_setcallback(buf, function(input)
		if input == "" then
			return
		end

		-- Append the user's input to the buffer.
		vim.api.nvim_buf_set_lines(buf, -1, -1, false, { "User: " .. input })

		-- Build a prompt payload that provides context for the assistant.
		local prompt_payload = "User: " .. input .. "\nDeepSeek R1:"
		local response = M.send_to_assistant(prompt_payload)

		-- Append the assistant's response.
		vim.api.nvim_buf_set_lines(buf, -1, -1, false, { "DeepSeek R1: " .. response })

		-- Reset prompt to "User: " for the next input.
		vim.fn.prompt_setprompt(buf, "User: ")
	end)

	vim.cmd("startinsert")
end

function M.send_to_assistant(input)
	local config = require("deepseek_r1").config

	if not config.ollama_endpoint then
		return "Error: Ollama or endpoint not configured. Please run :DeepSeekR1Setup."
	end

	local payload = {
		model = config.ollama_model or "deepseek-r1", -- Ensured consistent model naming
		prompt = input,
		stream = false,
	}

	local curl_command = string.format(
		"curl -s --max-time 10 -X POST -H \"Content-Type: application/json\" -d '%s' %s/api/generate",
		vim.fn.json_encode(payload),
		config.ollama_endpoint
	)

	local handle, err = io.popen(curl_command, "r")
	if not handle then
		return "Error executing curl: " .. (err or "unknown error")
	end

	local result = handle:read("*a")
	handle:close()

	vim.notify("API response: " .. result)

	local ok, json = pcall(vim.fn.json_decode, result)
	if not ok then
		vim.notify("JSON parsing error: " .. result, vim.log.levels.ERROR)
		return "Error parsing JSON. Raw response: " .. result
	end

	-- Return the assistant's reply from one of the potential response keys.
	return json.response or json.text or json.data or "Error: No response from the API."
end

return M
