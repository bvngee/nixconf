return {
  'neovim/nvim-lspconfig',
  event = { 'BufReadPost', 'BufNewFile', 'BufWritePre' },
  dependencies = {
    'hrsh7th/nvim-cmp', -- to create capabilities
    {
      'folke/neodev.nvim',
      opts = {
        override = function(root_dir, library)
          local enable = root_dir:find('nvim', 1, true) ~= nil
            or root_dir:find('nixconf', 1, true) ~= nil
          if enable then
            library.enabled = true
            library.types = true
            library.runtime = true
            library.plugins = true
          end
        end,
      },
    },
    -- {
    --   'smjonas/inc-rename.nvim',
    --   opts = { input_buffer_type = 'dressing' },
    --   main = 'inc_rename',
    -- },
  },
  config = function()
    -- Available keys are:
    -- cmd (table)
    -- filetypes (table)
    -- capabilities (table)
    -- settings (table)
    local servers = {
      nil_ls = {},
      lua_ls = {
        settings = {
          Lua = {
            workspace = {
              checkThirdParty = false,
            },
            completion = {
              callSnippet = 'Replace',
            },
            type = {
              -- weakUnionCheck = true,
              -- weakNilCheck = true,
              -- castNumberToInteger = true,
            },
            format = { enable = false },
            hint = {
              enable = true,
              arrayIndex = 'Disable', -- "Enable", "Auto", "Disable"
              await = true,
              paramName = 'Disable', -- "All", "Literal", "Disable"
              paramType = false,
              semicolon = 'Disable', -- "All", "SameLine", "Disable"
              setType = true,
            },
            diagnostics = {
              disable = {
                'missing-fields',
                'trailing-space',
                'unused-local',
                'unused-function',
                'unused-vararg',
              },
            },
            telemetry = { enable = false },
          },
        },
      },
      bashls = {},
      rust_analyzer = {},
      clangd = {
        -- Clangd only *fully* works if the compile_commands.json is in the
        -- root_dir. I often work in projects with .git and other root
        -- indicators higher up, so clangd gets confused. Instead, just use cwd,
        -- which is usually correct when I open nvim in the right place anyways.
        root_dir = vim.loop.cwd(),
        cmd = {
          -- See https://bvngee.com/blogs/clangd-embedded-development (temporary)
          'clangd-unwrapped',
          -- Whitelists all compiler binaries. Notably a security risk, but I'm usually working in trusted environments.
          '--query-driver=**',
          -- Enforce symlinking compile_commands.json from the build dir to root_dir (the heuristics aren't reliable)
          '--compile-commands-dir=.',
          -- Allows clangd to parse global or project-local configuration
          '--enable-config',

          '--background-index',
          '--clang-tidy',
          '--header-insertion=never', -- iwyu is too annoying
          '--header-insertion-decorators',
          -- '--log=verbose',
        },
      },
      pyright = {},
      ts_ls = {},
      tailwindcss = {},
      lemminx = {}, -- for XML
      zls = {},
      jdtls = { -- not working
        cmd = {
          'jdt-language-server',
          '-configuration',
          '/home/user/.cache/jdtls/config',
          '-data',
          '/home/user/.cache/jdtls/workspace',
        },
      },
      -- previously did `npm i @astrojs/language-server`, now I use nixpkgs
      astro = {
        cmd = { 'npx', 'astro-ls', '--stdio' } -- for project-local installation
      },
      svelte = {},
      mesonlsp = {},
      hls = {},

      -- from vscode-langservers-extracted:
      cssls = {},
      html = {},
      jsonls = {}, -- no idea what this does ngl lol
      --eslint = {} -- do I want this (for js/ts)?

      tinymist = { -- typst
        settings = {
          formatterMode = 'typstyle', -- LSP format calls external formatter
          exportPdf = 'onType',
        },
      },

      powershell_es = {
        -- set in home/programs/coding.nix
        bundle_path = vim.env.PWSH_EDITOR_SERVICES_BUNDLE_PATH, 
      },

      dartls = {},
    }

    local lspconfig = require('lspconfig')
    local nvim_capabilities = vim.lsp.protocol.make_client_capabilities()
    local cmp_capabilities = require('cmp_nvim_lsp').default_capabilities()

    local default_opts = {
      capabilities = vim.tbl_deep_extend('force', nvim_capabilities, cmp_capabilities),
    }

    for server, opts in pairs(servers) do
      -- Any server-specific capabilities take precedence over our defaults
      local final_opts = vim.tbl_deep_extend('force', default_opts, opts)
      lspconfig[server].setup(final_opts)
    end

    -- Use LspAttach autocommand to only map the following keys
    -- after the language server attaches to the current buffer
    vim.api.nvim_create_autocmd('LspAttach', {
      group = vim.api.nvim_create_augroup('UserLspConfig', {}),
      callback = function(event)
        local tele = require('telescope.builtin')
        local function map(mode, lhs, rhs, opts)
          vim.keymap.set(mode, lhs, rhs, { buffer = event.buf })
        end
        map('n', 'gd', tele.lsp_definitions)
        map('n', 'gD', vim.lsp.buf.declaration)
        map('n', 'gtd', tele.lsp_type_definitions) -- bad keybind?
        map('n', 'gr', tele.lsp_references)
        map('n', 'gI', tele.lsp_implementations) -- `gi` is a thing already
        map('n', '<leader>ds', tele.lsp_document_symbols)
        map('n', '<leader>ws', tele.lsp_dynamic_workspace_symbols) -- consider https://www.reddit.com/r/neovim/comments/14ipa7j/difference_between_telescope_lsp_workspace/
        map('n', 'K', vim.lsp.buf.hover)
        map('n', '<leader>k', vim.lsp.buf.signature_help)
        map({ 'n', 'v' }, '<space>ca', vim.lsp.buf.code_action)
        map('n', '<leader>rn', vim.lsp.buf.rename)
      end,
    })

    -- standard diagnostic navigation
    vim.keymap.set('n', '[d', vim.diagnostic.goto_prev)
    vim.keymap.set('n', ']d', vim.diagnostic.goto_next)
    vim.keymap.set('n', 'gl', vim.diagnostic.open_float)
    -- all lsp diagnostics (workspace/document, qflist/loclist) are done via trouble.nvim

    local signs = { Error = ' ', Warn = ' ', Info = ' ', Hint = ' ' }

    for type, icon in pairs(signs) do
      local hl = 'DiagnosticSign' .. type
      vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = '' })
    end

    vim.diagnostic.config({
      underline = true,
      update_in_insert = true, -- do I want this as true?
      signs = {
        active = signs, -- show signs
      },
      virtual_text = {
        spacing = 4,
        source = 'never',
        -- prefix = "●" -- 󰝤 󱓻 󱓻 
      },
      severity_sort = true,
      float = {
        focusable = true,
        style = 'minimal',
        border = 'none',
        source = 'always',
        header = '',
        prefix = '',
      },
    })
  end,
}
