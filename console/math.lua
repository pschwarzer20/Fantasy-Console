
math = math or {}

function math.Round( num, idp )
	local mult = 10 ^ ( idp or 0 )
	return math.floor( num * mult + 0.5 ) / mult
end

function math.Clamp( _in, low, high )
	return math.min( math.max( _in, low ), high )
end

function math.Random(min, max)
	return love.math.random(min, max)
end

math.Max = math.max
math.Min = math.min
