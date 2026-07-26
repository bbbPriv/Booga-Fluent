local Request = request or http_request or (http and http.request)
local CustomAsset = getcustomasset or getsynasset

local SecureAssets = {
	Enabled = false,
	Folder = "FluentRenewed",
	CacheVersion = "5",
	Prepared = false,
	Empty = "",
	ResolvedAssets = {},
	Urls = {
		["rbxassetid://9886659671"] = "https://raw.githubusercontent.com/bbbPriv/BoogaFluentAssets/refs/heads/main/9886659671.png",
		["rbxassetid://9886659276"] = "https://raw.githubusercontent.com/bbbPriv/BoogaFluentAssets/refs/heads/main/Min.png",
		["rbxassetid://9886659406"] = "https://raw.githubusercontent.com/bbbPriv/BoogaFluentAssets/refs/heads/main/Max.png",
		["rbxassetid://9886659001"] = "https://raw.githubusercontent.com/bbbPriv/BoogaFluentAssets/refs/heads/main/Restore.png",
		["rbxassetid://6889812791"] = "https://raw.githubusercontent.com/bbbPriv/BoogaFluentAssets/refs/heads/main/04601228afe78bccfbc4cc33d85472e5%20(3).png",
		["rbxassetid://6889812721"] = "https://raw.githubusercontent.com/bbbPriv/BoogaFluentAssets/refs/heads/main/a49291ebefaaa3f7ad1ff7c640eb0dc8%20(3).png",
		["rbxassetid://6276641225"] = "https://raw.githubusercontent.com/bbbPriv/BoogaFluentAssets/refs/heads/main/bc30aee32ad1c32ec2eedfdd6ef421d1%20(3).png",
		["rbxassetid://4155801252"] = "https://raw.githubusercontent.com/bbbPriv/BoogaFluentAssets/refs/heads/main/eed826039b14e1333990ac9f2493c834.png",
		["rbxassetid://10709790948"] = "https://raw.githubusercontent.com/bbbPriv/BoogaFluentAssets/refs/heads/main/571c98eea53ce2252dc64fc7bad58589%20(2).png",
		["rbxassetid://8992230677"] = "https://raw.githubusercontent.com/bbbPriv/BoogaFluentAssets/refs/heads/main/2e621f643e1c22e0f31f56e4412df890%20(4).png",
		["rbxassetid://9968344105"] = "https://raw.githubusercontent.com/bbbPriv/BoogaFluentAssets/refs/heads/main/3ee01e99fc4fa65ab09168c6fddc1733%20(4).png",
		["rbxassetid://9968344227"] = "https://raw.githubusercontent.com/bbbPriv/BoogaFluentAssets/refs/heads/main/983e68118724da2954693420d55e6be0%20(4).png",
		["rbxassetid://113826256227095"] = "https://raw.githubusercontent.com/bbbPriv/BoogaFluentAssets/refs/heads/main/389c25d52dadfe41ae03e3065c19c809.png",
		["rbxassetid://83798598825627"] = "https://raw.githubusercontent.com/bbbPriv/BoogaFluentAssets/refs/heads/main/97529e9bde52ab3885aef1ab62de35ac.png",
		["rbxassetid://93555120675964"] = "https://raw.githubusercontent.com/bbbPriv/BoogaFluentAssets/refs/heads/main/e7852af2a383bc0afc7ea62f3c22a1ca.png",
		["rbxassetid://118976126805967"] = "https://raw.githubusercontent.com/bbbPriv/BoogaFluentAssets/refs/heads/main/31b23d2687ca8073f58073ad0d8e765e.png",
		["rbxassetid://129900432084566"] = "https://raw.githubusercontent.com/bbbPriv/BoogaFluentAssets/refs/heads/main/ad14e907f6671eb9fdcbf0559461dc8a.png",
		["rbxassetid://115396960406352"] = "https://raw.githubusercontent.com/bbbPriv/BoogaFluentAssets/refs/heads/main/f802794f1df3f64d2bdb5e8ba00b5267.png",
		["http://www.roblox.com/asset/?id=14204231522"] = "https://raw.githubusercontent.com/bbbPriv/BoogaFluentAssets/refs/heads/main/4ef50c22a59572b4560a217e5df57c68%20(2).png",
		["http://www.roblox.com/asset/?id=4805639000"] = "https://raw.githubusercontent.com/bbbPriv/BoogaFluentAssets/refs/heads/main/bb607a53a222e8a130304b8e1a2d66b5.png",
		["http://www.roblox.com/asset/?id=12266946128"] = "https://raw.githubusercontent.com/bbbPriv/BoogaFluentAssets/refs/heads/main/8cfe991d294c52e3c083d66fd2732e71.png",
		["http://www.roblox.com/asset/?id=5554236805"] = "https://raw.githubusercontent.com/bbbPriv/BoogaFluentAssets/refs/heads/main/c5737c0a8b8fe253a90baf2ba9c85e27.png",
	},
}

