local SecureAssets = require(script.Parent.Parent.Modules.SecureAssets)

local Assets = {
	Close = "rbxassetid://9886659671",
	Min = "rbxassetid://9886659276",
	Max = "rbxassetid://9886659406",
	Restore = "rbxassetid://9886659001",
}

return setmetatable({}, {
	__index = function(_, Index)
		local Asset = Assets[Index]

		if typeof(Asset) == "string" then
			return SecureAssets:Get(Asset)
		end

		return Asset
	end,
})
