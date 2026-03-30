return {
  {
    "folke/sidekick.nvim",
    dependencies = {
      "nvim-treesitter/nvim-treesitter-textobjects",
      "folke/snacks.nvim",
      "zbirenbaum/copilot.lua",
    },
    opts = {
      nes = {
        enabled = function(buf)
          return vim.g.sidekick_nes ~= false and vim.b.sidekick_nes ~= false
        end,
        debounce = 100,
        trigger = {
          events = { "ModeChanged i:n", "TextChanged", "User SidekickNesDone" },
        },
        clear = {
          events = { "TextChangedI", "InsertEnter" },
          esc = true,
        },
        diff = {
          inline = "words",
          show = "always",
        },
        signs = true,
        jumplist = true,
      },
      cli = {
        watch = true,
        win = {
          wo = {},
          bo = {},
          layout = "right",
          float = {
            width = 0.9,
            height = 0.9,
          },
          split = {
            width = 80,
            height = 20,
          },
          keys = {
            buffers       = { "<c-b>", "buffers",    mode = "nt", desc = "open buffer picker" },
            files         = { "<c-f>", "files",      mode = "nt", desc = "open file picker" },
            hide_n        = { "q",     "hide",       mode = "n",  desc = "hide the terminal window" },
            hide_ctrl_q   = { "<c-q>", "hide",       mode = "n",  desc = "hide the terminal window" },
            hide_ctrl_dot = { "<c-.>", "hide",       mode = "nt", desc = "hide the terminal window" },
            hide_ctrl_z   = { "<c-z>", "blur",       mode = "nt", desc = "go back to the previous window" },
            prompt        = { "<c-p>", "prompt",     mode = "t",  desc = "insert prompt or context" },
            stopinsert    = { "<c-q>", "stopinsert", mode = "t",  desc = "enter normal mode" },
            nav_left      = { "<c-h>", "nav_left",   expr = true, desc = "navigate to the left window" },
            nav_down      = { "<c-j>", "nav_down",   expr = true, desc = "navigate to the below window" },
            nav_up        = { "<c-k>", "nav_up",     expr = true, desc = "navigate to the above window" },
            nav_right     = { "<c-l>", "nav_right",  expr = true, desc = "navigate to the right window" },
          },
        },
        mux = {
          backend = vim.env.ZELLIJ and "zellij" or "tmux",
          enabled = true,
          create = "terminal",
          split = {
            vertical = true,
            size = 0.5,
          },
        },
        tools = {
          aider    = {},
          amazon_q = {},
          claude   = {},
          codex    = {},
          copilot  = {},
          crush    = {},
          cursor   = {},
          gemini   = {},
          grok     = {},
          opencode = {},
          pi       = {},
          qwen     = {},
        },
        context = {},
        prompts = {
          changes         = "Can you review my changes?",
          diagnostics     = "Can you help me fix the diagnostics in {file}?\n{diagnostics}",
          diagnostics_all = "Can you help me fix these diagnostics?\n{diagnostics_all}",
          document        = "Add documentation to {function|line}",
          explain         = "Explain {this}",
          fix             = "Can you fix {this}?",
          optimize        = "How can {this} be optimized?",
          review          = "Can you review {file} for any issues or improvements?",
          tests           = "Can you write tests for {this}?",
          buffers         = "{buffers}",
          file            = "{file}",
          line            = "{line}",
          position        = "{position}",
          quickfix        = "{quickfix}",
          selection       = "{selection}",
          ["function"]    = "{function}",
          class           = "{class}",
        },
        picker = "snacks",
      },
      copilot = {
        status = {
          enabled = true,
          level = vim.log.levels.WARN,
        },
      },
      ui = {
        icons = {
          nes               = " ",
          attached          = " ",
          started           = " ",
          installed         = " ",
          missing           = " ",
          external_attached = "󰖩 ",
          external_started  = "󰖪 ",
          terminal_attached = " ",
          terminal_started  = " ",
        },
      },
      debug = false,
    },
    keys = {
      {
        "<tab>",
        function()
          if not require("sidekick").nes_jump_or_apply() then
            return "<Tab>"
          end
        end,
        expr = true,
        desc = "Goto/Apply Next Edit Suggestion",
      },
      {
        "<c-.>",
        function() require("sidekick.cli").focus() end,
        desc = "Sidekick Focus",
        mode = { "n", "t", "i", "x" },
      },
      {
        "<leader>aa",
        function() require("sidekick.cli").toggle() end,
        desc = "Sidekick Toggle CLI",
      },
      {
        "<leader>as",
        function() require("sidekick.cli").select() end,
        desc = "Select CLI",
      },
      {
        "<leader>ad",
        function() require("sidekick.cli").close() end,
        desc = "Detach a CLI Session",
      },
      {
        "<leader>at",
        function() require("sidekick.cli").send({ msg = "{this}" }) end,
        mode = { "x", "n" },
        desc = "Send This",
      },
      {
        "<leader>af",
        function() require("sidekick.cli").send({ msg = "{file}" }) end,
        desc = "Send File",
      },
      {
        "<leader>av",
        function() require("sidekick.cli").send({ msg = "{selection}" }) end,
        mode = { "x" },
        desc = "Send Visual Selection",
      },
      {
        "<leader>ap",
        function() require("sidekick.cli").prompt() end,
        mode = { "n", "x" },
        desc = "Sidekick Select Prompt",
      },
      -- GitHub Copilot CLI as the dedicated toggle
      {
        "<leader>ac",
        function() require("sidekick.cli").toggle({ name = "copilot", focus = true }) end,
        desc = "Sidekick Toggle Copilot CLI",
      },
    },
  },

  -- NOTE: blink.cmp Tab keymap is NOT overridden here.
  -- Sidekick NES uses <Tab> in normal mode (defined above).
  -- Your existing blink.cmp Tab (accept/select + snippet) in insert mode is preserved.

  -- Snacks.nvim picker integration for sending selections to sidekick
  {
    "folke/snacks.nvim",
    optional = true,
    opts = {
      picker = {
        actions = {
          sidekick_send = function(...)
            return require("sidekick.cli.picker.snacks").send(...)
          end,
        },
        win = {
          input = {
            keys = {
              ["<a-a>"] = {
                "sidekick_send",
                mode = { "n", "i" },
              },
            },
          },
        },
      },
    },
  },
}
-- vim: ts=2 sts=2 sw=2 et
