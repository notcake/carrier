Util.Duration = {}

local timeUnits = { "ns", "µs", "ms", "s", "ks", "Ms", "Gs", "Ts", "Ps", "Es", "Zs", "Ys" }
function Util.Duration.Format (duration)
	duration = duration * 1e9
	
	local unitIndex = 1
	while duration >= 1000 and timeUnits [unitIndex + 1] do
		duration = duration / 1000
		unitIndex = unitIndex + 1
	end
	
	if duration == math.floor (duration) then
		return string.format ("%d %s", duration, timeUnits [unitIndex])
	else
		return string.format ("%.2f %s", duration, timeUnits [unitIndex])
	end
end
