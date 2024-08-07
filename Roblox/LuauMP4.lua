--[[

==================
LuauMP4 // Version b1.0
by @sharl16
==================

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
local isFinished = false -- We use this to keep the loop running unless it is true.

warn("(b.1.0) This Experience uses LuauMP4 by @sharl16 to display video content. Go to: https://devforum.roblox.com/t/3093961 for more info")

-- Function to pause the video
function LuauMP4.pause_png(sound, imageLabelFolder)
	if sound then
		sound:Stop()
	end
	isFinished = true
end

-- Function to stop the video
function LuauMP4.stop_png(sound, imageLabelFolder, removeOnFinish)
	if sound then
		sound:Stop()
	end
	isFinished = true
	-- We hide all the image labels, otherwise we would have just paused the video. If you want to pause the video you should use LuauMP4.pause_png()
	if removeOnFinish then
		for _, obj in pairs(imageLabelFolder:GetChildren()) do
			if obj:IsA("ImageLabel") then
				obj.Visible = false
			end
		end
	end
end

-- Function to play the video 
function LuauMP4.playback_png(imageLabelFolder, imageSize, imagePosition, FrameRate, loop, removeOnFinish, useTitleBar, sound)
	isFinished = false

	-- Check if the folder exists and if it has images
	if not imageLabelFolder then
		warn("ImageLabelFolder not found.")
		return
	end
	
	-- Not yet implemented fully, this will introduce a timeline (scrubber bar) that will allow us to change the position of the video.
	if useTitleBar then
		warn("useTitleBar is not yet fully implemented! You shouldn't use this yet.")
		local titlebar = player.PlayerGui.LoadingScreenBySH16.Resources.VideoUtils.titlebar:Clone()
		titlebar.Parent = player.PlayerGui.LoadingScreenBySH16.Resources.VideoPNG
		titlebar.Visible = true
	end
	
	-- Check if we have a sound, if we have we will play it, if it is nil then we simply play the video with no sound.
	if sound then
		sound:Play()
		if loop then 
			sound.Looped = true
		end
	end

	-- Function to make all Images visible
	local function makeAllVisible()
		for _, obj in pairs(imageLabelFolder:GetChildren()) do -- We do a loop in the ImageLabelFolder to get all Images; The IsA Check is here because in the future a timeline will be introduced.
			if obj:IsA("ImageLabel") then
				obj.Size = imageSize
				obj.Position = imagePosition
				obj.Visible = true
			end
		end
	end

	-- Function to make all Images invisible
	local function makeAllInvisible()
		for _, obj in pairs(imageLabelFolder:GetChildren()) do
			if obj:IsA("ImageLabel") then
				obj.Visible = false
			end
		end
	end

	-- Retrieve and sort all Images based on their name
	local function getSortedImageLabels()
		local imageLabels = {}
		for _, obj in pairs(imageLabelFolder:GetChildren()) do
			if obj:IsA("ImageLabel") then
				table.insert(imageLabels, obj)
			end
		end
		-- Sort images based on their name
		table.sort(imageLabels, function(a, b)
			return tonumber(a.Name) < tonumber(b.Name)
		end)
		return imageLabels
	end

	-- Retrieve all Images and sort them
	local imageLabels = getSortedImageLabels()
	local currentIndex = 1
	local delayTime = FrameRate -- 1 / 30 is approx. 30 FPS. 1 / 60 is 60 and so on.
	-- Preload images by making them all visible
	makeAllVisible()
	wait(2.5)
	makeAllInvisible()

	-- Function to display the next image (this is the main function that we will loop until the video finishes playing)
	local function displayNextImage()
		if #imageLabels == 0 then
			warn("No ImageLabels found.")
			return
		end
		makeAllInvisible()
		-- Show the current image
		local currentImageLabel = imageLabels[currentIndex]
		currentImageLabel.Visible = true
		-- Move to the next image
		if currentIndex == #imageLabels and not loop then
			LuauMP4.stop_png(sound, imageLabelFolder, removeOnFinish)
			return true
		else
			currentIndex = currentIndex % #imageLabels + 1
			return false
		end	
	end
	-- Main loop, I don't approve this a lot but I can't think of something else..
	while not isFinished do
		displayNextImage()
		wait(delayTime)
	end
end

return LuauMP4