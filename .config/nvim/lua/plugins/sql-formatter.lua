return {
	"andev0x/sql-formatter.nvim",
	ft = { "sql", "mysql", "plsql", "pgsql" },
	config = function()
	  vim.g.sqlformat_command = "sqlformat"
	  vim.g.sqlformat_options = "-r -k upper"
	  vim.g.sqlformat_prog = "sqlformat"
	end,
	init = function()
		require("sql-formatter").setup()
	end
}
