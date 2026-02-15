local Acrylic = {
	AcrylicBlur = require(script.AcrylicBlur),
	CreateAcrylic = require(script.CreateAcrylic),
	AcrylicPaint = require(script.AcrylicPaint),
}

local initialized = false
local baseEffect
local depthOfFieldDefaults = {}

function Acrylic.init()
	if initialized then
		return
	end

	baseEffect = Instance.new("DepthOfFieldEffect")
	baseEffect.FarIntensity = 0
	baseEffect.InFocusRadius = 0.1
	baseEffect.NearIntensity = 1

	local function register(object)
		if object:IsA("DepthOfFieldEffect") then
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

	initialized = true
end

function Acrylic.Enable()
	Acrylic.init()

	for _, effect in next, depthOfFieldDefaults do
		effect.Enabled = false
	end

	if baseEffect then
		baseEffect.Parent = game:GetService("Lighting")
	end
end

function Acrylic.Disable()
	if not initialized then
		return
	end

	for _, effect in next, depthOfFieldDefaults do
		effect.Enabled = effect.enabled
	end

	if baseEffect then
		baseEffect.Parent = nil
	end
end

return Acrylic
