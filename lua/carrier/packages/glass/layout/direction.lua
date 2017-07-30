Glass.Direction = Enum (
	{
		Up    = 1,
		Down  = 2,
		Left  = 4,
		Right = 8
	}
)

function Glass.Direction.ToOrientation (direction)
	if     direction == Glass.Direction.Up    then return Glass.Orientation.Vertical
	elseif direction == Glass.Direction.Down  then return Glass.Orientation.Vertical
	elseif direction == Glass.Direction.Left  then return Glass.Orientation.Horizontal
	elseif direction == Glass.Direction.Right then return Glass.Orientation.Horizontal end
end

function Glass.Direction.Invert (direction)
	if     direction == Glass.Direction.Up    then return Glass.Direction.Down
	elseif direction == Glass.Direction.Down  then return Glass.Direction.Up
	elseif direction == Glass.Direction.Left  then return Glass.Direction.Right
	elseif direction == Glass.Direction.Right then return Glass.Direction.Left end
end
