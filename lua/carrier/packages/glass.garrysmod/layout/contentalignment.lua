ContentAlignment = {}

function ContentAlignment.FromAlignment (horizontalAlignment, verticalAlignment)
	local contentAlignment = nil
	if     horizontalAlignment == Glass.HorizontalAlignment.Left   then contentAlignment = 0
	elseif horizontalAlignment == Glass.HorizontalAlignment.Center then contentAlignment = 1
	elseif horizontalAlignment == Glass.HorizontalAlignment.Right  then contentAlignment = 2 end
	
	if     verticalAlignment == Glass.VerticalAlignment.Bottom then contentAlignment = contentAlignment + 0
	elseif verticalAlignment == Glass.VerticalAlignment.Center then contentAlignment = contentAlignment + 3
	elseif verticalAlignment == Glass.VerticalAlignment.Top    then contentAlignment = contentAlignment + 6 end
	
	return contentAlignment + 1
end

function ContentAlignment.ToHorizontalAlignment (contentAlignment)
	local contentAlignment = (contentAlignment - 1) % 3
	if     contentAlignment == 0 then return Glass.HorizontalAlignment.Left
	elseif contentAlignment == 1 then return Glass.HorizontalAlignment.Center
	elseif contentAlignment == 2 then return Glass.HorizontalAlignment.Right end
end

function ContentAlignment.ToVerticalAlignment (contentAlignment)
	local contentAlignment = math.floor ((contentAlignment - 1) / 3)
	if     contentAlignment == 0 then return Glass.VerticalAlignment.Bottom
	elseif contentAlignment == 1 then return Glass.VerticalAlignment.Center
	elseif contentAlignment == 2 then return Glass.VerticalAlignment.Top end
end
