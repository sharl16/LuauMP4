local widgetInfo = DockWidgetPluginGuiInfo.new(
	Enum.InitialDockState.Float,  -- Widget will be initialized in floating panel
	false,   -- Widget will be initially enabled
	false,  -- Don't override the previous enabled state
	821,    -- Default width of the floating window
	439,    -- Default height of the floating window
	821,    -- Minimum width of the floating window
	439     -- Minimum height of the floating window
)

-- Create the widget
local baseWidget = plugin:CreateDockWidgetPluginGui("LuauMP4", widgetInfo) 
baseWidget.Title = "LuauMP4 Builder"  

local toolbar = plugin:CreateToolbar("LuauMP4")
local toolbarBtn = toolbar:CreateButton(
	"LuauMP4 Builder",              
	"A helper plugin to simplify making videos on Roblox.", 
	"rbxassetid://18735402025"  
)

local ui = script.Parent:FindFirstChild("VideoBuilderUI"):Clone()
ui.Parent = baseWidget

local MainMdl = require(script.Parent.MainMdl)
local Theme = require(script.Parent.Theme)

MainMdl.CheckForUpdates(baseWidget)

toolbarBtn.Click:Connect(function()
	ui.Guide.Guide2.Visible = false
	ui.Guide.Guide1.Visible = true
	baseWidget.Enabled = not baseWidget.Enabled
	MainMdl.CheckForUpdates(baseWidget)
end)

settings().Studio.ThemeChanged:Connect(function()
	Theme.ApplyTheme(ui)
end)

ui.Guide.Guide2.Convert.MouseButton1Down:Connect(function()
	MainMdl.ConvertToImageLabelAndRename(baseWidget)
end)

ui.Guide.Guide1.done.MouseButton1Down:Connect(function()
	ui.Guide.Guide2.Visible = true
	ui.Guide.Guide1.Visible = false
end)

ui.Guide.Guide1.getModule.MouseButton1Down:Connect(function()
	ui.Choose.Visible = true
end)

ui.Choose.Frame.getLatestModule.MouseButton1Down:Connect(function()
	MainMdl.GetVideoModule()
	task.wait(1.5)
	local module = game.Workspace:FindFirstChild("Inserted Assets")
	if module then
		ui.Choose.Frame.Visible = false
		ui.Choose.Success.Visible = true
	end
end)

ui.Choose.Frame.getStableModule.MouseButton1Down:Connect(function()
	MainMdl.GetStableVideoModule()
	local module = game.Workspace:FindFirstChild("Inserted Assets")
	task.wait(1.5)
	if module then
		ui.Choose.Frame.Visible = false
		ui.Choose.Success.Visible = true
	end
end)

ui.Choose.done.MouseButton1Down:Connect(function()
	ui.Choose.Visible = false
end)

ui.Choose.Success.Close.MouseButton1Down:Connect(function()
	ui.Choose.Frame.Visible = true
	ui.Choose.Success.Visible = false
	ui.Choose.Visible = false
end)

Theme.ApplyTheme(ui)