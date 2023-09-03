return function()
  local dap = require "dap"

  local function get_venv_python_path()
    local workspace_folder = vim.fn.getcwd()

    if vim.fn.executable(workspace_folder .. "/.venv/bin/python") then
      return workspace_folder .. "/.venv/bin/python"
    elseif vim.fn.executable(workspace_folder .. "/venv/bin/python") then
      return workspace_folder .. "/venv/bin/python"
    elseif vim.fn.executable(os.getenv("VIRTUAL_ENV") .. "/bin/python") then
      return os.getenv("VIRTUAL_ENV" .. "/bin/python")
    else
      return "/usr/bin/python"
    end
  end

  dap.adapters.python = {
    type = "executable",
    command = vim.fn.stdpath("data") .. "/mason/packages/debugpy/venv/bin/python",
    args = { "-m", "debugpy.adapter" },
  }

  dap.configurations.python = {
    {
      type = "python",
      request = "launch",
      name = "Launch file",
      program = "${file}",
      pythonPath = get_venv_python_path(),
    },
    {
      type = "python",
      request = "launch",
      name = "Launch Django Server",
      cwd = "${workspaceFolder}",
      program = "${workspaceFolder}/manage.py",
      args = {
        "runserver",
        "--noreload",
      },
      console = "integratedTerminal",
      justMyCode = true,
      pythonPath = get_venv_python_path(),
    },
    {
      type = "python",
      request = "launch",
      name = "Python: Django Debug Single Test",
      program = "${workspaceFolder}/manage.py",
      args = {
        "test",
        "${relativeFileDirname}",
      },
      django = true,
      console = "integratedTerminal",
      pythonPath = get_venv_python_path(),
    },
  }
end
