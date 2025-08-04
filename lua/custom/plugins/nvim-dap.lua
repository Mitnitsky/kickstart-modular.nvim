-- lua/plugins/nvim-dap.lua

return {
  'mfussenegger/nvim-dap',
  dependencies = {
    -- Recommended UI plugin for DAP. Uncomment and configure if desired.
    'rcarriga/nvim-dap-ui',
  },
  config = function()
    local dap = require 'dap'
    local dapui = require 'dapui'

    -- Setup dapui for the debugger UI (recommended)
    dapui.setup {
      -- configure your UI layout here (example):

      elements = {
        {
          id = 'scopes',

          size = 0.25,
        },
        {
          id = 'breakpoints',
          size = 0.25,
        },
        {
          id = 'stacks',

          size = 0.25,
        },

        {
          id = 'watches',
          size = 0.25,
        },
      },

      size = 40, -- sidebar size
      position = 'right', -- position of the sidebar
    }

    -- Listen for DAP events to open/close UI
    dap.listeners.after.event_initialized['dapui_config'] = function()
      dapui.open()
    end
    dap.listeners.before.event_terminated['dapui_config'] = function()
      dapui.close()
    end
    dap.listeners.before.event_exited['dapui_config'] = function()
      dapui.close()
    end

    -- === DAP Adapter: GDB Remote Attach (Direct rust-gdb) ===
    -- This defines *how* nvim-dap launches the debugger process.
    -- We directly launch rust-gdb. Initial commands are passed via args in the config.
    dap.adapters.rust_gdb_direct = {
      type = 'executable',
      -- Command to launch rust-gdb. Assumes rust-gdb is in your PATH.

      -- If not, replace 'rust-gdb' with the full path:
      -- command = '/home/vmitnitsky/.cargo/bin/rust-gdb', -- Example
      command = '/home/vmitnitsky/.cargo/bin/rust-gdb',
      -- Arguments are passed from the configuration's 'args' field.
    }

    -- === DAP Configurations for Rust ===
    -- This defines *what* to debug and *how* (launch/attach), using the adapters.
    -- Rustaceanvim automatically loads configurations for the 'rust' filetype from this table.

    dap.configurations.rust = {
      -- Your existing configurations (if any) can go here

      -- Configuration for attaching to a remote gdbserver by directly launching rust-gdb
      {
        name = 'Attach Remote GDB (Direct)',
        type = 'rust_gdb_direct', -- Use the adapter defined above
        request = 'attach', -- This is an attach request

        -- 'program' field is standard in DAP configurations.
        -- For this setup, its value isn't directly used to launch a program
        -- by the adapter, but it's good practice to include and can be used
        -- for prompting the user for the local executable path for symbols.

        program = '/home/vmitnitsky/dev/dpdk/drivers/net/msft_smartnic/src/build/RDMA/linux/consumer/rust-consumer/target/aarch64-unknown-linux-gnu/debug/incremental/lifetimes-1jk5g9rp9z30m',

        -- Arguments passed directly to the 'command' ('rust-gdb').
        -- We construct the necessary GDB command line here.
        args = {
          '--interpreter=mi2', -- Tell GDB to use the Machine Interface
          '-ex',
          'set confirm off', -- Prevents GDB from automatically loading shared library symbols from the target
          '-ex',
          'set auto-solib-add off', -- Prevents GDB from automatically loading shared library symbols from the target
          '-ex',
          'set auto-load safe-path /', -- Tells GDB it's safe to load files from local paths if given          '-ex',
          '-ex',
          'file /home/vmitnitsky/dev/dpdk/drivers/net/msft_smartnic/src/build/RDMA/linux/consumer/rust-consumer/target/aarch64-unknown-linux-gnu/debug/incremental/lifetimes-1jk5g9rp9z30m', -- Execute the next argument as a GDB command *before* entering MI mode
          '-ex',
          'set sysroot /home/vmitnitsky/dev/dpdk/drivers/net/msft_smartnic/src/build/RDMA/linux/consumer/rust-consumer/target/aarch64-unknown-linux-gnu/debug/incremental/', -- Execute the next argument as a GDB command *before* entering MI mode
          '-ex',
          'target remote 10.33.17.10:10000',
          '-q',
          -- Note: The order of these arguments is important:
          -- 1. --interpreter=mi2 (GDB needs to know the output format)
          -- 2. -ex commands (Execute initial setup commands)

          -- 3. Other options (-q)
        },

        -- Working directory for the debugger process ('rust-gdb').
        -- Often your project root is suitable.
        cwd = vim.fn.getcwd(), -- Sets the working directory to the current buffer's directory

        -- Environment variables passed to the 'rust-gdb' process.
        -- This is where you put the RUST_GDB env var from your VS Code config.
        env = {
          RUST_GDB = '/usr/bin/gdb-multiarch', -- Use gdb-multiarch for cross-debugging (if needed)
          -- Add any other environment variables your debugging setup needs
        },

        -- Additional notes:
        -- - 'target' and 'remote' fields from your VS Code config are handled
        --   *internally* by the 'target remote' GDB command, which we pass
        --   as an argument via the configuration's 'args'.
        -- - 'valuesFormatting': "prettyPrinters" is typically handled by rust-gdb
        --   itself when debugging Rust code, assuming pretty printers are available
        --   and enabled.
      },

      -- Add other Rust debug configurations here if needed (e.g., local launch)
    }

    -- Optional: Setup language-specific mappings or extensions if needed
    -- Rustaceanvim might set some basic Rust DAP config, but you can add more here
    -- e.g., require('dap.ext.codelldb').setup({}) for CodeLLDB integration

    -- Optional: Key mappings for debugging (add these where you configure your keybinds)
    -- vim.keymap.set('n', '<F5>', dap.continue, { desc = 'DAP: Continue' })
    -- vim.keymap.set('n', '<F9>', dap.toggle_breakpoint, { desc = 'DAP: Toggle Breakpoint' })
    -- vim.keymap.set('n', '<F10>', dap.step_over, { desc = 'DAP: Step Over' })
    -- vim.keymap.set('n', '<F11>', dap.step_into, { desc = 'DAP: Step Into' })
    -- vim.keymap.set('n', '<F12>', dap.step_out, { desc = 'DAP: Step Out' })
    -- vim.keymap.set('n', '<leader>dt', dap.terminate, { desc = 'DAP: Terminate' })
    -- vim.keymap.set('n', '<leader>do', dap.run_last, { desc = 'DAP: Run Last Config' })
    -- vim.keymap.set('n', '<leader>du', dapui.toggle, { desc = 'DAP: Toggle UI' })
  end,
}
