UI.AptSources = {}

function UI.AptSources.RegisterCommand (packageManager)
	concommand.Add ("apt-sources",
		function (ply, cmd, args, lol)
			if args [1] == "add" then
				if #args < 2 then
					print (cmd .. " add <url>")
					return
				end
				
				local url = table.concat (args, "", 2)
				if packageManager:GetRepositoryByUrl (url) then
					local repository = packageManager:GetRepositoryByUrl (url)
					print (repository:GetUrl () .. " is already present!")
					return
				end
				
				local repository = packageManager:AddRepositoryFromUrl (url)
				print ("Added " .. repository:GetUrl () .. " at " .. repository:GetDirectory () .. ".")
			elseif args [1] == "list" then
				print (packageManager:GetRepositoryCount () .. " package repositories.")
				for repository in packageManager:GetRepositoryEnumerator () do
					print ("[" .. repository:GetDirectory () .. "] " .. repository:GetUrl ())
				end
			else
				print (cmd .. " add|list|remove")
			end
		end
	)
end

function UI.AptSources.UnregisterCommand (packageManager)
	concommand.Remove ("apt-sources")
end
