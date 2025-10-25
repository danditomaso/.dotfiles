return {
	{
		"pmizio/typescript-tools.nvim",
		dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
		ft = { "typescript", "typescriptreact", "javascript", "javascriptreact" },
		config = function()
			local api = require("typescript-tools.api")
			require("typescript-tools").setup({
				on_attach = function(client, buffer_number)
					require("twoslash-queries").attach(client, buffer_number)
					require("dand.keymaps").map_lsp_keybinds(buffer_number)
				end,
				root_dir = function(fname)
					local util = require("lspconfig.util")
					-- First try to find tsconfig.json in current directory or parent
					local root = util.root_pattern("tsconfig.json")(fname)
					-- If not found, try package.json, then .git
					return root or util.root_pattern("package.json", "jsconfig.json")(fname) or util.find_git_ancestor(fname)
				end,
				single_file_support = false,
				settings = {
					-- tsserver_path = "~/.bun/bin/tsgo",
					-- Explicitly use local TypeScript installation
					tsserver_path = nil,
					-- Performance: separate diagnostic server for large projects
					separate_diagnostic_server = true,
					-- When to publish diagnostics
					publish_diagnostic_on = "insert_leave",
					-- JSX auto-closing tags
					jsx_close_tag = {
						enable = true,
						filetypes = { "javascriptreact", "typescriptreact" },
					},
					tsserver_file_preferences = {
						includeInlayParameterNameHints = "all",
						includeInlayParameterNameHintsWhenArgumentMatchesName = true,
						includeInlayVariableTypeHints = true,
						includeInlayVariableTypeHintsWhenTypeMatchesName = true,
						includeInlayPropertyDeclarationTypeHints = true,
						includeInlayFunctionParameterTypeHints = true,
						includeInlayEnumMemberValueHints = true,
						includeInlayFunctionLikeReturnTypeHints = true,
					},

					tsserver_format_options = {
						insertSpaceAfterOpeningAndBeforeClosingEmptyBraces = true,
						semicolons = "insert",
					},
					complete_function_calls = true,
					include_completions_with_insert_text = true,
					code_lens = "off",
					disable_member_code_lens = true,
					tsserver_max_memory = 12288,
				},
			})
		end,
	},
}
