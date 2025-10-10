--[[
    Universal UI Library - Example Script
    Contoh penggunaan semua fitur yang tersedia
]]

-- Load Library
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/your-repo/UniversalUI.lua"))()

-- Create Window
local Window = Library:CreateWindow({
    Name = "Universal Hub",
    ThemePrimary = Color3.fromRGB(45, 45, 45),
    ThemeSecondary = Color3.fromRGB(35, 35, 35),
    ThemeAccent = Color3.fromRGB(0, 170, 255),
    ConfigFolder = "UniversalConfigs"
})

-- Tab 1: Main Features
local MainTab = Window:CreateTab("Main")

MainTab:AddLabel("⭐ Welcome to Universal UI Library!")

MainTab:AddButton({
    Name = "Click Me!",
    Callback = function()
        print("Button clicked!")
    end
})

local toggle1 = MainTab:AddToggle({
    Name = "Enable Feature",
    Default = false,
    Flag = "MainToggle",
    Callback = function(value)
        print("Toggle:", value)
    end
})

local slider1 = MainTab:AddSlider({
    Name = "Walk Speed",
    Min = 16,
    Max = 200,
    Default = 16,
    Increment = 1,
    Flag = "WalkSpeed",
    Callback = function(value)
        print("Slider value:", value)
        -- game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = value
    end
})

local dropdown1 = MainTab:AddDropdown({
    Name = "Select Weapon",
    Options = {"Sword", "Gun", "Bow", "Staff", "Axe"},
    Default = "Sword",
    Flag = "Weapon",
    Callback = function(value)
        print("Selected weapon:", value)
    end
})

-- Tab 2: Advanced
local AdvancedTab = Window:CreateTab("Advanced")

AdvancedTab:AddLabel("🔧 Advanced Settings")

local multiDropdown = AdvancedTab:AddMultiDropdown({
    Name = "Select Players",
    Options = {"Player1", "Player2", "Player3", "Player4", "Player5"},
    Default = {"Player1"},
    Flag = "SelectedPlayers",
    Callback = function(values)
        print("Selected players:")
        for player, enabled in pairs(values) do
            if enabled then
                print("-", player)
            end
        end
    end
})

local textbox1 = AdvancedTab:AddTextBox({
    Name = "Enter Message",
    Placeholder = "Type something...",
    Default = "",
    Flag = "Message",
    Callback = function(text)
        print("Text entered:", text)
    end
})

local colorPicker1 = AdvancedTab:AddColorPicker({
    Name = "Choose Color",
    Default = Color3.fromRGB(255, 0, 0),
    Flag = "PlayerColor",
    Callback = function(color)
        print("Color selected:", color)
    end
})

AdvancedTab:AddButton({
    Name = "Refresh Dropdown",
    Callback = function()
        dropdown1:Refresh({"Knife", "Pistol", "Rifle", "Shotgun"})
        print("Dropdown refreshed!")
    end
})

-- Tab 3: Animations (R6)
local AnimTab = Window:CreateTab("Animation")

AnimTab:AddLabel("🎭 R6 Animations")

AnimTab:AddButton({
    Name = "Winged Master Dance",
    Callback = function()
        -- Load animation
        local player = game.Players.LocalPlayer
        local character = player.Character or player.CharacterAdded:Wait()
        local humanoid = character:WaitForChild("Humanoid")
        
        local animationId = "rbxassetid://YOUR_ANIMATION_ID"
        local animation = Instance.new("Animation")
        animation.AnimationId = animationId
        
        local animator = humanoid:FindFirstChild("Animator")
        if not animator then
            animator = Instance.new("Animator")
            animator.Parent = humanoid
        end
        
        local animTrack = animator:LoadAnimation(animation)
        animTrack:Play()
        
        print("Playing Winged Master animation")
    end
})

AnimTab:AddButton({
    Name = "Da Feets Dance",
    Callback = function()
        print("Playing Da Feets animation")
    end
})

AnimTab:AddButton({
    Name = "Human Car",
    Callback = function()
        print("Playing Human Car animation")
    end
})

AnimTab:AddButton({
    Name = "Rickroll Dance",
    Callback = function()
        print("Playing Rickroll animation")
    end
})

AnimTab:AddToggle({
    Name = "Loop Animation",
    Default = false,
    Flag = "LoopAnim",
    Callback = function(value)
        print("Loop animation:", value)
    end
})

-- Tab 4: Player Settings
local PlayerTab = Window:CreateTab("Player")

PlayerTab:AddLabel("👤 Player Settings")

PlayerTab:AddSlider({
    Name = "Jump Power",
    Min = 50,
    Max = 200,
    Default = 50,
    Increment = 5,
    Flag = "JumpPower",
    Callback = function(value)
        print("Jump power:", value)
        -- game.Players.LocalPlayer.Character.Humanoid.JumpPower = value
    end
})

