Glass.Interpolators = {}

function Glass.Interpolators.Step ()
	return function (t)
		return 1
	end
end

function Glass.Interpolators.Linear ()
	return function (t)
		return t
	end
end

function Glass.Interpolators.ExponentialDecay (finalError)
	local dy = finalError
	local k = -math.log (finalError)
	return function (t)
		return (1 - math.exp (-k * t)) / (1 - finalError)
	end
end

function Glass.Interpolators.Exponential (initialError)
	local dy = initialError
	local k = -math.log (initialError)
	return function (t)
		return (math.exp (-k * (1 - t)) - initialError) / (1 - initialError)
	end
end
