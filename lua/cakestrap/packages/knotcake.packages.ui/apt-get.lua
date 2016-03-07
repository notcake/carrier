UI.AptGet = {}
UI.AptGet.Commands = {}

function UI.AptGet.RegisterCommand (packageManager)
	concommand.Add ("apt-get",
		function (ply, cmd, args, lol)
			local handler = UI.AptGet.Commands [args [1]]
			handler = handler or UI.AptSources.Commands ["help"]
			
			Task (handler, packageManager, ply, cmd, args):Run ()
		end
	)
end

function UI.AptGet.UnregisterCommand (packageManager)
	concommand.Remove ("apt-get")
end

UI.AptGet.Commands ["help"] = function (packageManager, ply, cmd, args)
	local commands = KeyEnumerator (UI.AptGet.Commands):ToArray ()
	table.sort (commands)
	
	print (cmd .. " " .. table.concat (commands, "|"))
end

UI.AptGet.Commands ["moo"] = function (packageManager, ply, cmd, args)
	print (
		[[                 (__)        ]] .. "\n" ..
		[[                 (oo)        ]] .. "\n" ..
		[[           /------\/         ]] .. "\n" ..
		[[          / |    ||          ]] .. "\n" ..
		[[         *  /\---/\          ]] .. "\n" ..
		[[            ~~   ~~          ]] .. "\n" ..
		[[..."Have you mooed today?"...]]
	)
end

UI.AptGet.Commands ["update"] = function (packageManager, ply, cmd, args)
	print (packageManager:GetRepositoryCount () .. " package repositories.")
	
	local totalSize = 0
	local t0 = SysTime ()
	for repository in packageManager:GetRepositoryEnumerator () do
		local httpResponse = repository:Update (print)
		if httpResponse:GetContent () then
			totalSize = totalSize + #httpResponse:GetContent ()
		end
	end
	
	local dt = SysTime () - t0
	print ("Fetched " .. Util.FileSize.Format (totalSize) .. " in " .. Util.Duration.Format (dt) .. " (" .. Util.FileSize.Format (totalSize / dt) .. "/s)")
end

UI.AptGet.Commands ["upgrade"] = function (packageManager, ply, cmd, args)
end

UI.AptGet.Commands ["install"] = function (packageManager, ply, cmd, args)
end

UI.AptGet.Commands ["remove"] = function (packageManager, ply, cmd, args)
end
