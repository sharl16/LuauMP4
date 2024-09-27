--[[

==================
LuauMP4 // Stable Release
by @sharl16
==================

!!Use the 1st video as a tutorial, as the newer ones don't use stable.!!

This is the main module for playing back videos from ImageLabels. 
It is not recommended to touch anything in here unless you know 
what you are doing, you can modify whatever you want without
modifying this code directly. Updates will come.

**IF YOU HAVE A BETTER NAME, PLEASE TELL ME**

]]

local LuauMP4 = {} 

-- Services
local Players = game:GetService("Players")
local player = Players.LocalPlayer
local isFinished = false 

warn("(Stable 1.0) This Experience uses LuauMP4 by @sharl16 to display video content. Go to: https://devforum.roblox.com/t/3093961 for more info")

function LuauMP4.pause_png(sound, imageLabelFolder)
	if sound then
		sound:Stop()
	end
	isFinished = true
end

function LuauMP4.stop_png(sound, imageLabelFolder, removeOnFinish)
	if sound then
		sound:Stop()
	end
	isFinished = true
	if removeOnFinish then
		for _, obj in pairs(imageLabelFolder:GetChildren()) do
			if obj:IsA("ImageLabel") then
				obj.Visible = false
			end
		end
	end
end
 
function LuauMP4.playback_png(imageLabelFolder, imageSize, imagePosition, FrameRate, loop, removeOnFinish, useTitleBar, sound)
	isFinished = false
	if not imageLabelFolder then
		warn("ImageLabelFolder not found.")
		return
	end

	if useTitleBar then
		warn("useTitleBar is not yet fully implemented! You shouldn't use this yet.")
		local titlebar = player.PlayerGui.LoadingScreenBySH16.Resources.VideoUtils.titlebar:Clone()
		titlebar.Parent = player.PlayerGui.LoadingScreenBySH16.Resources.VideoPNG
		titlebar.Visible = true
	end

	if sound then
		sound:Play()
		if loop then 
			sound.Looped = true
		end
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

	local function getSortedImageLabels()
		local imageLabels = {}
		for _, obj in pairs(imageLabelFolder:GetChildren()) do
			if obj:IsA("ImageLabel") then
				table.insert(imageLabels, obj)
			end
		end
		table.sort(imageLabels, function(a, b)
			return tonumber(a.Name) < tonumber(b.Name)
		end)
		return imageLabels
	end

	local imageLabels = getSortedImageLabels()
	local currentIndex = 1
	local delayTime = FrameRate -- 1 / 30 is approx. 30 FPS. 1 / 60 is 60 and so on.
	makeAllVisible()
	wait(2.5)
	makeAllInvisible()

	local function displayNextImage()
		if #imageLabels == 0 then
			warn("No ImageLabels found.")
			return
		end
		makeAllInvisible()
		local currentImageLabel = imageLabels[currentIndex]
		currentImageLabel.Visible = true
		if currentIndex == #imageLabels and not loop then
			LuauMP4.stop_png(sound, imageLabelFolder, removeOnFinish)
			return true
		else
			currentIndex = currentIndex % #imageLabels + 1
			return false
		end	
	end

	while not isFinished do
		displayNextImage()
		wait(delayTime)
	end
end

return LuauMP4