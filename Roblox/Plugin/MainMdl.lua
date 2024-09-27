local MainMdl = {}

-- Services
local MarketplaceService = game:GetService("MarketplaceService")
local currentConfigScript
local temporaryConfig = {}

-- Local functions
local function extractAssetId(assetUrl) -- This function extracts the numbers from rbxassetid:// because MarketplaceService works with only the number ID's
	local assetId = string.match(assetUrl, "rbxassetid://(%d+)")
	print(tostring(assetId))
	return tonumber(assetId)
end

local function getAssetName(assetId) 
	local success, result = pcall(function()
		local assetInfo = MarketplaceService:GetProductInfo(assetId)
		local nameWithPrefix = assetInfo.Name
		print(nameWithPrefix)

		if string.sub(nameWithPrefix, 1, 7) == "Images/" then -- Usually roblox uploads images with a "Images/" tag before their name.
			print(string.sub(nameWithPrefix, 8))
			return string.sub(nameWithPrefix, 8)
		else
			return nameWithPrefix
		end
	end)

	if success then
		return result
	else
		warn("Failed to fetch asset details for ID: " .. assetId)
		return "Unknown Asset"
	end
end

local function generateConfigScript()
	currentConfigScript = Instance.new("ModuleScript")
	currentConfigScript.Name = "LMP4Config"
	local deploymentFolder = Instance.new("Folder")
	deploymentFolder.Name = "Inserted Assets"
	deploymentFolder.Parent = game.Workspace
	currentConfigScript.Parent = deploymentFolder
end

-- These two functions are mostly UI-Related.
function MainMdl.GuidedSetupInit(baseWidget)
	local guide = baseWidget.VideoBuilderUI.Guide
	guide.Guide1.Visible = true
	guide.Visible = true
end

-- The Main function, this does most of the work.
function MainMdl.ConvertToImageLabelAndRename(baseWidget)
	generateConfigScript()
	local guide = baseWidget.VideoBuilderUI.Guide
	local folder = guide.Guide2.InputFolder.Text
	local destination = game.StarterGui:FindFirstChild(folder)

	if not destination then
		warn("Destination folder not found!")
		return
	end

	local assetMap = {}

	for _, decal in pairs(destination:GetChildren()) do
		if decal:IsA("Decal") then
			local nImage = Instance.new("ImageLabel")
			nImage.Image = decal.Texture
			local assetId = extractAssetId(nImage.Image)
			local assetName = getAssetName(assetId)
			nImage.Name = assetName
			nImage.Parent = decal.Parent
			assetMap[assetName] = nImage.Image  -- Add the name and image to assetMap 
			decal:Destroy()
		end
	end

	local assetMapString = "{\n"
	for name, url in pairs(assetMap) do
		assetMapString = assetMapString .. string.format('["%s"] = "%s",\n', name, url)
	end
	assetMapString = assetMapString .. "}"

	-- Generate the source of currentConfigScript
	local luaScript = string.format([[
        local LMP4Config = {}
        LMP4Config.AssetMap = %s
        return LMP4Config
    ]], assetMapString)

	currentConfigScript.Source = luaScript
end

function MainMdl.GetVideoModule()
	local vidModule = script.Resources.LuauMP4:Clone()
	local deploymentFolder = Instance.new("Folder")
	deploymentFolder.Name = "Inserted Assets"
	vidModule.Parent = deploymentFolder
	local imageCanvas = script.Resources.ImageCanvas:Clone()
	imageCanvas.Parent = deploymentFolder
	deploymentFolder.Parent = game.Workspace
end

function MainMdl.GetStableVideoModule()
	local vidModule = script.Stable.LuauMP4:Clone()
	local deploymentFolder = Instance.new("Folder")
	deploymentFolder.Name = "Inserted Assets"
	vidModule.Parent = deploymentFolder
	deploymentFolder.Parent = game.Workspace
end

function MainMdl.CheckForUpdates(baseWidget)
	local currentVersion = "Plugin Version: b1.2.1"
	local pluginAssetId = 18735535757
	local success, result = pcall(function()
		return MarketplaceService:GetProductInfo(pluginAssetId, Enum.InfoType.Asset)
	end)
	if success then
		local latestVersion = string.match(result.Description, "Plugin Version: %S+")
		if latestVersion and latestVersion ~= currentVersion then
			baseWidget.VideoBuilderUI.Guide.Guide1.UpdateAvail.Visible = true
		end
	else
		warn("Failed to get product info for this plugin: "..tostring(result))
	end
end

return MainMdl