return {
	{
		"nvim-telescope/telescope.nvim",
		tag = "0.1.6",
		dependencies = { "nvim-lua/plenary.nvim" },
		opts = function()
			return require("configs.telescope")
		end,
		--function(_,opts)
		--	    require("telescope").setup(opts)
		--  end
	},
	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		config = function()
			local configs = require("nvim-treesitter.configs")
			configs.setup({
				ensure_installed = {
					"vim",
					"lua",
					"vimdoc",
					"html",
					"css",
					"java",
					"javascript",
					"typescript",
					"tsx",
					"c",
					"rust",
					"svelte",
					"cpp",
					"python",
					"yaml",
					"zig",
				},
				sync_install = false,
				highlight = { enable = true },
				indent = { enable = true },
			})
		end,
	},
	{
		"EdenEast/nightfox.nvim",
		lazy = false, -- make sure we load this during startup if it is your main colorscheme
		priority = 1000, -- make sure to load this before all the other start plugins
		config = function()
			-- load the colorscheme here
			--vim.cmd.colorscheme("duskfox")
		end,
	},
	{
		"williamboman/mason.nvim",
		cmd = { "Mason", "MasonInstall", "MasonInstallAll", "MasonUpdate", "MasonUninstallAll" },
		opts = function()
			return require("configs.mason")
		end,
		config = function(_, opts)
			require("mason").setup(opts)
			vim.api.nvim_create_user_command("MasonInstallAll", function()
				if opts.ensure_installed and #opts.ensure_installed > 0 then
					vim.cmd("MasonInstall " .. table.concat(opts.ensure_installed, " "))
				end
			end, {})
			vim.g.mason_binaries_list = opts.ensure_installed
		end,
	},
	{ "williamboman/mason-lspconfig.nvim" },
	{
		"neovim/nvim-lspconfig",
		dependencies = {
			{ "williamboman/mason.nvim" },
			{ "williamboman/mason-lspconfig.nvim" },
		},
		config = function()
			require("configs.lspconfig")
		end,
	},
	{
		"nvim-tree/nvim-tree.lua",
		version = "*",
		lazy = false,
		dependencies = {
			"nvim-tree/nvim-web-devicons",
		},
		opts = function()
			return require("configs.nvimtree")
		end,
		config = function(_, opts)
			require("nvim-tree").setup(opts)
		end,
	},
	{
		-- Thank you to Josean for his video https://youtu.be/NL8D8EkphUw?si=3ZAt7ZJ0S1HuDJ_M
		"hrsh7th/nvim-cmp",
		event = "InsertEnter",
		dependencies = {
			"hrsh7th/cmp-nvim-lsp",
			"hrsh7th/cmp-buffer",
			"hrsh7th/cmp-path",
			"L3MON4D3/LuaSnip",
			"saadparwaiz1/cmp_luasnip",
			"rafamadriz/friendly-snippets",
		},
		opts = function()
			return require("configs.nvim-cmp")
		end,
		config = function()
			local cmp = require("cmp")
			local luasnip = require("luasnip")
			require("luasnip.loaders.from_vscode").lazy_load()

			cmp.setup({
				completion = {
					completeopt = "menu,menuone,preview,noselect",
				},
				snippet = { -- configure how nvim-mp interacts with snippet engine
					expand = function(args)
						luasnip.lsp_expand(args.body)
					end,
				},
				mapping = cmp.mapping.preset.insert({
					["<C-K>"] = cmp.mapping.select_prev_item(), --previous suggestion
					["<C-j>"] = cmp.mapping.select_next_item(), -- next suggestion
					["<C-b>"] = cmp.mapping.scroll_docs(-4),
					["<C-f>"] = cmp.mapping.scroll_docs(4),
					["<C-Space>"] = cmp.mapping.complete(), -- show completion suggestions
					["<C-e>"] = cmp.mapping.abort(), -- close completion window
					["<CR>"] = cmp.mapping.confirm({ select = false }),
				}),
				sources = cmp.config.sources({
					{
						name = "copilot",
						group_index = 1,
						priority = 100,
					},
					{ name = "nvim_lsp" },
					{ name = "luasnip" },
					{ name = "buffer" },
					{ name = "path" },
				}),
			})
		end,
	},
	{
		"stevearc/conform.nvim",
		event = { "BufReadPre", "BufNewFile" },
		opts = function()
			return require("configs.formating")
		end,
		config = function(_, opts)
			require("conform").setup(opts)
		end,
	},
	{
		"rust-lang/rust.vim",
		ft = "rust",
		init = function()
			vim.g.rustfmt_autosave = 1
		end,
	},
	{
		"mrcjkb/rustaceanvim",
		version = "^4", -- Recommended
		lazy = false, -- This plugin is already lazy
		ft = "rust",
		dependencies = {
			"neovim/nvim-lspconfig",
		},
		config = function()
			local bufnr = vim.api.nvim_get_current_buf()
			vim.keymap.set("n", "<leader>a", function()
				vim.cmd.RustLsp("codeAction") -- supports rust-analyzer's grouping
				vim.cmd.RustLsp("debug")
				vim.cmd.RustLsp("debuggables")
				-- or, to run the previous debuggable:
				vim.cmd.RustLsp({ "debuggables", bang = true })
				-- or, to override the executable's args:
				vim.cmd.RustLsp({ "debuggables", "arg1", "arg2" })
				-- or vim.lsp.buf.codeAction() if you don't want grouping.
			end, { silent = true, buffer = bufnr })
			vim.api.nvim_create_user_command("RustDebuggables", function()
				vim.cmd("RustLsp debuggables")
			end, {})
		end,
	},
	{
		"mfussenegger/nvim-dap",
		--lldb is required for debuggin to work:
		--vim.keymap.set("n", "<leader>ds", vim.cmd.DapSidebar)
		config = function()
			vim.api.nvim_create_user_command("DapSidebar", function()
				local widgets = require("dap.ui.widgets")
				local sidebar = widgets.sidebar(widgets.scopes)
				sidebar.open()
			end, {})
		end,
	},
	{
		"mfussenegger/nvim-dap-python",
		ft = "python",
		dependencies = {
			"mfussenegger/nvim-dap",
		},
		config = function()
			local path = "~/.local/share/nvim/mason/packages/debugpy/venv/bin/python"
			require("dap-python").setup(path)
		end,
	},
	{
		"mxsdev/nvim-dap-vscode-js",
		dependencies = {
			"mfussenegger/nvim-dap",
		},
		opts = function()
			return require("configs.dap_js")
		end,
		config = function(_, opts)
			require("dap-vscode-js").setup(opts)
		end,
	},
	{
		"oxfist/night-owl.nvim",
		lazy = false, -- make sure we load this during startup if it is your main colorscheme
		priority = 1000, -- make sure to load this before all the other start plugins
		config = function()
			-- load the colorscheme here
			require("night-owl").setup() -- You can pass in your personal settings here.
			vim.cmd.colorscheme("night-owl")
		end,
	},
	{
		"nvim-lualine/lualine.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		opts = function()
			return require("configs.lualine")
		end,
		config = function(_, opts)
			require("lualine").setup(opts)
		end,
	},
	{
		"stevearc/oil.nvim",
		---@module 'oil'
		---@type oil.SetupOpts
		opts = {},

		-- Optional dependencies
		dependencies = { { "echasnovski/mini.icons", opts = {} } },
		-- dependencies = { "nvim-tree/nvim-web-devicons" }, -- use if prefer nvim-web-devicons
	},
	{
		"kdheepak/lazygit.nvim",
		cmd = {
			"LazyGit",
			"LazyGitConfig",
			"LazyGitCurrentFile",
			"LazyGitFilter",
			"LazyGitFilterCurrentFile",
		},
		-- optional for floating window border decoration
		dependencies = {
			"nvim-lua/plenary.nvim",
		},
		-- setting the keybinding for LazyGit with 'keys' is recommended in
		-- order to load the plugin when the command is run for the first time
		keys = {
			{ "<leader>lg", "<cmd>LazyGit<cr>", desc = "LazyGit" },
		},
	},
	{
		"zbirenbaum/copilot.lua",
		cmd = "Copilot",
		build = ":Copilot auth",
		opts = {
			suggestion = { enabled = false },
			panel = { enabled = false },
			filetypes = {
				markdown = true,
				help = true,
			},
		},
	},
	{
		"nvim-cmp",
		dependencies = {
			{
				"zbirenbaum/copilot-cmp",
				dependencies = "copilot.lua",
				opts = {},
				config = function(_, opts)
					local copilot_cmp = require("copilot_cmp")
					copilot_cmp.setup(opts)
					-- attach cmp source whenever copilot attaches
					-- fixes lazy-loading issues with the copilot cmp source
					-- LazyVim.lsp.on_attach(function(client)
					-- 	copilot_cmp._on_insert_enter({})
					-- end, "copilot")
				end,
			},
		},
		---@param opts cmp.ConfigSchema
		opts = function(_, opts)
			-- table.insert(opts.sources, 1, {
			-- 	name = "copilot",
			-- 	group_index = 1,
			-- 	priority = 100,
			-- })
		end,
	},
	{
		"zbirenbaum/copilot-cmp",
		dependencies = "copilot.lua",
		opts = {},
		config = function(_, opts)
			local copilot_cmp = require("copilot_cmp")
			copilot_cmp.setup(opts)
			-- attach cmp source whenever copilot attaches
			-- fixes lazy-loading issues with the copilot cmp source
			-- LazyVim.lsp.on_attach(function(client)
			-- 	copilot_cmp._on_insert_enter({})
			-- end, "copilot")
		end,
	},
	{
		"CopilotC-Nvim/CopilotChat.nvim",
		branch = "canary",
		cmd = "CopilotChat",
		opts = function()
			local user = vim.env.USER or "User"
			user = user:sub(1, 1):upper() .. user:sub(2)
			return {
				model = "gpt-4",
				auto_insert_mode = true,
				show_help = true,
				question_header = "  " .. user .. " ",
				answer_header = "  Copilot ",
				window = {
					width = 0.4,
				},
				selection = function(source)
					local select = require("CopilotChat.select")
					return select.visual(source) or select.buffer(source)
				end,
			}
		end,
		keys = {
			{ "<c-s>",     "<CR>", ft = "copilot-chat", desc = "Submit Prompt", remap = true },
			{ "<leader>a", "",     desc = "+ai",        mode = { "n", "v" } },
			{
				"<leader>aa",
				function()
					return require("CopilotChat").toggle()
				end,
				desc = "Toggle (CopilotChat)",
				mode = { "n", "v" },
			},
			{
				"<leader>ax",
				function()
					return require("CopilotChat").reset()
				end,
				desc = "Clear (CopilotChat)",
				mode = { "n", "v" },
			},
			{
				"<leader>aq",
				function()
					local input = vim.fn.input("Quick Chat: ")
					if input ~= "" then
						require("CopilotChat").ask(input)
					end
				end,
				desc = "Quick Chat (CopilotChat)",
				mode = { "n", "v" },
			},
			-- Show help actions with telescope
			--   { "<leader>ad", M.pick "help", desc = "Diagnostic Help (CopilotChat)", mode = { "n", "v" } },
			--   -- Show prompts actions with telescope
			--   { "<leader>ap", M.pick "prompt", desc = "Prompt Actions (CopilotChat)", mode = { "n", "v" } },
		},
		config = function(_, opts)
			local chat = require("CopilotChat")
			require("CopilotChat.integrations.cmp").setup()

			vim.api.nvim_create_autocmd("BufEnter", {
				pattern = "copilot-chat",
				callback = function()
					vim.opt_local.relativenumber = false
					vim.opt_local.number = false
				end,
			})

			chat.setup(opts)
		end,
	},
	{
		"JavaHello/spring-boot.nvim",
		ft = "java",
		dependencies = {
			"mfussenegger/nvim-jdtls", -- or nvim-java, nvim-lspconfig
			"ibhagwan/fzf-lua", -- 可选
		},
	},
	{
		"elmcgill/springboot-nvim",
		depedencies = {
			"neovim/nvim-lspconfig",
			"mfussenegger/nvim-jdtls",
			"nvim-tree/nvim-tree.lua",
		},
		config = function()
			local springboot_nvim = require("springboot-nvim")
			vim.keymap.set('n', '<leader>Jr', springboot_nvim.boot_run, { desc = "Spring Boot Run Project" })
			vim.keymap.set('n', '<leader>Jc', springboot_nvim.generate_class, { desc = "Java Create Class" })
			vim.keymap.set('n', '<leader>Ji', springboot_nvim.generate_interface,
				{ desc = "Java Create Interface" })
			vim.keymap.set('n', '<leader>Je', springboot_nvim.generate_enum, { desc = "Java Create Enum" })

			springboot_nvim.setup({})
		end
	}

}
