local Acrylic = {
	AcrylicBlur = require(script.AcrylicBlur),
	CreateAcrylic = require(script.CreateAcrylic),
	AcrylicPaint = require(script.AcrylicPaint),
}

local baseEffect
local depthOfFieldDefaults = {}
local enabled = false

local function createBaseEffect()
	local effect = Instance.new("DepthOfFieldEffect")
	effect.FarIntensity = 0
	effect.InFocusRadius = 0.1
	effect.NearIntensity = 1

	return effect
end

function Acrylic.init()
	if baseEffect then
		return
	end

	baseEffect = createBaseEffect()
end

function Acrylic.Enable()
	Acrylic.init()

	if enabled then
		local success = pcall(function()
			baseEffect.Enabled = true
			baseEffect.Parent = game:GetService("Lighting")
		end)

		if success then
			return
		end

		baseEffect = createBaseEffect()
		baseEffect.Parent = game:GetService("Lighting")
		return
	end

	table.clear(depthOfFieldDefaults)

	local function register(object)
		if object:IsA("DepthOfFieldEffect") and object ~= baseEffect then
			depthOfFieldDefaults[object] = { enabled = object.Enabled }
		end
	end

	for _, child in next, game:GetService("Lighting"):GetChildren() do
		register(child)
	end

	if game:GetService("Workspace").CurrentCamera then
		for _, child in next, game:GetService("Workspace").CurrentCamera:GetChildren() do
			register(child)
		end
	end

	for effect in next, depthOfFieldDefaults do
		pcall(function()
			effect.Enabled = false
		end)
	end

	local success = pcall(function()
		baseEffect.Enabled = true
		baseEffect.Parent = game:GetService("Lighting")
	end)

	if not success then
		baseEffect = createBaseEffect()
		baseEffect.Parent = game:GetService("Lighting")
	end

	enabled = true
end

function Acrylic.Disable()
	if not baseEffect and not enabled then
		return
	end

	enabled = false

	for effect, defaults in next, depthOfFieldDefaults do
		pcall(function()
			effect.Enabled = defaults.enabled
		end)
	end
	table.clear(depthOfFieldDefaults)

	if baseEffect then
		pcall(function()
			baseEffect:Destroy()
		end)
		baseEffect = nil
	end
end

return Acrylic
