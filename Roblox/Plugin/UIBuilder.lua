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
baseWidget.Title = "LuauMP4 Builder"  -- Optional widget title

-- Create the toolbar and it's icons
local toolbar = plugin:CreateToolbar("LuauMP4")
local toolbarBtn = toolbar:CreateButton(
	"LuauMP4 Builder",              -- Button text
	"A helper plugin to simplify making videos on Roblox.", -- Tooltip text
	"rbxassetid://18735402025"  -- Icon image asset ID
)

-- Clone the UI into the Widget
local ui = script.Parent:FindFirstChild("VideoBuilderUI"):Clone()
ui.Parent = baseWidget

local MainMdl = require(script.Parent.MainMdl)

toolbarBtn.Click:Connect(function()
	baseWidget.Enabled = not baseWidget.Enabled
end)

ui.guided.MouseButton1Down:Connect(function()
	MainMdl.GuidedSetupInit(baseWidget)
end)

ui.Guide.Guide2.Convert.MouseButton1Down:Connect(function()
	MainMdl.ConvertToImageLabelAndRename(baseWidget)
end)

ui.Guide.Guide1.done.MouseButton1Down:Connect(function()
	ui.Guide.Guide2.Visible = true
	ui.Guide.Guide1.Visible = false
end)