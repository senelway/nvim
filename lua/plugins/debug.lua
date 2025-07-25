return {
  "mfussenegger/nvim-dap",
  dependencies = {
    -- Creates a beautiful debugger UI
    "rcarriga/nvim-dap-ui",
    -- Installs the debug adapters for you
    "mason-org/mason.nvim",
    "jay-babu/mason-nvim-dap.nvim",
    -- Add your own debuggers here
    "leoluz/nvim-dap-go",
    "theHamsta/nvim-dap-virtual-text",
    "nvim-neotest/nvim-nio",
  },
  config = function()
    local dap = require("dap")
    local dapui = require("dapui")

    require("mason-nvim-dap").setup({
      -- Makes a best effort to setup the various debuggers with
      -- reasonable debug configurations
      automatic_installation = true,

      -- You can provide additional configuration to the handlers,
      -- see mason-nvim-dap README for more information
      handlers = {},

      -- You'll need to check that you have the required things installed
      -- online, please don't ask me how to install them :)
      ensure_installed = {
        -- Update this to ensure that you have the debuggers for the langs you want
        "delve",
      },
    })

    -- Basic debugging keymaps, feel free to change to your liking!
    vim.keymap.set("n", "<leader>dr", dap.continue, { desc = "Debug: Start/Continue" })
    vim.keymap.set("n", "<leader>di", dap.step_into, { desc = "Debug: Step Into" })
    vim.keymap.set("n", "<leader>dg", dap.step_over, { desc = "Debug: Step Over" })
    vim.keymap.set("n", "<leader>do", dap.step_out, { desc = "Debug: Step Out" })
    vim.keymap.set("n", "<leader>dt", dap.toggle_breakpoint, { desc = "[D]ebug: [T]oggle Breakpoint" })
    vim.keymap.set("n", "<leader>ds", function()
      dap.set_breakpoint(vim.fn.input("Breakpoint condition: "))
    end, { desc = "Debug: Set Breakpoint" })

    -- Dap UI setup
    -- For more information, see |:help nvim-dap-ui|
    dapui.setup({})

    -- Toggle to see last session result. Without this, you can't see session output in case of unhandled exception.
    vim.keymap.set("n", "<leader>da", dapui.toggle, { desc = "Debug: See last session result." })

    dap.listeners.after.event_initialized["dapui_config"] = dapui.open
    dap.listeners.before.event_terminated["dapui_config"] = dapui.close
    dap.listeners.before.event_exited["dapui_config"] = dapui.close

    -- Install golang specific config
    require("dap-go").setup()
    -- TODO:: causes log error on first run if not installed
    require("nvim-dap-virtual-text").setup()
  end,
}
