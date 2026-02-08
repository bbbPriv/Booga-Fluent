return {
	Accent = Color3.fromRGB(120, 190, 225),

	AcrylicMain = Color3.fromRGB(14, 16, 30),
	AcrylicBorder = Color3.fromRGB(36, 44, 72),

	AcrylicGradient = ColorSequence.new({
		ColorSequenceKeypoint.new(0.00, Color3.fromRGB(14, 16, 30)),
		ColorSequenceKeypoint.new(0.52, Color3.fromRGB(64, 44, 108)),
		ColorSequenceKeypoint.new(1.00, Color3.fromRGB(120, 190, 225)),
	}),
	AcrylicNoise = 0.96,

	TitleBarLine = Color3.fromRGB(50, 62, 96),
	Tab = Color3.fromRGB(220, 235, 245),

	Element = Color3.fromRGB(36, 56, 76),
	ElementBorder = Color3.fromRGB(10, 14, 24),
	InElementBorder = Color3.fromRGB(160, 210, 240),
	ElementTransparency = 0.78,

	ToggleSlider = Color3.fromRGB(165, 210, 235),
	ToggleToggled = Color3.fromRGB(12, 14, 22),
	SliderRail = Color3.fromRGB(165, 210, 235),

	DropdownFrame = Color3.fromRGB(180, 205, 220),
	DropdownHolder = Color3.fromRGB(22, 34, 50),
	DropdownBorder = Color3.fromRGB(14, 24, 36),
	DropdownOption = Color3.fromRGB(210, 230, 240),

	Keybind = Color3.fromRGB(150, 190, 205),
	Input = Color3.fromRGB(150, 190, 205),
	InputFocused = Color3.fromRGB(12, 14, 22),
	InputIndicator = Color3.fromRGB(200, 230, 245),

	Dialog = Color3.fromRGB(20, 30, 44),
	DialogHolder = Color3.fromRGB(16, 24, 40),
	DialogHolderLine = Color3.fromRGB(12, 18, 30),
	DialogButton = Color3.fromRGB(20, 30, 44),
	DialogButtonBorder = Color3.fromRGB(96, 140, 170),
	DialogBorder = Color3.fromRGB(44, 64, 96),
	DialogInput = Color3.fromRGB(56, 86, 110),
	DialogInputLine = Color3.fromRGB(200, 230, 245),

	Text = Color3.fromRGB(246, 250, 252),
	SubText = Color3.fromRGB(180, 200, 210),

	Hover = Color3.fromRGB(140, 200, 225),
	HoverChange = 0.055
}