PlayerTab:AddSlider({
    Name = "Gravity",
    Min = 0,
    Max = 196,
    Default = 196,
    Increment = 1,
    Flag = "Gravity",
    Callback = function(value)
        print("Gravity:", value)
        -- game.Workspace.Gravity = value
    end
})

PlayerTab:AddToggle({
    Name = "Infinite Jump",
    Default = false,
    Flag = "InfJump",
    Callback = function(value)
        print("Infinite jump:", value)
    end
})

PlayerTab:AddToggle({
    Name = "No Clip",
    Default = false,
    Flag = "NoClip",
    Callback = function(value)
        print("No clip:", value)
    end
})

PlayerTab:AddButton({
    Name = "Reset Character",
    Callback = function()
        game.Players.LocalPlayer.Character:BreakJoints()
    end
})

-- Tab 5: Teleport
local TeleportTab = Window:CreateTab("Teleport")

TeleportTab:AddLabel("📍 Teleport Locations")

local locations = {
    ["Spawn"] = Vector3.new(0, 5, 0),
    ["Shop"] = Vector3.new(100, 5, 100),
    ["Arena"] = Vector3.new(-100, 5, -100),
    ["Secret Area"] = Vector3.new(200, 50, 200)
}

for name, position in pairs(locations) do
    TeleportTab:AddButton({
        Name = "TP to " .. name,
        Callback = function()
            local player = game.Players.LocalPlayer
            if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                player.Character.HumanoidRootPart.CFrame = CFrame.new(position)
                print("Teleported to " .. name)
            end
        end
    })
end

TeleportTab:AddToggle({
    Name = "Auto Farm Location",
    Default = false,
    Flag = "AutoFarm",
    Callback = function(value)
        print("Auto farm:", value)
        -- Add auto farm logic here
    end
})

-- Tab 6: Misc
local MiscTab = Window:CreateTab("Misc")

MiscTab:AddLabel("🔧 Miscellaneous Settings")

MiscTab:AddToggle({
    Name = "Full Bright",
    Default = false,
    Flag = "FullBright",
    Callback = function(value)
        print("Full bright:", value)
        if value then
            game.Lighting.Brightness = 2
            game.Lighting.ClockTime = 14
            game.Lighting.FogEnd = 100000
            game.Lighting.GlobalShadows = false
            game.Lighting.OutdoorAmbient = Color3.fromRGB(128, 128, 128)
        else
            game.Lighting.Brightness = 1
            game.Lighting.ClockTime = 12
            game.Lighting.FogEnd = 100000
            game.Lighting.GlobalShadows = true
            game.Lighting.OutdoorAmbient = Color3.fromRGB(70, 70, 70)
        end
    end
})

MiscTab:AddToggle({
    Name = "Remove Fog",
    Default = false,
    Flag = "RemoveFog",
    Callback = function(value)
        print("Remove fog:", value)
        if value then
            game.Lighting.FogEnd = 100000
        else
            game.Lighting.FogEnd = 1000
        end
    end
})

MiscTab:AddButton({
    Name = "Unlock FPS",
    Callback = function()
        setfpscap(999)
        print("FPS unlocked!")
    end
})

MiscTab:AddSlider({
    Name = "FOV",
    Min = 70,
    Max = 120,
    Default = 70,
    Increment = 1,
    Flag = "FOV",
    Callback = function(value)
        print("FOV:", value)
        game.Workspace.CurrentCamera.FieldOfView = value
    end
})

MiscTab:AddTextBox({
    Name = "Chat Message",
    Placeholder = "Enter chat message...",
    Default = "",
    Flag = "ChatMsg",
    Callback = function(text)
        if text ~= "" then
            game.ReplicatedStorage.DefaultChatSystemChatEvents.SayMessageRequest:FireServer(text, "All")
        end
    end
})

-- Tab 7: Config
local ConfigTab = Window:CreateTab("Config")

ConfigTab:AddLabel("💾 Configuration Manager")

local configName = ""

ConfigTab:AddTextBox({
    Name = "Config Name",
    Placeholder = "MyConfig",
    Default = "DefaultConfig",
    Flag = "ConfigName",
    Callback = function(text)
        configName = text
    end
})

ConfigTab:AddButton({
    Name = "Save Config",
    Callback = function()
        if configName ~= "" then
            local success = Window:SaveConfig(configName)
            if success then
                print("✅ Config saved: " .. configName)
            else
                print("❌ Failed to save config")
            end
        else
            print("⚠️ Please enter a config name")
        end
    end
})

ConfigTab:AddButton({
    Name = "Load Config",
    Callback = function()
        if configName ~= "" then
            local success = Window:LoadConfig(configName)
            if success then
                print("✅ Config loaded: " .. configName)
                -- Update all UI elements with loaded values
                toggle1:Set(Window.Flags["MainToggle"] or false)
                slider1:Set(Window.Flags["WalkSpeed"] or 16)
                dropdown1:Set(Window.Flags["Weapon"] or "Sword")
            else
                print("❌ Failed to load config or config not found")
            end
        else
            print("⚠️ Please enter a config name")
        end
    end
})

