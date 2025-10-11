-- ═══════════════════════════════════════════════════════
-- 🎨 PIAN HUB UI Library v2.0 (FIXED)
-- Modern & Clean UI Components
-- ═══════════════════════════════════════════════════════

local UILib = {}
UILib.__index = UILib

-- ═══ SERVICES ═══
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")

-- ═══ UTILITY FUNCTIONS ═══
local function tween(obj, props, duration)
    TweenService:Create(obj, TweenInfo.new(duration or 0.3, Enum.EasingStyle.Quad), props):Play()
end

local function addCorner(obj, radius)
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, radius or 8)
    corner.Parent = obj
    return corner
end

local function addStroke(obj, color, thickness)
    local stroke = Instance.new("UIStroke")
    stroke.Color = color or Color3.fromRGB(60, 60, 70)
    stroke.Thickness = thickness or 1
    stroke.Parent = obj
    return stroke
end

-- ═══ CREATE WINDOW ═══
function UILib:CreateWindow(title)
    local window = {}
    
    -- Clean old UI
    if CoreGui:FindFirstChild("PianHubUI") then
        CoreGui:FindFirstChild("PianHubUI"):Destroy()
    end
    
    -- ScreenGui
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "PianHubUI"
    ScreenGui.ResetOnSpawn = false
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ScreenGui.Parent = CoreGui
    
    -- Main Frame
    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.Size = UDim2.new(0, 480, 0, 520)
    MainFrame.Position = UDim2.new(0.5, -240, 0.5, -260)
    MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
    MainFrame.BorderSizePixel = 0
    MainFrame.Active = true
    MainFrame.Draggable = true
    MainFrame.Parent = ScreenGui
    addCorner(MainFrame, 12)
    addStroke(MainFrame, Color3.fromRGB(60, 60, 75), 2)
    
    -- Shadow Effect
    local Shadow = Instance.new("ImageLabel")
    Shadow.Name = "Shadow"
    Shadow.BackgroundTransparency = 1
    Shadow.Position = UDim2.new(0, -15, 0, -15)
    Shadow.Size = UDim2.new(1, 30, 1, 30)
    Shadow.ZIndex = 0
    Shadow.Image = "rbxasset://textures/ui/Shadow.png"
    Shadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
    Shadow.ImageTransparency = 0.5
    Shadow.ScaleType = Enum.ScaleType.Slice
    Shadow.SliceCenter = Rect.new(10, 10, 118, 118)
    Shadow.Parent = MainFrame
    
    -- Title Bar
    local TitleBar = Instance.new("Frame")
    TitleBar.Name = "TitleBar"
    TitleBar.Size = UDim2.new(1, 0, 0, 50)
    TitleBar.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
    TitleBar.BorderSizePixel = 0
    TitleBar.Parent = MainFrame
    addCorner(TitleBar, 12)
    
    -- Title Bottom Fix
    local TitleFix = Instance.new("Frame")
    TitleFix.Size = UDim2.new(1, 0, 0, 12)
    TitleFix.Position = UDim2.new(0, 0, 1, -12)
    TitleFix.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
    TitleFix.BorderSizePixel = 0
    TitleFix.Parent = TitleBar
    
    -- Title Icon
    local TitleIcon = Instance.new("TextLabel")
    TitleIcon.Size = UDim2.new(0, 35, 0, 35)
    TitleIcon.Position = UDim2.new(0, 10, 0, 7)
    TitleIcon.BackgroundTransparency = 1
    TitleIcon.Text = "🧩"
    TitleIcon.TextSize = 24
    TitleIcon.Parent = TitleBar
    
    -- Title Text
    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(1, -140, 1, 0)
    Title.Position = UDim2.new(0, 50, 0, 0)
    Title.BackgroundTransparency = 1
    Title.Text = title or "PIAN HUB"
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.TextSize = 18
    Title.Font = Enum.Font.GothamBold
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.Parent = TitleBar
    
    -- Version Label
    local Version = Instance.new("TextLabel")
    Version.Size = UDim2.new(0, 60, 0, 20)
    Version.Position = UDim2.new(0, 50, 0, 25)
    Version.BackgroundTransparency = 1
    Version.Text = "v2.0"
    Version.TextColor3 = Color3.fromRGB(150, 150, 160)
    Version.TextSize = 11
    Version.Font = Enum.Font.Gotham
    Version.TextXAlignment = Enum.TextXAlignment.Left
    Version.Parent = TitleBar
    
    -- Button Helper
    local function createTitleButton(pos, color, text, icon)
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(0, 35, 0, 35)
        btn.Position = pos
        btn.BackgroundColor3 = color
        btn.Text = icon or text
        btn.TextColor3 = Color3.fromRGB(255, 255, 255)
        btn.TextSize = 16
        btn.Font = Enum.Font.GothamBold
        btn.BorderSizePixel = 0
        btn.Parent = TitleBar
        addCorner(btn, 8)
        
        btn.MouseEnter:Connect(function()
            tween(btn, {BackgroundColor3 = Color3.new(color.R + 0.1, color.G + 0.1, color.B + 0.1)}, 0.2)
        end)
        btn.MouseLeave:Connect(function()
            tween(btn, {BackgroundColor3 = color}, 0.2)
        end)
        
        return btn
    end
    
    local MinimizeBtn = createTitleButton(UDim2.new(1, -80, 0, 7), Color3.fromRGB(50, 50, 60), "-", "─")
    local CloseBtn = createTitleButton(UDim2.new(1, -40, 0, 7), Color3.fromRGB(200, 50, 60), "✕", "✕")
    
    -- Floating Icon (saat minimize)
    local FloatingIcon = Instance.new("ImageButton")
    FloatingIcon.Name = "FloatingIcon"
    FloatingIcon.Size = UDim2.new(0, 50, 0, 50)
    FloatingIcon.Position = UDim2.new(0, 20, 0, 100)
    FloatingIcon.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
    FloatingIcon.BorderSizePixel = 0
    FloatingIcon.Visible = false
    FloatingIcon.Active = true
    FloatingIcon.Draggable = true
    FloatingIcon.Parent = ScreenGui
    addCorner(FloatingIcon, 25)
    addStroke(FloatingIcon, Color3.fromRGB(80, 80, 100), 2)
    
    local IconLabel = Instance.new("TextLabel")
    IconLabel.Size = UDim2.new(1, 0, 1, 0)
    IconLabel.BackgroundTransparency = 1
    IconLabel.Text = "🧩"
    IconLabel.TextSize = 28
    IconLabel.Parent = FloatingIcon
    
    -- Tab Bar
    local TabBar = Instance.new("Frame")
    TabBar.Size = UDim2.new(1, -20, 0, 40)
    TabBar.Position = UDim2.new(0, 10, 0, 60)
    TabBar.BackgroundColor3 = Color3.fromRGB(30, 30, 38)
    TabBar.BorderSizePixel = 0
    TabBar.Parent = MainFrame
    addCorner(TabBar, 8)
    
    local TabLayout = Instance.new("UIListLayout")
    TabLayout.FillDirection = Enum.FillDirection.Horizontal
    TabLayout.Padding = UDim.new(0, 8)
    TabLayout.HorizontalAlignment = Enum.HorizontalAlignment.Left
    TabLayout.VerticalAlignment = Enum.VerticalAlignment.Center
    TabLayout.SortOrder = Enum.SortOrder.LayoutOrder
    TabLayout.Parent = TabBar
    
    local TabPadding = Instance.new("UIPadding")
    TabPadding.PaddingLeft = UDim.new(0, 8)
    TabPadding.Parent = TabBar
    
    -- Divider Line
    local Divider = Instance.new("Frame")
    Divider.Size = UDim2.new(1, -20, 0, 1)
    Divider.Position = UDim2.new(0, 10, 0, 108)
    Divider.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
    Divider.BorderSizePixel = 0
    Divider.Parent = MainFrame
    
    -- Content Container
    local ContentContainer = Instance.new("Frame")
    ContentContainer.Size = UDim2.new(1, 0, 1, -118)
    ContentContainer.Position = UDim2.new(0, 0, 0, 118)
    ContentContainer.BackgroundTransparency = 1
    ContentContainer.Parent = MainFrame
    
    window.ScreenGui = ScreenGui
    window.MainFrame = MainFrame
    window.TitleBar = TitleBar
    window.TabBar = TabBar
    window.ContentContainer = ContentContainer
    window.Tabs = {}
    window.CurrentTab = nil
    window.MinimizeBtn = MinimizeBtn
    window.CloseBtn = CloseBtn
    window.FloatingIcon = FloatingIcon
    
    -- Minimize Handler
    MinimizeBtn.MouseButton1Click:Connect(function()
        if MainFrame.Visible then
            MainFrame.Visible = false
            FloatingIcon.Visible = true
        end
    end)
    
    FloatingIcon.MouseButton1Click:Connect(function()
        MainFrame.Visible = true
        FloatingIcon.Visible = false
    end)
    
    return window
