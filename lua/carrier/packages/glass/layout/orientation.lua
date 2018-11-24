Glass.Orientation = Enum(
	{
		Horizontal = 1,
		Vertical   = 2
	}
)

function Glass.Orientation.Complement(orientation)
	if     orientation == Glass.Orientation.Horizontal then return Glass.Orientation.Vertical
	elseif orientation == Glass.Orientation.Vertical   then return Glass.Orientation.Horizontal end
end
