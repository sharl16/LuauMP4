local MainMdl = {}

-- Services
local MarketplaceService = game:GetService("MarketplaceService")

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

-- These two functions are mostly UI-Related.
function MainMdl.GuidedSetupInit(baseWidget)
	local guide = baseWidget.VideoBuilderUI.Guide
	guide.Guide1.Visible = true
	guide.Visible = true
end

function MainMdl.ConvertToImgLabelAndRename(baseWidget)
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
		end
	end
end

return MainMdl