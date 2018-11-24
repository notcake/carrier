Glass.VerticalAlignment = Enum(
	{
		Top    = 0,
		Center = 1,
		Bottom = 2
	}
)

function Glass.VerticalAlignment.Invert(verticalAlignment)
	if     verticalAlignment == Glass.VerticalAlignment.Top    then return Glass.VerticalAlignment.Bottom
	elseif verticalAlignment == Glass.VerticalAlignment.Center then return Glass.VerticalAlignment.Center
	elseif verticalAlignment == Glass.VerticalAlignment.Bottom then return Glass.VerticalAlignment.Top end
end