end

-- ═══ CREATE TAB ═══
function UILib:CreateTab(window, name, icon)
    local tab = {}
    
    -- Tab Button
    local TabButton = Instance.new("TextButton")
    TabButton.Size = UDim2.new(0, 105, 1, -10)
    TabButton.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
    TabButton.Text = (icon or "📄") .. " " .. name
    TabButton.TextColor3 = Color3.fromRGB(180, 180, 190)
    TabButton.TextSize = 13
    TabButton.Font = Enum.Font.GothamBold
    TabButton.BorderSizePixel = 0
    TabButton.Parent = window.TabBar
    addCorner(TabButton, 6)
    
    -- Content Frame
    local ContentFrame = Instance.new("ScrollingFrame")
    ContentFrame.Name = name .. "Content"
    ContentFrame.Size = UDim2.new(1, -20, 1, -10)
    ContentFrame.Position = UDim2.new(0, 10, 0, 5)
    ContentFrame.BackgroundTransparency = 1
    ContentFrame.BorderSizePixel = 0
    ContentFrame.ScrollBarThickness = 4
    ContentFrame.ScrollBarImageColor3 = Color3.fromRGB(80, 80, 100)
    ContentFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
    ContentFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
    ContentFrame.Visible = false
    ContentFrame.Parent = window.ContentContainer
    
    local Layout = Instance.new("UIListLayout")
    Layout.Padding = UDim.new(0, 10)
    Layout.SortOrder = Enum.SortOrder.LayoutOrder
    Layout.Parent = ContentFrame
    
    tab.Button = TabButton
    tab.Content = ContentFrame
    tab.Layout = Layout
    
    -- Tab Click Handler
    TabButton.MouseButton1Click:Connect(function()
        for _, t in pairs(window.Tabs) do
            t.Content.Visible = false
            t.Button.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
            t.Button.TextColor3 = Color3.fromRGB(180, 180, 190)
        end
        ContentFrame.Visible = true
        TabButton.BackgroundColor3 = Color3.fromRGB(60, 60, 75)
        TabButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        window.CurrentTab = tab
    end)
    
    window.Tabs[name] = tab
    
    -- FIXED: Auto select first tab - gunakan task.spawn untuk delay
    if not window.CurrentTab then
        task.spawn(function()
            task.wait(0.1)
            -- Manually trigger the tab selection
            for _, t in pairs(window.Tabs) do
                t.Content.Visible = false
                t.Button.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
                t.Button.TextColor3 = Color3.fromRGB(180, 180, 190)
            end
            ContentFrame.Visible = true
            TabButton.BackgroundColor3 = Color3.fromRGB(60, 60, 75)
            TabButton.TextColor3 = Color3.fromRGB(255, 255, 255)
            window.CurrentTab = tab
        end)
    end
    
    return tab
