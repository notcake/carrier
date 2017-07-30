Glass.HorizontalAlignment = Enum (
	{
		Left   = 0,
		Center = 1,
		Right  = 2
	}
)

function Glass.HorizontalAlignment.Invert (horizontalAlignment)
	if     horizontalAlignment == Glass.HorizontalAlignment.Left   then return Glass.HorizontalAlignment.Right
	elseif horizontalAlignment == Glass.HorizontalAlignment.Center then return Glass.HorizontalAlignment.Center
	elseif horizontalAlignment == Glass.HorizontalAlignment.Right  then return Glass.HorizontalAlignment.Left end
end
