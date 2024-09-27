local LuauMP4 = {}

local Players = game:GetService("Players")
local plr = Players.LocalPlayer
local isFinished = false

warn("(b.1.2.1) This Experience uses LuauMP4 by @sharl16 to display video content. Go to: https://github.com/sharl16/LuauMP4 for more info")

local function getImageLabelForPreloading(imageCanvas)
	local preloadLabels = {}
	for i = 1, 30 do
		local label = imageCanvas:FindFirstChild(tostring(i))
		if label then
			label.Visible = false 
			table.insert(preloadLabels, label)
		end
	end
	return preloadLabels
end

local function preloadImageAsync(imageLabel, assetId)
	imageLabel.Visible = true
	local success, err = pcall(function()
		imageLabel.Image = assetId
	end)
	if err then
		return
	end

	-- Wait until the image is loaded before proceeding
	while not imageLabel:IsLoaded() do
		wait(0.05)  -- Small wait to avoid blocking
	end
end

function LuauMP4.playback_video(config, imageCanvas, FrameRate, imageSize, imagePosition, sound, loop, videoTitle, videoDuration, useLoadingScreen)
	if not config or not imageCanvas or not FrameRate or not imageSize or not imagePosition then
		warn("Missing 1 or more required arguments. The video cannot be played.")
		return
	end

	isFinished = false

	local configModule = require(config)
	local AssetMap = configModule.AssetMap

	local assetKeys = {}
	for key in pairs(AssetMap) do
		table.insert(assetKeys, key)
	end

	table.sort(assetKeys, function(a, b)
		return tonumber(a) < tonumber(b)
	end)

	local totalAssets = #assetKeys
	local preloadLabels = getImageLabelForPreloading(imageCanvas)
	local currentImageLabel = imageCanvas.CurrentImageLabel

	local function initialPreload()
		if useLoadingScreen then
			imageCanvas.Loading.Visible = true
		end
		for i = 1, math.min(30, totalAssets) do
			preloadImageAsync(preloadLabels[i], AssetMap[tostring(i)])
		end
		imageCanvas.Loading.Visible = false
		if sound then
			sound:Play()
		end
	end

	local function preloadNextImages(currentIndex)
		for i = 1, 30 do
			local assetIndex = currentIndex + i - 1
			if assetIndex <= totalAssets then
				preloadImageAsync(preloadLabels[i], AssetMap[tostring(assetIndex)])
			else
				preloadLabels[i].Visible = false -- Hide label if no more assets to preload
			end
		end
	end

	currentImageLabel.Size = imageSize
	currentImageLabel.Position = imagePosition

	local currentIndex = 1
	initialPreload()

	while not isFinished do
		-- Show the current image in the CurrentImageLabel
		currentImageLabel.Image = AssetMap[assetKeys[currentIndex]]

		-- Preload the next batch of images for the preload labels
		preloadNextImages(currentIndex + 1)

		currentIndex = currentIndex + 1

		if currentIndex > totalAssets then
			if not loop then
				isFinished = true
				if sound then
					sound:Stop()
				end
				return
			end
			currentIndex = 1
		end

		wait(FrameRate)
	end
end

return LuauMP4
