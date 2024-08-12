
class = {}

function class:New(instance, ...)
    instance = instance or {}
    setmetatable(instance, self)

    if self.__init then
        self.__init(instance, ...)
    end

    return instance
end

function class:Extend(instance)
    instance = instance or {}
    setmetatable(instance, self)
    self.__index = self

    return instance
end

setmetatable(class, {
    __call = function(_, instance, ...) return class:new(instance, ...) end
})



--[[
    Usage:
    
	Animal = class()
	function Animal:WhatAmI()
		print(self.Type or "None")
	end

	lion = class:extend(Animal)
	lion.Type = "Lion"
	print(lion:WhatAmI())
]]