-- MiniToggle.lua
local MiniToggle = {}
MiniToggle.__index = MiniToggle

--[[ 
    MiniToggle:Create(Library, iconId)
    - Library: object library yang ingin di-toggle (Linoria / Obsidian)
    - iconId: optional, rbassetid string untuk icon tombol
]]
function MiniToggle:Create(Library, iconId)
    iconId = iconId or "rbxassetid://95816097006870" -- default icon

    repeat task.wait() until game:IsLoaded()
    local Players = game:GetService("Players")
    local PlayerGui = Players.LocalPlayer:WaitForChild("PlayerGui")
    local TweenService = game:GetService("TweenService")

    -- Create ScreenGui
    local ToggleGui = Instance.new("ScreenGui")
    ToggleGui.Name = "MiniToggleGUI"
    ToggleGui.ResetOnSpawn = false
    ToggleGui.Parent = PlayerGui

    -- Create ImageButton
    local IconButton = Instance.new("ImageButton")
    IconButton.Size = UDim2.new(0, 55, 0, 55)
    IconButton.Position = UDim2.new(0.92, 0, 0.12, 0)
    IconButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    IconButton.BackgroundTransparency = 0.4
    IconButton.Image = iconId
    IconButton.BorderSizePixel = 0
    IconButton.Active = true
    IconButton.Draggable = true
    IconButton.Parent = ToggleGui

    -- Rounded corners
    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(1, 0)
    UICorner.Parent = IconButton

    -- Hover effect
    IconButton.MouseEnter:Connect(function()
        TweenService:Create(
            IconButton,
            TweenInfo.new(0.15),
            {BackgroundTransparency = 0.2}
        ):Play()
    end)
    IconButton.MouseLeave:Connect(function()
        TweenService:Create(
            IconButton,
            TweenInfo.new(0.15),
            {BackgroundTransparency = 0.4}
        ):Play()
    end)

    -- Toggle menu functionality
    local menuVisible = true
    IconButton.MouseButton1Click:Connect(function()
        menuVisible = not menuVisible
        if Library and Library.Toggle then
            Library:Toggle() -- toggle menu
        end
    end)

    -- Return references in case needed
    return {
        Gui = ToggleGui,
        Button = IconButton
    }
end

return MiniToggle