end

-- ═══ CREATE SECTION ═══
function UILib:CreateSection(tab, title)
    local Section = Instance.new("Frame")
    Section.Size = UDim2.new(1, 0, 0, 35)
    Section.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
    Section.BorderSizePixel = 0
    Section.Parent = tab.Content
    addCorner(Section, 8)
    
    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(1, -20, 1, 0)
    Label.Position = UDim2.new(0, 10, 0, 0)
    Label.BackgroundTransparency = 1
    Label.Text = "═══ " .. title .. " ═══"
    Label.TextColor3 = Color3.fromRGB(150, 200, 255)
    Label.TextSize = 14
    Label.Font = Enum.Font.GothamBold
    Label.TextXAlignment = Enum.TextXAlignment.Center
    Label.Parent = Section
    
    return Section
end

-- ═══ CREATE TOGGLE ═══
function UILib:CreateToggle(tab, name, default, callback)
    local ToggleFrame = Instance.new("Frame")
    ToggleFrame.Size = UDim2.new(1, 0, 0, 40)
    ToggleFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
    ToggleFrame.BorderSizePixel = 0
    ToggleFrame.Parent = tab.Content
    addCorner(ToggleFrame, 8)
    
    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(1, -60, 1, 0)
    Label.Position = UDim2.new(0, 15, 0, 0)
    Label.BackgroundTransparency = 1
    Label.Text = name
    Label.TextColor3 = Color3.fromRGB(255, 255, 255)
    Label.TextSize = 13
    Label.Font = Enum.Font.Gotham
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Parent = ToggleFrame
    
    local ToggleButton = Instance.new("TextButton")
    ToggleButton.Size = UDim2.new(0, 45, 0, 24)
    ToggleButton.Position = UDim2.new(1, -55, 0.5, -12)
    ToggleButton.BackgroundColor3 = default and Color3.fromRGB(60, 180, 80) or Color3.fromRGB(60, 60, 70)
    ToggleButton.Text = ""
    ToggleButton.BorderSizePixel = 0
    ToggleButton.Parent = ToggleFrame
    addCorner(ToggleButton, 12)
    
    local Circle = Instance.new("Frame")
    Circle.Size = UDim2.new(0, 18, 0, 18)
    Circle.Position = default and UDim2.new(1, -21, 0.5, -9) or UDim2.new(0, 3, 0.5, -9)
    Circle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Circle.BorderSizePixel = 0
    Circle.Parent = ToggleButton
    addCorner(Circle, 9)
    
    local enabled = default
    
    ToggleButton.MouseButton1Click:Connect(function()
        enabled = not enabled
        
        tween(ToggleButton, {
            BackgroundColor3 = enabled and Color3.fromRGB(60, 180, 80) or Color3.fromRGB(60, 60, 70)
        }, 0.3)
        
        tween(Circle, {
            Position = enabled and UDim2.new(1, -21, 0.5, -9) or UDim2.new(0, 3, 0.5, -9)
        }, 0.3)
        
        pcall(callback, enabled)
    end)
    
    return ToggleFrame
