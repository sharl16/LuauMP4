--!strict

--[[
==================
LuauMP4 // Updated Stable Release
by @sharl16
==================
-- v2026.1
-- 1/1/2026

-- Refined playback method. NO flashing,
-- 100% STABLE video stream.

Go to: https://github.com/sharl16/LuauMP4 for more info
]]

warn("(v2026.1) This Experience uses LuauMP4 to display video content. Go to: https://github.com/sharl16/LuauMP4 for more info")

local LuauMP4 = {}

local Players = game:GetService("Players")
local ContentProvider = game:GetService("ContentProvider")
local player = Players.LocalPlayer :: Player
local isFinished = false :: boolean

function LuauMP4.pause_png(sound : Sound, _imageLabelFolder: Folder)
	if sound then
		sound:Stop()
	end
	isFinished = true
end

function LuauMP4.stop_png(sound: Sound, imageLabelFolder: Folder, removeOnFinish: boolean)
	if sound then
		sound:Stop()
	end
	isFinished = true
	if removeOnFinish and imageLabelFolder then
		for _, obj in pairs(imageLabelFolder:GetChildren()) do
			if obj:IsA("ImageLabel") then
				obj.Visible = false
			end
		end
	end
end

local isAllImageLoaded = false

local function preloadImages(imageLabelFolder: Folder)
	local images = {}
	for _, obj in pairs(imageLabelFolder:GetChildren()) do
		if obj:IsA("ImageLabel") then
			table.insert(images, obj)
		end
	end
	local success, err : boolean
	success, err  = pcall(function()
		ContentProvider:PreloadAsync(images)
		isAllImageLoaded = true
	end)
	if not success then
		warn("Error preloading images: "..tostring(err))
	end
end

function LuauMP4.playback_png(imageLabelFolder: Folder, imageSize: UDim2, imagePosition: UDim2, FrameRate: number, loop: boolean, removeOnFinish: boolean, useTitleBar: boolean, sound: Sound)
	isFinished = false
	if not imageLabelFolder then
		warn("ImageLabelFolder not found.")
		return
	end

	if useTitleBar then
		warn("useTitleBar is not yet fully implemented!")
	end

	local function makeAllVisible()
		for _, obj in pairs(imageLabelFolder:GetChildren()) do
			if obj:IsA("ImageLabel") then
				obj.Size = imageSize
				obj.Position = imagePosition
				obj.Visible = true
			end
		end
	end

	local function makeAllInvisible()
		for _, obj in pairs(imageLabelFolder:GetChildren()) do
			if obj:IsA("ImageLabel") then
				obj.Visible = false
			end
		end
	end

	local function getSortedImageLabels() : {ImageLabel}
		local imageLabels = {} :: {ImageLabel}
		for _, obj in pairs(imageLabelFolder:GetChildren()) do
			if obj:IsA("ImageLabel") then
				table.insert(imageLabels, obj)
			end
		end
		table.sort(imageLabels, function(a: ImageLabel, b: ImageLabel)
			local aNum = tonumber(a.Name)
			local bNum = tonumber(b.Name)

			if aNum and bNum then
				return aNum < bNum
			elseif aNum then
				return true
			elseif bNum then
				return false
			else
				return false
			end
		end)
		return imageLabels
	end

	task.spawn(function()
		preloadImages(imageLabelFolder)
	end)
	
	local loadWaitCount = 0
	while isAllImageLoaded == false and loadWaitCount <= 10 do
		task.wait(1)
		loadWaitCount += 1
	end

	local imageLabels = getSortedImageLabels() :: {ImageLabel}
	local currentIndex = 1
	local delayTime = FrameRate -- e.g., 1/30 for 30 FPS

	makeAllVisible()
	task.wait()
	makeAllInvisible()

	local function displayNextImage()
		if #imageLabels == 0 then
			warn("No ImageLabels found.")
			return true
		end

		local currentImageLabel = imageLabels[currentIndex] :: ImageLabel

		while not currentImageLabel.IsLoaded do
			task.wait()
		end

		makeAllInvisible()
		currentImageLabel.Visible = true

		local nextIndex = currentIndex % #imageLabels + 1 :: number
		local nextImageLabel = imageLabels[nextIndex] :: ImageLabel

		while not nextImageLabel.IsLoaded do
			task.wait()
		end

		currentIndex = nextIndex

		if currentIndex == 1 and not loop then
			LuauMP4.stop_png(sound, imageLabelFolder, removeOnFinish)
			return true
		end

		return false
	end

	while not isFinished do
		displayNextImage()
		task.wait(delayTime) 
	end
end

return LuauMP4
