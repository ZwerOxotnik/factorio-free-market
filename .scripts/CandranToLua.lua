local candran = require("candran") -- https://github.com/Reuh/candran
local re = require("re") -- http://www.inf.puc-rio.br/~roberto/lpeg/re.html

local options = {
	target = "lua52", -- compiler target. "lua54", "lua53", "lua52", "luajit" or "lua51" (default is automatically selected based on the Lua version used).
	indentation = "\t", -- character(s) used for indentation in the compiled file.
	newline = "\n", -- character(s) used for newlines in the compiled file.
	variablePrefix = "__CAN_", -- Prefix used when Candran needs to set a local variable to provide some functionality (example: to load LuaJIT's bit lib when using bitwise operators).
	mapLines = true, -- if true, compiled files will contain comments at the end of each line indicating the associated line and source file. Needed for error rewriting.
	chunkname = "models/free-market.can", -- the chunkname used when running code using the helper functions and writing the line origin comments. Candran will try to set it to the original filename if it knows it.
	rewriteErrors = false, -- true to enable error rewriting when loading code using the helper functions. Will wrap the whole code in a xpcall().
	builtInMacros = true, -- false to disable built-in macros __*__
	preprocessorEnv = {}, -- environment to merge with the preprocessor environement
	import = {} -- list of modules to automatically import in compiled files (using #import("module",{loadLocal=false}))
}
-- Looks for "--#" except "--#region" and "--#endregion"
local PATTERN = "'--#'!(('region')/('endregion'))"


---@param source string
---@param destination string
local function preprocess_file(source, destination)
	-- Reads text
	local f = io.open(source)
	local contents = f:read("*a")
	f:close()

	-- A dirty workaround for compatibility with vscode
	contents = re.gsub(contents, PATTERN, '#')

	-- Runs preprocess
	print("Compiling " .. source .. " in " .. destination)
	local compiled, err = candran.make(contents, options)
	if not compiled then
		print(err)
		return
	end

	-- Writes code
	f = io.open(destination, "w+")
	f:write(compiled)
	f:close()
end


preprocess_file("./models/free-market.can", "./models/free-market.lua")

options.preprocessorEnv = {DEBUG = true}
preprocess_file("./models/free-market.can", "./models/free-market-debug.lua")