end

-- ═══ CREATE BUTTON ═══
function UILib:CreateButton(tab, text, callback)
    local Button = Instance.new("TextButton")
    Button.Size = UDim2.new(1, 0, 0, 40)
    Button.BackgroundColor3 = Color3.fromRGB(50, 50, 65)
    Button.BorderSizePixel = 0
    Button.Text = text
    Button.TextColor3 = Color3.fromRGB(255, 255, 255)
    Button.TextSize = 13
    Button.Font = Enum.Font.GothamBold
    Button.Parent = tab.Content
    addCorner(Button, 8)
    
    Button.MouseEnter:Connect(function()
        tween(Button, {BackgroundColor3 = Color3.fromRGB(70, 70, 85)}, 0.2)
    end)
    Button.MouseLeave:Connect(function()
        tween(Button, {BackgroundColor3 = Color3.fromRGB(50, 50, 65)}, 0.2)
    end)
    
    Button.MouseButton1Click:Connect(function()
        tween(Button, {BackgroundColor3 = Color3.fromRGB(40, 40, 55)}, 0.1)
        task.wait(0.1)
        tween(Button, {BackgroundColor3 = Color3.fromRGB(70, 70, 85)}, 0.1)
        pcall(callback)
    end)
    
    return Button
end

-- ═══ CREATE DIVIDER ═══
function UILib:CreateDivider(tab)
    local Divider = Instance.new("Frame")
    Divider.Size = UDim2.new(1, -20, 0, 1)
    Divider.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
    Divider.BorderSizePixel = 0
    Divider.Parent = tab.Content
    
    return Divider
end

-- ═══ NOTIFICATION ═══
function UILib:Notify(title, message, duration)
    task.spawn(function()
        local Notif = Instance.new("Frame")
        Notif.Size = UDim2.new(0, 320, 0, 90)
        Notif.Position = UDim2.new(1, 340, 1, -110)
        Notif.BackgroundColor3 = Color3.fromRGB(30, 30, 38)
        Notif.BorderSizePixel = 0
        Notif.Parent = CoreGui:FindFirstChild("PianHubUI") or CoreGui
        addCorner(Notif, 10)
        addStroke(Notif, Color3.fromRGB(80, 80, 100), 2)
        
        local NotifTitle = Instance.new("TextLabel")
        NotifTitle.Size = UDim2.new(1, -20, 0, 28)
        NotifTitle.Position = UDim2.new(0, 10, 0, 8)
        NotifTitle.BackgroundTransparency = 1
        NotifTitle.Text = title
        NotifTitle.TextColor3 = Color3.fromRGB(150, 200, 255)
        NotifTitle.TextSize = 14
        NotifTitle.Font = Enum.Font.GothamBold
        NotifTitle.TextXAlignment = Enum.TextXAlignment.Left
        NotifTitle.Parent = Notif
        
        local NotifMessage = Instance.new("TextLabel")
        NotifMessage.Size = UDim2.new(1, -20, 1, -40)
        NotifMessage.Position = UDim2.new(0, 10, 0, 35)
        NotifMessage.BackgroundTransparency = 1
        NotifMessage.Text = message
        NotifMessage.TextColor3 = Color3.fromRGB(200, 200, 210)
        NotifMessage.TextSize = 12
        NotifMessage.Font = Enum.Font.Gotham
        NotifMessage.TextXAlignment = Enum.TextXAlignment.Left
        NotifMessage.TextYAlignment = Enum.TextYAlignment.Top
        NotifMessage.TextWrapped = true
        NotifMessage.Parent = Notif
        
        -- Slide in
        tween(Notif, {Position = UDim2.new(1, -340, 1, -110)}, 0.5)
        
        task.wait(duration or 4)
        
        -- Slide out
        tween(Notif, {Position = UDim2.new(1, 340, 1, -110)}, 0.5)
        task.wait(0.5)
        Notif:Destroy()
    end)
end

return UILib
