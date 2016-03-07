UI.AptSources = {}
UI.AptSources.Commands = {}

function UI.AptSources.RegisterCommand (packageManager)
	concommand.Add ("apt-sources",
		function (ply, cmd, args)
			local handler = UI.AptSources.Commands [args [1]]
			handler = handler or UI.AptSources.Commands ["help"]
			
			if #args == 0 then
				handler = UI.AptSources.Commands ["list"]
			end
			
			Task (handler, packageManager, ply, cmd, args):Run ()
		end
	)
end

function UI.AptSources.UnregisterCommand (packageManager)
	concommand.Remove ("apt-sources")
end

UI.AptSources.Commands ["help"] = function (packageManager, ply, cmd, args)
	local commands = KeyEnumerator (UI.AptSources.Commands):ToArray ()
	table.sort (commands)
	
	print (cmd .. " " .. table.concat (commands, "|"))
end

UI.AptSources.Commands ["add"] = function (packageManager, ply, cmd, args)
	if #args < 2 then
		print (cmd .. " add <url>")
		return
	end
	
	local url = table.concat (args, "", 2)
	local repository = packageManager:GetRepositoryByUrl (url)
	if repository then
		print (repository:GetUrl () .. " is already present!")
		return
	end
	
	local repository = packageManager:AddRepositoryFromUrl (url)
	repository:Update (print)
	print ("Added " .. repository:GetUrl () .. " at " .. repository:GetDirectory () .. ".")
end

UI.AptSources.Commands ["list"] = function (packageManager, ply, cmd, args)
	print (packageManager:GetRepositoryCount () .. " package repositories.")
	for repository in packageManager:GetRepositoryEnumerator () do
		print ("[" .. repository:GetDirectory () .. "] " .. repository:GetUrl ())
	end
end

UI.AptSources.Commands ["remove"] = function (packageManager, ply, cmd, args)
	if #args < 2 then
		print (cmd .. " remove <url or id>")
		return
	end
	
	local repositoryId = args [2]
	local repository = nil
	repository = repository or packageManager:GetRepositoryByDirectory (repositoryId)
	repository = repository or packageManager:GetRepositoryByUrl (repositoryId)
	if not repository then
		print ("Repository \"" .. repositoryId .. "\" does not exist!")
		return
	end
	
	packageManager:RemoveRepository (repository)
	print ("Removed " .. repository:GetUrl () .. " at " .. repository:GetDirectory () .. ".")
end
