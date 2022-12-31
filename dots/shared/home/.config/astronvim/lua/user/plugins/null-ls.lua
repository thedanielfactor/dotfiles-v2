-- -- Formatting and linting
-- -- https://github.com/jose-elias-alvarez/null-ls.nvim
-- local status_ok, null_ls = pcall(require, "null-ls")
-- if status_ok then
-- 	local builtins = null_ls.builtins
--
-- 	return {
-- 		sources = {
-- 			-- Completion
-- 			-- builtins.completion.spell,
-- 			-- Formatting
-- 			builtins.formatting.stylua, -- Lua
-- 			builtins.formatting.shfmt, -- Shell
-- 			builtins.formatting.fish_indent, -- fish
-- 			builtins.formatting.clang_format, -- Clang supported languages
-- 			builtins.formatting.cmake_format, -- Cmake
-- 			builtins.formatting.csharpier, -- Csharp
-- 			builtins.formatting.eslint_d, -- Eslint
-- 			builtins.formatting.jq, -- Json jq
-- 			builtins.formatting.prettierd.with({
-- 				filetypes = {
-- 					"javascript", "typescript", "css", "scss", "html", "yaml",
-- 					"markdown", "json"
-- 				}
-- 			}), -- Linters
-- 			builtins.diagnostics.tsc, -- Typescript
-- 			builtins.diagnostics.shellcheck.with({
-- 				diagnostics_format = "#{m} [#{c}]"
-- 			}),
-- 			builtins.diagnostics.luacheck.with({ extra_args = { "--global vim" } }),
-- 			builtins.diagnostics.fish, -- fish
-- 			-- Code Actions
-- 			builtins.code_actions.gitsigns, builtins.code_actions.gitrebase,
-- 			builtins.code_actions.shellcheck, -- Hover
-- 			builtins.hover.dictionary
-- 		},
-- 		on_attach = function(client)
-- 			-- Format on save
-- 			if client.server_capabilities.document_formatting then
-- 				vim.api.nvim_create_autocmd("BufWritePre", {
-- 					desc = "Auto format before save",
-- 					pattern = "<buffer>",
-- 					callback = function()
-- 						vim.lsp.buf.format({ async = true })
-- 					end
-- 				})
-- 			end
-- 		end
-- 	}
-- end
