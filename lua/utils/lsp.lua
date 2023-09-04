local M = {}

local get_venv = require("utils.python").getVirtualEnv

M.get_filetype = function()
  -- 獲取目前作用中之緩衝區編號
  local current_buffer = vim.api.nvim_get_current_buf()
  -- 獲取目前緩衝區的檔案類型（filetype）
  local filetype = vim.api.nvim_buf_get_option(current_buffer, "filetype")

  return filetype

  -- return vim.bo.filetype
end

M.lsp_provider = function()
  local clients = {}
  local icon = " "

  for _, client in pairs(vim.lsp.get_active_clients()) do
    if client.name == "pyright" then
      local venv_name = get_venv()
      clients[#clients + 1] = icon .. client.name .. " " .. venv_name
    else
      clients[#clients + 1] = icon .. client.name
    end
  end

  return table.concat(clients, " ")
end

M.print_lsp_client = function()
  -- print(vim.config.capabilities.textDocument.name)
  local lsp_clients = vim.lsp.get_active_clients()
  for i, v in pairs(lsp_clients) do
    -- print(i)  -- print the number
    -- print(v)  -- print the value
    print(string.format("%s: %s", i, v))
  end
end

M.get_lsp_client_name = function(msg)
  msg = msg or "LS Inactive"
  local buf_clients = vim.lsp.get_active_clients()
  if next(buf_clients) == nil then
    -- TODO: clean up this if statement
    if type(msg) == "boolean" or #msg == 0 then
      return "LS Inactive"
    end
    return msg
  end
  local buf_ft = vim.bo.filetype
  local buf_client_names = {}

  -- add client
  for _, client in pairs(buf_clients) do
    if client.name ~= "null-ls" then
      table.insert(buf_client_names, client.name)
    end
  end

  -- add formatter
  local formatters = require("lvim.lsp.null-ls.formatters")
  local supported_formatters = formatters.list_registered_providers(buf_ft)
  vim.list_extend(buf_client_names, supported_formatters)

  -- add linter
  local linters = require("lvim.lsp.null-ls.linters")
  local supported_linters = linters.list_registered_providers(buf_ft)
  vim.list_extend(buf_client_names, supported_linters)

  return table.concat(buf_client_names, ", ")
end

return M
