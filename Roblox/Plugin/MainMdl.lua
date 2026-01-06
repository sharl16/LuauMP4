-- restore ConvertToImageLabelAndRename
-- fix deprecated api usage

local MainMdl = {}

local MarketplaceService = game:GetService("MarketplaceService")
local currentConfigScript
local temporaryConfig = {}

local function extractAssetId(assetUrl) 
	local assetId = string.match(assetUrl, "rbxassetid://(%d+)")
	return tonumber(assetId)
end

local function getAssetName(assetId) 
	local success, result = pcall(function()
		local assetInfo = MarketplaceService:GetProductInfo(assetId)
		local nameWithPrefix = assetInfo.Name

		if string.sub(nameWithPrefix, 1, 7) == "Images/" then 
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

function MainMdl.GuidedSetupInit(baseWidget)
	local guide = baseWidget.VideoBuilderUI.Guide
	guide.Guide1.Visible = true
	guide.Visible = true
end

function MainMdl.ConvertToImageLabelAndRename(baseWidget)
	local guide = baseWidget.VideoBuilderUI.Guide
	local folder = guide.Guide2.InputFolder.Text
	local destination = game.StarterGui:FindFirstChild(folder)
	for _, decal in pairs(destination:GetChildren()) do
		if decal:IsA("Decal") then
			local nImage = Instance.new("ImageLabel")
			nImage.Image = decal.Texture
			local assetId = extractAssetId(nImage.Image)
			nImage.Name = getAssetName(assetId)
			nImage.Parent = decal.Parent
			decal:Destroy()
		else
			local assetId = extractAssetId(decal.Image)
			decal.Name = getAssetName(assetId)
		end
	end
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
	local currentVersion = "Plugin Version: 2026.1"
	local pluginAssetId = 18735535757

	local success, result = pcall(function()
		return MarketplaceService:GetProductInfoAsync(pluginAssetId, Enum.InfoType.Asset)
	end)

	if success then
		local latestVersion = string.match(result.Description, "Plugin Version: %S+")
		if latestVersion and latestVersion ~= currentVersion then
			baseWidget.VideoBuilderUI.Guide.Guide1.UpdateAvail.Visible = true
		end
	else
		warn("Failed to get product info for this plugin: " .. tostring(result))
	end
end

return MainMdl