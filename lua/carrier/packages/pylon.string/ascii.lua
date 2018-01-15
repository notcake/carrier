String.Ascii = {}

function String.Ascii.ToTitle (str)
	return string.upper (string.sub (str, 1, 1)) .. string.lower (string.sub (str, 2))
end

String.Ascii.ToLower = string.lower
String.Ascii.ToUpper = string.upper
