return {
	-- Main LSP Configuration
	{
		"neovim/nvim-lspconfig",
		dependencies = {
			{ "williamboman/mason.nvim", config = true },
			"williamboman/mason-lspconfig.nvim",
			"WhoIsSethDaniel/mason-tool-installer.nvim",
			{ "j-hui/fidget.nvim", opts = {} },
			"hrsh7th/cmp-nvim-lsp",
			"nvim-telescope/telescope.nvim",
		},
		config = function()
			-- LSP keybindings on attach
			vim.api.nvim_create_autocmd("LspAttach", {
				group = vim.api.nvim_create_augroup("kickstart-lsp-attach", { clear = true }),
				callback = function(event)
					local map = function(keys, func, desc, mode)
						mode = mode or "n"
						vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
					end
					map("gd", require("telescope.builtin").lsp_definitions, "[G]oto [D]efinition")
					map("gr", require("telescope.builtin").lsp_references, "[G]oto [R]eferences")
					map("gI", require("telescope.builtin").lsp_implementations, "[G]oto [I]mplementation")
					map("<leader>cs", require("telescope.builtin").lsp_document_symbols, "[D]ocument [S]ymbols")
					map("<leader>cf", vim.lsp.buf.format, "[C]ode [F]ormat", "n")
					map(
						"<leader>cw",
						require("telescope.builtin").lsp_dynamic_workspace_symbols,
						"[W]orkspace [S]ymbols"
					)
					map("<leader>cn", vim.lsp.buf.rename, "[R]e[n]ame")
					map("<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction", { "n", "x" })
					map("gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")
				end,
			})

			-- Setup LSP capabilities for autocompletion with cmp-nvim-lsp
			local capabilities = vim.lsp.protocol.make_client_capabilities()
			capabilities = vim.tbl_deep_extend("force", capabilities, require("cmp_nvim_lsp").default_capabilities())

			-- Define LSP servers and their settings
			local servers = {
				lua_ls = {
					settings = {
						Lua = {
							runtime = { version = "LuaJIT" },
							diagnostics = {
								globals = { "vim" },
								disable = { "missing-fields" },
							},
							workspace = {
								library = vim.api.nvim_get_runtime_file("", true),
								checkThirdParty = false,
								-- Prevent prompts about third-party libraries
								ignoreDir = { "tmp", ".git", "undo" },
							},
							completion = { callSnippet = "Replace" },
							telemetry = { enable = false },
						},
					},
				},
				ts_ls = {
					filetypes = { "typescript", "javascript", "typescriptreact", "javascriptreact" },
					root_dir = require("lspconfig.util").root_pattern(
						"tsconfig.json",
						"package.json",
						"jsconfig.json",
						".git"
					),
					settings = {
						diagnostics = {
							ignoredCodes = { 6133, 6196 }, -- Example: Ignore unused variable and import warnings
						},
						typescript = {
							inlayHints = {
								includeInlayParameterNameHints = "all",
								includeInlayParameterNameHintsWhenArgumentMatchesName = false,
								includeInlayFunctionParameterTypeHints = true,
								includeInlayVariableTypeHints = true,
								includeInlayPropertyDeclarationTypeHints = true,
								includeInlayFunctionLikeReturnTypeHints = true,
								includeInlayEnumMemberValueHints = true,
							},
						},
					},
				},
			}

			-- Setup Mason
			require("mason").setup()

			-- Ensure tools and LSP servers are installed via Mason
			local ensure_installed = vim.tbl_keys(servers or {})
			vim.list_extend(ensure_installed, {
				"stylua", -- Formatter for Lua
			})
			require("mason-tool-installer").setup({ ensure_installed = ensure_installed })

			-- Setup mason-lspconfig to handle LSP server installation and configuration
			require("mason-lspconfig").setup({
				ensure_installed = { "lua_ls" }, -- This tells Mason to install the Lua language server (you can add more)
				automatic_enable = true, -- This enables the language server automatically
				handlers = {
					function(server_name)
						local server = servers[server_name] or {}
						server.capabilities = server.capabilities or {}
						server.capabilities = vim.tbl_deep_extend("force", {}, server.capabilities)
						require("lspconfig")[server_name].setup(server)
					end,
				},
			})
		end,
	},
}
