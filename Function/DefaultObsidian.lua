-- JarvisLibrary.lua
local Library = {}
Library.__index = Library

-- [[ Services ]]
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local hrp = char:WaitForChild("HumanoidRootPart")
local humanoid = char:WaitForChild("Humanoid")

-- [[ Internal Vars ]]
local Toggles = {}
local Options = {}
local flying = false
local flyVel
local window

-- [[ Default Theme ]]
local DEFAULT_THEME = {
    Accent = Color3.fromRGB(170, 0, 255), -- Ungu
    Background = Color3.fromRGB(20, 20, 20),
    TextColor = Color3.fromRGB(255, 255, 255)
}

-- [[ Fly Logic ]]
local function startFly()
	if flying then return end
	flying = true
	flyVel = Instance.new("BodyVelocity")
	flyVel.MaxForce = Vector3.new(400000,400000,400000)
	flyVel.Velocity = Vector3.new(0,0,0)
	flyVel.Parent = hrp

	RunService:BindToRenderStep("Fly", 201, function()
		if not flying then return end
		local dir = Vector3.new()
		if UserInputService:IsKeyDown(Enum.KeyCode.W) then dir += hrp.CFrame.LookVector end
		if UserInputService:IsKeyDown(Enum.KeyCode.S) then dir -= hrp.CFrame.LookVector end
		if UserInputService:IsKeyDown(Enum.KeyCode.A) then dir -= hrp.CFrame.RightVector end
		if UserInputService:IsKeyDown(Enum.KeyCode.D) then dir += hrp.CFrame.RightVector end
		if UserInputService:IsKeyDown(Enum.KeyCode.Space) then dir += Vector3.new(0,1,0) end
		if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then dir -= Vector3.new(0,1,0) end
		local speed = Options.FlySlider or 50
		if dir.Magnitude > 0 then
			flyVel.Velocity = dir.Unit * speed
		else
			flyVel.Velocity = Vector3.new(0,0,0)
		end
	end)
end

local function stopFly()
	flying = false
	if flyVel then flyVel:Destroy() flyVel = nil end
	RunService:UnbindFromRenderStep("Fly")
end

-- [[ Create Window ]]
function Library:CreateWindow(title, footer)
    -- Build window using Linoria / Obsidian internally
    window = LibraryAPI:CreateWindow({
        Title = title or "JARVIS HUB",
        Footer = footer or "v1.1",
        Theme = DEFAULT_THEME
    })
    return window
end

-- [[ Player Tab ]]
function Library:CreatePlayerTab(parentTab)
    local PlayerGroup = parentTab:AddRightGroupbox("Utility")

    -- Speed
    Toggles.SpeedToggle = PlayerGroup:AddToggle("SpeedToggle", {Text = "Enable Speed", Default = false, Callback = function(v)
        humanoid.WalkSpeed = v and Options.SpeedSlider or 16
    end})
    Options.SpeedSlider = PlayerGroup:AddSlider("SpeedSlider", {Text = "Speed Value", Default = 16, Min = 16, Max = 200, Callback = function(v)
        if Toggles.SpeedToggle.Value then humanoid.WalkSpeed = v end
    end})

    -- Jump
    Toggles.JumpToggle = PlayerGroup:AddToggle("JumpToggle", {Text = "Enable Jump", Default = false, Callback = function(v)
        humanoid.JumpPower = v and Options.JumpSlider or 50
    end})
    Options.JumpSlider = PlayerGroup:AddSlider("JumpSlider", {Text = "Jump Power", Default = 50, Min = 50, Max = 500, Callback = function(v)
        if Toggles.JumpToggle.Value then humanoid.JumpPower = v end
    end})

    -- Fly
    Toggles.FlyToggle = PlayerGroup:AddToggle("FlyToggle", {Text = "Enable Fly", Default = false, Callback = function(v)
        if v then startFly() else stopFly() end
    end})
    Options.FlySlider = PlayerGroup:AddSlider("FlySlider", {Text = "Fly Speed", Default = 50, Min = 50, Max = 500})

    -- Infinite Jump
    PlayerGroup:AddToggle("InfiniteJump", {Text = "Infinite Jump", Default = false, Callback = function(v)
        getgenv().InfiniteJumpEnabled = v
        UserInputService.JumpRequest:Connect(function()
            if getgenv().InfiniteJumpEnabled then humanoid:ChangeState("Jumping") end
        end)
    end})

    -- Anti AFK
    PlayerGroup:AddToggle("AntiAFK", {Text = "Anti AFK", Default = false, Callback = function(v)
        getgenv().AntiAFKEnabled = v
        if v then
            local vu = game:GetService("VirtualUser")
            player.Idled:Connect(function()
                if getgenv().AntiAFKEnabled then
                    vu:Button2Down(Vector2.new(), workspace.CurrentCamera.CFrame)
                    task.wait(1)
                    vu:Button2Up(Vector2.new(), workspace.CurrentCamera.CFrame)
                end
            end)
        end
    end})

    -- NoClip
    PlayerGroup:AddToggle("NoClip", {Text = "No Clip", Default = false, Callback = function(v)
        getgenv().NoClipEnabled = v
        task.spawn(function()
            while getgenv().NoClipEnabled do
                for _, part in pairs(char:GetDescendants()) do
                    if part:IsA("BasePart") then part.CanCollide = false end
                end
                task.wait()
            end
        end)
    end})
end

-- [[ Settings Tab ]]
function Library:CreateSettingsTab(parentTab)
    local MenuGroup = parentTab:AddLeftGroupbox("Menu", "wrench")

    MenuGroup:AddToggle("ShowCustomCursor", {Text = "Custom Cursor", Default = true, Callback = function(v) Library.ShowCustomCursor = v end})
    MenuGroup:AddDropdown("NotificationSide", {Values = {"Left","Right"}, Default = "Right", Text = "Notification Side", Callback = function(v) Library:SetNotifySide(v) end})
    MenuGroup:AddDropdown("DPIDropdown", {Values = {"50%","75%","100%","125%","150%","175%","200%"}, Default = "100%", Text = "DPI Scale", Callback = function(v) Library:SetDPIScale(tonumber(v:gsub("%%",""))) end})
    MenuGroup:AddLabel("Menu bind"):AddKeyPicker("MenuKeybind", {Default = "RightShift", NoUI = true, Text = "Menu keybind"})
    MenuGroup:AddButton("DESTROY UI", function() Library:Unload() end)
end

-- [[ Return ]]
return Library
