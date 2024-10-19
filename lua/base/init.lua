--Basic settings

vim.g.mapleader = " "

vim.wo.relativenumber = true
vim.wo.number = true
--Mappings
vim.keymap.set("n", "<leader>e", vim.cmd.NvimTreeFocus)
vim.keymap.set("n", "<C-n>", vim.cmd.NvimTreeToggle)
vim.keymap.set("n", "<leader>1", vim.cmd.bfirst)
vim.keymap.set("n", "<leader>0", vim.cmd.blast)
vim.keymap.set("n", "<Tab>", vim.cmd.bnext)
vim.keymap.set("n", "<S-Tab>", vim.cmd.bprevious)
vim.keymap.set("n", "<leader>b", vim.cmd.DapToggleBreakpoint)
vim.keymap.set("n", "<leader>ds", vim.cmd.DapSidebar)
vim.keymap.set("n", "<leader>dp", function()
	require("dap-python").test_method()
end)
vim.keymap.set("n", "<leader>o", "o<Esc>k")
vim.keymap.set("n", "<leader>x", vim.cmd.bdelete)

vim.o.timeoutlen = 2000
vim.opt.clipboard = "unnamedplus"
-- Lazy requirement
require("base.plugins.lazy")
require("configs.oilConfig")

vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory" })
-- local jdtls_config = {
-- 	bundles = {}
-- }

-- require('spring_boot').setup({})
-- -- 添加 spring-boot jdtls 扩展 jar 包
-- vim.g.spring_boot = {
-- 	jdt_extensions_path = nil, -- 默认使用 ~/.vscode/extensions/vmware.vscode-spring-boot-x.xx.x
-- 	jdt_extensions_jars = {
-- 		"io.projectreactor.reactor-core.jar",
-- 		"org.reactivestreams.reactive-streams.jar",
-- 		"jdt-ls-commons.jar",
-- 		"jdt-ls-extension.jar",
-- 	},
-- }
-- require('spring_boot').setup({
-- 	ls_path = nil, -- 默认使用 ~/.vscode/extensions/vmware.vscode-spring-boot-x.xx.x
-- 	jdtls_name = "jdtls",
-- 	log_file = nil,
-- 	java_cmd = nil,
-- })
-- vim.list_extend(jdtls_config.bundles, require("spring_boot").java_extensions())
