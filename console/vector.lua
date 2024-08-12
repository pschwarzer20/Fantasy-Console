
-- vector class
vector = {}
vector.__index = vector

-- Constructor
function vector.new(x, y)
    local self = setmetatable({}, vector)
    self.x = x or 0
    self.y = y or 0

    return self
end

-- Addition
function vector.__add(a, b)
    return vector.new(a.x + b.x, a.y + b.y)
end

-- Subtraction
function vector.__sub(a, b)
  	return vector.new(a.x - b.x, a.y - b.y)
end

-- Multiplication
function vector.__mul(a, b)
	if type(a) == "number" then
		return vector.new(a * b.x, a * b.y)
	elseif type(b) == "number" then
		return vector.new(b * a.x, b * a.y)
	else
		return vector.new(a.x * b.x, a.y * b.y)
	end
end

-- Division
function vector.__div(a, b)
	if type(b) == "number" then
		return vector.new(a.x / b, a.y / b)
	else
		return vector.new(a.x / b.x, a.y / b.y)
	end
end

-- Length
function vector:length()
  return math.sqrt(self.x * self.x + self.y * self.y)
end

-- Normalization
function vector:normalize()
	local length = self:length()
	if length > 0 then
		self.x = self.x / length
		self.y = self.y / length
	end
end

-- Dot product
function vector:dot(other)
  	return self.x * other.x + self.y * other.y
end

-- Cross product
function vector:cross(other)
  	return self.x * other.y - self.y * other.x
end

-- Angle between vectors
function vector:angle(other)
  	return math.atan2(self:cross(other), self:dot(other))
end

-- Clone
function vector:clone()
  	return vector.new(self.x, self.y)
end

-- tostring
function vector:__tostring()
  	return "(" .. self.x .. ", " .. self.y .. ")"
end

-- Export the class and factory function
return setmetatable({
	new = vector.new,
}, {
	__call = function(_, x, y)
		return vector.new(x, y)
	end
})
