return {
	"nvim-treesitter/nvim-treesitter",
	build = ":TSUpdate",
	config = function () 
		local configs = require("nvim-treesitter.configs")

		configs.setup({
			ensure_installed = { "go", "lua", "vim", "vimdoc", "query", "html", "css", "javascript", "zig" },
			sync_install = false,
			highlight = { 
				enable = true,
				additional_vim_regex_highlighting = false,
			},
			indent = { enable = true },  
			auto_install = true,
		})
	end
}

