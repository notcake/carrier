UI.AptGet = {}
UI.AptGet.Commands = {}

function UI.AptGet.RegisterCommand (packageManager)
	concommand.Add ("apt-get",
		function (ply, cmd, args)
			local handler = UI.AptGet.Commands [args [1]]
			handler = handler or UI.AptSources.Commands ["help"]
			
			local textSink = nil
			if CLIENT or not ply or not ply:IsValid () then
				textSink = Text.ConsoleTextSink ()
			else
				textSink = Text.RemoteChatTextSink (ply)
			end
			
			Task (handler, packageManager, ply, cmd, args, textSink):Run ()
		end
	)
end

function UI.AptGet.UnregisterCommand (packageManager)
	concommand.Remove ("apt-get")
end

UI.AptGet.Commands ["help"] = function (packageManager, ply, cmd, args, textSink)
	local commands = KeyEnumerator (UI.AptGet.Commands):ToArray ()
	table.sort (commands)
	
	textSink:WriteLine (cmd .. " " .. table.concat (commands, "|"))
end

UI.AptGet.Commands ["moo"] = function (packageManager, ply, cmd, args, textSink)
	textSink:WriteLine (
		[[                 (__)        ]] .. "\n" ..
		[[                 (oo)        ]] .. "\n" ..
		[[           /------\/         ]] .. "\n" ..
		[[          / |    ||          ]] .. "\n" ..
		[[         *  /\---/\          ]] .. "\n" ..
		[[            ~~   ~~          ]] .. "\n" ..
		[[..."Have you mooed today?"...]]
	)
end

UI.AptGet.Commands ["update"] = function (packageManager, ply, cmd, args, textSink)
	textSink:WriteLine (packageManager:GetRepositoryCount () .. " package repositories.")
	
	local totalSize = 0
	local t0 = SysTime ()
	for repository in packageManager:GetRepositoryEnumerator () do
		local totalDownloaded = repository:Update (textSink)
		totalSize = totalSize + totalDownloaded
	end
	
	local dt = SysTime () - t0
	textSink:WriteLine ("Fetched " .. Util.FileSize.Format (totalSize) .. " in " .. Util.Duration.Format (dt) .. " (" .. Util.FileSize.Format (totalSize / dt) .. "/s)")
end

UI.AptGet.Commands ["upgrade"] = function (packageManager, ply, cmd, args, textSink)
end

UI.AptGet.Commands ["install"] = function (packageManager, ply, cmd, args, textSink)
end

UI.AptGet.Commands ["remove"] = function (packageManager, ply, cmd, args, textSink)
end

UI.AptGet.Commands ["list"] = function (packageManager, ply, cmd, args, textSink)
	textSink:WriteLine (packageManager:GetRepositoryCount () .. " package repositories.")
	for repository in packageManager:GetRepositoryEnumerator () do
		textSink:WriteLine ("[" .. repository:GetDirectory () .. "] " .. repository:GetUrl ())
		if repository:GetPackageCount () > 0 then
			for package in repository:GetPackageEnumerator () do
				textSink:WriteLine ("    " .. package:GetName ())
				if package:GetReleaseCount () > 0 then
					for release in package:GetReleaseEnumerator () do
						textSink:WriteLine ("        " .. release:GetVersionName ())
					end
				else
					textSink:WriteLine ("        No releases.")
				end
			end
		else
			textSink:WriteLine ("    No packages.")
		end
	end
end