ConfigTab:AddButton({
    Name = "Reset All Settings",
    Callback = function()
        Window.Flags = {}
        print("🔄 All settings reset")
    end
})

ConfigTab:AddLabel("")
ConfigTab:AddLabel("📝 Available Flags:")
ConfigTab:AddLabel("- MainToggle, WalkSpeed, Weapon")
ConfigTab:AddLabel("- SelectedPlayers, Message, PlayerColor")
ConfigTab:AddLabel("- JumpPower, Gravity, InfJump, NoClip")
ConfigTab:AddLabel("- AutoFarm, FullBright, RemoveFog, FOV")

-- Tab 8: Credits
local CreditsTab = Window:CreateTab("Credits")

CreditsTab:AddLabel("👨‍💻 Universal UI Library v1.0")
CreditsTab:AddLabel("")
CreditsTab:AddLabel("Created by: Your Name")
CreditsTab:AddLabel("Discord: YourDiscord#0000")
CreditsTab:AddLabel("")
CreditsTab:AddLabel("Features:")
CreditsTab:AddLabel("✓ Modern UI Design")
CreditsTab:AddLabel("✓ Smooth Animations")
CreditsTab:AddLabel("✓ Config System")
CreditsTab:AddLabel("✓ Multiple Element Types")
CreditsTab:AddLabel("✓ Minimize/Maximize")
CreditsTab:AddLabel("✓ Easy to Use")
CreditsTab:AddLabel("")
CreditsTab:AddLabel("Thanks for using!")

CreditsTab:AddButton({
    Name = "Copy Discord",
    Callback = function()
        setclipboard("YourDiscord#0000")
        print("Discord copied to clipboard!")
    end
})

CreditsTab:AddButton({
    Name = "Join Discord Server",
    Callback = function()
        print("Opening Discord invite...")
        -- You can use syn.request or http request to open URL
    end
})

-- Demo Auto Updates
print("Universal UI Library loaded successfully!")
print("Total Tabs:", #Window.Tabs)
print("Total Flags:", #Window.Flags)

-- Example of programmatically changing values
task.spawn(function()
    wait(2)
    print("\n🎯 Demonstrating programmatic control:")
    
    wait(1)
    print("Setting toggle to true...")
    toggle1:Set(true)
    
    wait(1)
    print("Setting slider to 100...")
    slider1:Set(100)
    
    wait(1)
    print("Setting dropdown to 'Bow'...")
    dropdown1:Set("Bow")
    
    wait(1)
    print("Setting multi-dropdown...")
    multiDropdown:Set({"Player2", "Player3"})
    
    print("\n✅ Demo complete!")
end)

-- Anti-AFK (Bonus feature)
local VirtualUser = game:GetService("VirtualUser")
game:GetService("Players").LocalPlayer.Idled:Connect(function()
    VirtualUser:CaptureController()
    VirtualUser:ClickButton2(Vector2.new())
end)

print("\n🛡️ Anti-AFK enabled")
print("Press the minimize button (-) to hide the UI")
print("Click the round button (+) to show it again")

--[[
    USAGE INSTRUCTIONS:
    
    1. Load the library using loadstring or require
    2. Create a window with Library:CreateWindow()
    3. Create tabs with Window:CreateTab()
    4. Add elements to tabs using Tab:AddElement()
    5. Save/Load configs with Window:SaveConfig() and Window:LoadConfig()
    
    AVAILABLE ELEMENTS:
    - AddLabel(text)
    - AddButton(config)
    - AddToggle(config)
    - AddSlider(config)
    - AddDropdown(config)
    - AddMultiDropdown(config)
    - AddTextBox(config)
    - AddColorPicker(config)
    
    CONFIG STRUCTURE:
    {
        Name = "Element Name",
        Text = "Element Text", -- Alternative to Name
        Default = value,
        Min = number, -- For sliders
        Max = number, -- For sliders
        Increment = number, -- For sliders
        Options = {}, -- For dropdowns
        Placeholder = "text", -- For textboxes
        Flag = "FlagName", -- For saving/loading
        Callback = function(value) end
    }
    
    PROGRAMMATIC CONTROL:
    local element = Tab:AddElement(config)
    element:Set(value) -- Change value programmatically
    element:Refresh(newOptions) -- For dropdowns only
    
    WINDOW FUNCTIONS:
    Window:SaveConfig(name) -- Save current configuration
    Window:LoadConfig(name) -- Load saved configuration
    Window.Flags -- Access all flag values
    Window.MinimizeButton -- Access minimize button
    
    TIPS:
    - Use flags for elements you want to save/load
    - Callbacks are called when element values change
    - The UI automatically handles minimize/maximize
    - Config files are saved in the ConfigFolder
    - All colors can be customized in CreateWindow
    
    CUSTOMIZATION:
    ThemePrimary = Main background color
    ThemeSecondary = Secondary elements color
    ThemeAccent = Accent/highlight color
    ConfigFolder = Folder name for saving configs
]]
