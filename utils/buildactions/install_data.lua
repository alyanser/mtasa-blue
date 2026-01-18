require 'utils'

premake.modules.install_data = {}

-- Config variables
local WIN_BIN_DIR = "Bin"
local LINUX_BIN_DIR = "linux-bin"
local DATA_DIR = "Shared/data/MTA San Andreas"

newaction {
	trigger = "install_data",
	description = "Installs data files",

	execute = function()
		local BIN_DIR = os.host() == "windows" and WIN_BIN_DIR or LINUX_BIN_DIR

		-- Make Bin directory if not exists
		local success, message = os.mkdir(BIN_DIR)

		if not success then
			errormsg("ERROR: Couldn't create Bin directory", "\n"..message)
			os.exit(1)
			return
		end

		-- Copy data files
		if os.host() == "windows" then
			local success, message = os.copydir(DATA_DIR, BIN_DIR)
			if not success then
				errormsg("ERROR: Couldn't create copy data directory", "\n"..message)
				os.exit(1)
				return
			end
		end

		-- Copy configs if they don't already exist
		local success, message = os.copydir("Server/mods/deathmatch", BIN_DIR.."/server/mods/deathmatch", "*.conf", false, true)
		if not success then
			errormsg("ERROR: Couldn't copy server config files", "\n"..message)
			os.exit(1)
			return
		end

		local success, message = os.copydir("Server/mods/deathmatch", BIN_DIR.."/server/mods/deathmatch", "mtaserver.conf.template", false, true)
		if not success then
			errormsg("ERROR: Couldn't copy server config files", "\n"..message)
			os.exit(1)
			return
		end

		local success, message = os.copydir("Server/mods/deathmatch", BIN_DIR.."/server/mods/deathmatch", "*.xml", false, true)
		if not success then
			errormsg("ERROR: Couldn't copy server xml files", "\n"..message)
			os.exit(1)
			return
		end

		-- Make sure server/x64 directory exists
		local success, message = os.mkdir(BIN_DIR.."/server/x64")
		if not success then
			errormsg("ERROR: Couldn't create server/x64 directory", "\n"..message)
			os.exit(1)
			return
		end

		if os.host() == "windows" then
			local success = os.copyfile(BIN_DIR.."/../net/netc.dll", BIN_DIR.."/mta/netc.dll")
			success = success and os.copyfile(BIN_DIR.."/../net/net.dll", BIN_DIR.."/server/net.dll")

			if not success then
				os.exit(1)
				return
			end
		else
			local success = os.copyfile(BIN_DIR.."/../net/net.so", BIN_DIR.."/server/net.so")
			local success = os.copyfile(BIN_DIR.."/../net/net.so", BIN_DIR.."/server/x64/net.so")

			if not success then
				os.exit(1)
				return
			end
		end
	end
}

return premake.modules.install_data
