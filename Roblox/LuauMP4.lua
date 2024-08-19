--[[

==================
LuauMP4 // Version b1.1
by @sharl16
==================

!!!COMPLETE REWRITE!!! 

The previous versions had some weird code due to
using GPT for some stuff (Like removing the video
at the end and ect. ) This caused more problems
when trying to debug and I had to rewrite it all 
completely without GPT (Obviously, the approach is the same,
so it is similar, it just doesn't have weird artifacts from GPT.)

This is the main module for playing back videos from ImageLabels. 
It is not recommended to touch anything in here unless you know 
what you are doing, you can modify whatever you want without
modifying this code directly. Updates will come.

**IF YOU HAVE A BETTER NAME, PLEASE TELL ME**

]]

local LuauMP4 = {}

local Players = game:GetService("Players")
local plr = Players.LocalPlayer
local isFinished = false

warn("(b.1.1) This Experience uses LuauMP4 by @sharl16 to display video content. Go to: https://github.com/sharl16/LuauMP4 for more info")

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
			end
		end
	end

	currentImageLabel.Size = imageSize
	currentImageLabel.Position = imagePosition
	
	local currentIndex = 1

	for i = 1,5 do
		initialPreload()
		wait()
	end

	while not isFinished do
		currentImageLabel.Image = AssetMap[assetKeys[currentIndex]]
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
		preloadNextImages(currentIndex)
		wait(FrameRate)
	end
end

return LuauMP4