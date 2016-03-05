UI.AptGet = {}

function UI.AptGet.RegisterCommand (packageManager)
	concommand.Add ("apt-get",
		function (ply, cmd, args, lol)
			if args [1] == "moo" then
				print (
					[[                 (__)        ]] .. "\n" ..
					[[                 (oo)        ]] .. "\n" ..
					[[           /------\/         ]] .. "\n" ..
					[[          / |    ||          ]] .. "\n" ..
					[[         *  /\---/\          ]] .. "\n" ..
					[[            ~~   ~~          ]] .. "\n" ..
					[[..."Have you mooed today?"...]]
				)
			elseif args [1] == "update" then
				Task (
					function ()
						print (packageManager:GetRepositoryCount () .. " package repositories.")
						for repository in packageManager:GetRepositoryEnumerator () do
							local httpResponse = repository:Update ()
							if httpResponse:IsSuccess () then
								print ("Hit " .. repository:GetUrl () .. " " .. repository:GetDirectory ())
							else
								print ("Err " .. repository:GetUrl () .. " " .. repository:GetDirectory ())
								print ("\tHTTP " .. httpResponse:GetCode () .. " " .. string.upper (httpResponse:GetMessage ()))
							end
						end
					end
				):Run ()
			elseif args [1] == "list" then
				print (packageManager:GetRepositoryCount () .. " package repositories.")
				for repository in packageManager:GetRepositoryEnumerator () do
					print ("[" .. repository:GetDirectory () .. "] " .. repository:GetUrl ())
				end
			else
				print (cmd .. " update|upgrade|install|remove")
			end
		end
	)
end

function UI.AptGet.UnregisterCommand (packageManager)
	concommand.Remove ("apt-get")
end