local function GetRequestBody(Url)
	local Success, Response = pcall(game.HttpGet, game, Url)

	if Success then
		return Response
	end

	if Request then
		Success, Response = pcall(Request, {
			Url = Url,
			Method = "GET",
		})

		if Success and Response then
			local StatusCode = Response.StatusCode or Response.Status or 0

			if (Response.Success ~= false and StatusCode == 0) or (StatusCode >= 200 and StatusCode < 300) then
				return Response.Body
			end
		end
	end
end

local function EnsureFolder(Path)
	if not isfolder or not makefolder then
		return false
	end

	local Parts = Path:gsub("\\", "/"):split("/")
	local Current = ""

	for Index = 1, #Parts do
		local Part = Parts[Index]

		if Part ~= "" then
			Current = Current == "" and Part or `{Current}/{Part}`

			if not isfolder(Current) then
				makefolder(Current)
			end
		end
	end

	return true
end

local function GetAssetId(Asset)
	return Asset:match("^rbxassetid://(.+)$") or Asset:match("^http://www%.roblox%.com/asset/%?id=(.+)$")
end

function SecureAssets:SetEnabled(Value)
	self.Enabled = Value == true
	self.Prepared = false
	table.clear(self.ResolvedAssets)
end

function SecureAssets:SetFolder(Value)
	if typeof(Value) == "string" and Value ~= "" then
		self.Folder = Value
		self.Prepared = false
		table.clear(self.ResolvedAssets)
	end
end

function SecureAssets:ShouldDownload()
	if not self.Enabled or not isfile or not writefile or not CustomAsset then
		return false
	end

	local IconFolder = `{self.Folder}/Icons`

	if not isfolder or not isfolder(IconFolder) then
		return true
	end

	local VersionPath = `{IconFolder}/.version`

	if not readfile or not isfile(VersionPath) then
		return true
	end

	local Success, Version = pcall(readfile, VersionPath)

	if not Success or Version ~= self.CacheVersion then
		return true
	end

	for Asset in next, self.Urls do
		local AssetId = GetAssetId(Asset)

		if AssetId and not isfile(`{IconFolder}/{AssetId}.png`) then
			return true
		end
	end

	return false
end

function SecureAssets:Prepare()
	if not self.Enabled or self.Prepared then
		return
	end

	self.Prepared = true
	table.clear(self.ResolvedAssets)

	if not isfile or not writefile or not CustomAsset then
		return
	end

	local IconFolder = `{self.Folder}/Icons`

	if not EnsureFolder(IconFolder) then
		return
	end

	local VersionPath = `{IconFolder}/.version`
	local RefreshAll = true

	if readfile and isfile(VersionPath) then
		local Success, Version = pcall(readfile, VersionPath)

		if Success and Version == self.CacheVersion then
			RefreshAll = false
		end
	end

	local Pending = 0

	for Asset, Url in next, self.Urls do
		Pending += 1

		task.spawn(function()
			pcall(function()
				local AssetId = GetAssetId(Asset)

				if not AssetId then
					return
				end

				local FilePath = `{IconFolder}/{AssetId}.png`

				if RefreshAll or not isfile(FilePath) then
					local Body = GetRequestBody(Url)

					if Body then
						pcall(writefile, FilePath, Body)
					end
				end

				if isfile(FilePath) then
					local Success, ResolvedAsset = pcall(CustomAsset, FilePath)

					if Success and ResolvedAsset then
						self.ResolvedAssets[Asset] = ResolvedAsset
					end
				end
			end)

			Pending -= 1
		end)
	end

	while Pending > 0 do
		task.wait()
	end

	if RefreshAll then
		pcall(writefile, VersionPath, self.CacheVersion)
	end
end

function SecureAssets:Get(Asset)
	if not self.Enabled or typeof(Asset) ~= "string" then
		return Asset
	end

	if not self.Urls[Asset] then
		return Asset
	end

	return self.ResolvedAssets[Asset] or self.Empty
end

return SecureAssets
