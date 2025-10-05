-- JarvisUI Module
local JarvisUI = {}
JarvisUI.Player = game.Players.LocalPlayer
JarvisUI.GUI = Instance.new("ScreenGui")
JarvisUI.GUI.Name = "JARVIS_UI"
JarvisUI.GUI.ResetOnSpawn = false
JarvisUI.GUI.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
JarvisUI.GUI.Parent = JarvisUI.Player:WaitForChild("PlayerGui")

-- Helper untuk UICorner
local function addUICorner(inst, radius)
	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, radius or 8)
	corner.Parent = inst
	return corner
end

-- === Notify Function ===
function JarvisUI.Notify(titleText, descText)
	local notif = Instance.new("Frame")
	notif.Size = UDim2.new(0, 240, 0, 60)
	notif.Position = UDim2.new(1, -250, 1, 50)
	notif.BackgroundColor3 = Color3.fromRGB(30,30,35)
	notif.BorderSizePixel = 0
	notif.Parent = JarvisUI.GUI
	addUICorner(notif, 8)

	-- Sound
	local sound = Instance.new("Sound")
	sound.SoundId = "rbxassetid://17208361335"
	sound.Volume = 1
	sound.PlayOnRemove = true
	sound.Parent = notif
	sound:Destroy()

	local title = Instance.new("TextLabel")
	title.Size = UDim2.new(1, -10, 0, 18)
	title.Position = UDim2.new(0,5,0,3)
	title.Text = titleText
	title.TextColor3 = Color3.fromRGB(255,255,255)
	title.Font = Enum.Font.GothamBold
	title.TextSize = 14
	title.BackgroundTransparency = 1
	title.TextXAlignment = Enum.TextXAlignment.Left
	title.Parent = notif

	local desc = Instance.new("TextLabel")
	desc.Size = UDim2.new(1,-10,1,-20)
	desc.Position = UDim2.new(0,5,0,20)
	desc.Text = descText
	desc.TextColor3 = Color3.fromRGB(220,220,220)
	desc.TextWrapped = true
	desc.Font = Enum.Font.Gotham
	desc.TextSize = 13
	desc.BackgroundTransparency = 1
	desc.TextXAlignment = Enum.TextXAlignment.Left
	desc.TextYAlignment = Enum.TextYAlignment.Top
	desc.Parent = notif

	notif:TweenPosition(UDim2.new(1,-250,1,-100),"Out","Sine",0.4,true)

	task.delay(3.5,function()
		notif:TweenPosition(UDim2.new(1,-250,1,80),"In","Sine",0.4,true)
		task.wait(0.5)
		notif:Destroy()
	end)
end

-- === Create Toggle ===
function JarvisUI.CreateToggle(parent, labelText, yOffset)
	local container = Instance.new("Frame")
	container.Size = UDim2.new(0.9,0,0,35)
	container.Position = UDim2.new(0.05,0,0,yOffset)
	container.BackgroundColor3 = Color3.fromRGB(40,40,45)
	container.Parent = parent
	addUICorner(container, 8)

	local label = Instance.new("TextLabel")
	label.Text = labelText
	label.Size = UDim2.new(0.7,0,1,0)
	label.Position = UDim2.new(0,8,0,0)
	label.TextColor3 = Color3.fromRGB(235,235,235)
	label.Font = Enum.Font.GothamSemibold
	label.TextSize = 13
	label.BackgroundTransparency = 1
	label.TextXAlignment = Enum.TextXAlignment.Left
	label.Parent = container

	local toggle = Instance.new("Frame")
	toggle.Size = UDim2.new(0,40,0,18)
	toggle.Position = UDim2.new(1,-50,0.5,-9)
	toggle.BackgroundColor3 = Color3.fromRGB(70,70,75)
	toggle.Parent = container
	addUICorner(toggle, 100)

	local knob = Instance.new("Frame")
	knob.Size = UDim2.new(0,16,0,16)
	knob.Position = UDim2.new(0,1,0,1)
	knob.BackgroundColor3 = Color3.fromRGB(240,240,240)
	knob.Parent = toggle
	addUICorner(knob, 100)

	local active = false
	local function set(state)
		active = state
		if state then
			toggle.BackgroundColor3 = Color3.fromRGB(0,180,0)
			knob:TweenPosition(UDim2.new(1,-17,0,1),"Out","Sine",0.2,true)
		else
			toggle.BackgroundColor3 = Color3.fromRGB(70,70,75)
			knob:TweenPosition(UDim2.new(0,1,0,1),"Out","Sine",0.2,true)
		end
	end
	local function get()
		return active
	end

	return container, toggle, knob, set, get
end

-- === Create Button ===
function JarvisUI.CreateButton(parent, text, callback, yOffset)
	local btn = Instance.new("TextButton")
	btn.Size = UDim2.new(0.9,0,0,30)
	btn.Position = UDim2.new(0.05,0,0,yOffset or 0)
	btn.BackgroundColor3 = Color3.fromRGB(50,50,55)
	btn.TextColor3 = Color3.fromRGB(255,255,255)
	btn.Font = Enum.Font.GothamBold
	btn.TextSize = 14
	btn.Text = text
	btn.Parent = parent
	addUICorner(btn, 8)
	btn.MouseButton1Click:Connect(callback)
	return btn
end

return JarvisUI
