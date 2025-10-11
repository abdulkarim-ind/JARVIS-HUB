-- JarvisLib.lua
-- Modern sidebar UI + many elements (Toggle, Slider, Dropdown, MultiDropdown, Keybind, Divider, TextBox, Label, Button, Notification)
-- Author: xeAtheo (adapted)

local Jarvis = {}
Jarvis.__index = Jarvis

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")

local LocalPlayer = Players.LocalPlayer

-- Utility helpers
local function New(instType, props)
	local inst = Instance.new(instType)
	if props then
		for k,v in pairs(props) do
			if k == "Parent" then
				inst.Parent = v
			else
				inst[k] = v
			end
		end
	end
	return inst
end

local function tweenProperty(instance, propTable, info)
	info = info or TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
	local success, t = pcall(function()
		return TweenService:Create(instance, info, propTable)
	end)
	if success and t then t:Play() end
end

-- Create window
function Jarvis:CreateWindow(opts)
	opts = opts or {}
	local title = opts.Name or "JARVIS HUB"
	local size = opts.Size or UDim2.new(0, 700, 0, 420)
	local pos = opts.Position or UDim2.new(0.5, -350, 0.5, -210)
	local theme = opts.Theme or "Dark" -- future use

	-- Parent ScreenGui
	local screenGui = New("ScreenGui", {Name = "JarvisUI", Parent = LocalPlayer:WaitForChild("PlayerGui"), ResetOnSpawn = false})
	screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

	-- Main frame
	local main = New("Frame", {
		Name = "Main",
		Parent = screenGui,
		Size = size,
		Position = pos,
		BackgroundColor3 = Color3.fromRGB(25,25,25),
		BorderSizePixel = 0,
	})
	New("UICorner", {Parent = main, CornerRadius = UDim.new(0,10)})

	-- Header
	local header = New("Frame", {
		Name = "Header",
		Parent = main,
		Size = UDim2.new(1,0,0,36),
		Position = UDim2.new(0,0,0,0),
		BackgroundTransparency = 1,
	})
	local titleLbl = New("TextLabel", {
		Parent = header,
		Name = "Title",
		Text = title,
		Font = Enum.Font.GothamBold,
		TextSize = 16,
		TextColor3 = Color3.fromRGB(255,255,255),
		BackgroundTransparency = 1,
		Position = UDim2.new(0,14,0,6),
		Size = UDim2.new(0.7, -14, 1, 0),
		TextXAlignment = Enum.TextXAlignment.Left
	})

	-- Minimize (small) button (in header)
	local minBtn = New("TextButton", {
		Parent = header,
		Name = "MinBtn",
		Text = "—",
		BackgroundTransparency = 1,
		Font = Enum.Font.GothamBold,
		TextSize = 20,
		TextColor3 = Color3.fromRGB(255,255,255),
		Position = UDim2.new(1, -70, 0, 0),
		Size = UDim2.new(0,36,1,0),
	})

	-- Close button (optional)
	local closeBtn = New("TextButton", {
		Parent = header,
		Name = "CloseBtn",
		Text = "✕",
		BackgroundTransparency = 1,
		Font = Enum.Font.GothamBold,
		TextSize = 18,
		TextColor3 = Color3.fromRGB(255,255,255),
		Position = UDim2.new(1, -34, 0, 0),
		Size = UDim2.new(0,36,1,0),
	})

	-- Body (sidebar + content)
	local body = New("Frame", {
		Parent = main,
		Name = "Body",
		Position = UDim2.new(0,0,0,36),
		Size = UDim2.new(1,0,1,-36),
		BackgroundTransparency = 1,
	})

	-- Sidebar
	local sidebar = New("Frame", {
		Parent = body,
		Name = "Sidebar",
		Size = UDim2.new(0,180,1,0),
		BackgroundColor3 = Color3.fromRGB(20,20,20),
		BorderSizePixel = 0,
	})
	New("UIListLayout", {Parent = sidebar, Padding = UDim.new(0,8), SortOrder = Enum.SortOrder.LayoutOrder, HorizontalAlignment = Enum.HorizontalAlignment.Center})

	-- Content
	local content = New("Frame", {
		Parent = body,
		Name = "Content",
		Position = UDim2.new(0,180,0,0),
		Size = UDim2.new(1,-180,1,0),
		BackgroundColor3 = Color3.fromRGB(30,30,30),
		BorderSizePixel = 0,
	})
	New("UICorner", {Parent = content, CornerRadius = UDim.new(0,6)})

	-- Minimize small circular icon (restore)
	local miniIcon = New("ImageButton", {
		Parent = screenGui,
		Name = "MiniIcon",
		Size = UDim2.new(0,52,0,52),
		Position = UDim2.new(1, -72, 1, -72),
		BackgroundTransparency = 1,
		Image = "rbxassetid://10734905324",
		Visible = false
	})

	-- Scrollable content container (we'll create per-tab frames)
	-- Tabs storage
	local tabs = {}
	local currentTab = nil

	-- Notification holder
	local notifHolder = New("Frame", {Parent = screenGui, Name = "NotifHolder", Size = UDim2.new(0,300,0,200), Position = UDim2.new(1, -320, 0.5, -100), BackgroundTransparency = 1})
	notifHolder.AnchorPoint = Vector2.new(0,0.5)

	local notifications = {}

	-- FUNCTIONS: Notification
	function Jarvis:Notify(titleText, descText, timeSec)
		timeSec = timeSec or 3
		local notif = New("Frame", {
			Parent = notifHolder,
			Size = UDim2.new(1,0,0,60),
			BackgroundColor3 = Color3.fromRGB(20,20,20),
			BorderSizePixel = 0,
		})
		New("UICorner", {Parent = notif, CornerRadius = UDim.new(0,6)})
		local t = New("TextLabel", {Parent = notif, Text = titleText or "Notification", Font = Enum.Font.GothamBold, TextSize = 14, TextColor3 = Color3.fromRGB(255,255,255), BackgroundTransparency = 1, Position = UDim2.new(0,12,0,6), Size = UDim2.new(1,-24,0,20), TextXAlignment = Enum.TextXAlignment.Left})
		local d = New("TextLabel", {Parent = notif, Text = descText or "", Font = Enum.Font.Gotham, TextSize = 12, TextColor3 = Color3.fromRGB(200,200,200), BackgroundTransparency = 1, Position = UDim2.new(0,12,0,28), Size = UDim2.new(1,-24,0,24), TextXAlignment = Enum.TextXAlignment.Left})
		table.insert(notifications, notif)
		-- reposition stack
		for i,v in ipairs(notifications) do
			v.Position = UDim2.new(0,0,0,(i-1)*68)
			v.AnchorPoint = Vector2.new(0,0)
		end
		-- fade in
		notif.BackgroundTransparency = 1
		t.Visible = false
		d.Visible = false
		tweenProperty(notif, {BackgroundTransparency = 0}, TweenInfo.new(0.18))
		wait(0.06)
		t.Visible = true; d.Visible = true
		-- remove after time
		spawn(function()
			wait(timeSec)
			tweenProperty(notif, {BackgroundTransparency = 1}, TweenInfo.new(0.18))
			wait(0.18)
			for idx, val in ipairs(notifications) do
				if val == notif then
					table.remove(notifications, idx)
					break
				end
			end
			notif:Destroy()
			-- re-stack
			for i,v in ipairs(notifications) do
				tweenProperty(v, {Position = UDim2.new(0,0,0,(i-1)*68)}, TweenInfo.new(0.18))
			end
		end)
	end

	-- Toggle minimize functions
	local function toggleMin()
		main.Visible = not main.Visible
		miniIcon.Visible = not main.Visible
	end

	minBtn.MouseButton1Click:Connect(toggleMin)
	closeBtn.MouseButton1Click:Connect(function()
		screenGui:Destroy()
	end)
	miniIcon.MouseButton1Click:Connect(toggleMin)

	-- Dragging (Header)
	do
		local dragging, dragInput, dragStart, startPos
		header.InputBegan:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseButton1 then
				dragging = true
				dragStart = input.Position
				startPos = main.Position
				input.Changed:Connect(function()
					if input.UserInputState == Enum.UserInputState.End then
						dragging = false
					end
				end)
			end
		end)
		header.InputChanged:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseMovement then
				dragInput = input
			end
		end)
		UserInputService.InputChanged:Connect(function(input)
			if input == dragInput and dragging then
				local delta = input.Position - dragStart
				local newPos = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
				main.Position = newPos
			end
		end)
	end

	-- Create a tab function: returns a tab object with element adders
	local function createTab(name)
		local btn = New("TextButton", {
			Parent = sidebar,
			Text = name,
			Size = UDim2.new(0.9,0,0,34),
			Font = Enum.Font.Gotham,
			TextSize = 14,
			TextColor3 = Color3.fromRGB(230,230,230),
			BackgroundColor3 = Color3.fromRGB(28,28,28),
			AutoButtonColor = false,
		})
		New("UICorner", {Parent = btn, CornerRadius = UDim.new(0,6)})

		local page = New("ScrollingFrame", {
			Parent = content,
			Size = UDim2.new(1, -12, 1, -12),
			Position = UDim2.new(0,6,0,6),
			CanvasSize = UDim2.new(0,0,0,0),
			ScrollBarThickness = 6,
			BackgroundTransparency = 1,
			Visible = false
		})
		local listLayout = New("UIListLayout", {Parent = page, SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0,8)})
		local uiPadding = New("UIPadding", {Parent = page, PaddingTop = UDim.new(0,6), PaddingLeft = UDim.new(0,6), PaddingRight = UDim.new(0,6)})

		-- update canvas
		local function updateCanvas()
			local size = listLayout.AbsoluteContentSize
			page.CanvasSize = UDim2.new(0,0,0,size.Y + 12)
		end
		page.ChildAdded:Connect(updateCanvas)
		page.ChildRemoved:Connect(updateCanvas)

		btn.MouseButton1Click:Connect(function()
			for k,v in pairs(content:GetChildren()) do
				if v:IsA("ScrollingFrame") then v.Visible = false end
			end
			page.Visible = true
			currentTab = page
		end)

		-- element creators
		local tabObj = {}

		function tabObj:AddLabel(txt)
			local frame = New("Frame", {Parent = page, Size = UDim2.new(1,0,0,22), BackgroundTransparency = 1})
			local label = New("TextLabel", {Parent = frame, Text = txt, Font = Enum.Font.Gotham, TextSize = 14, TextColor3 = Color3.fromRGB(235,235,235), BackgroundTransparency = 1, Size = UDim2.new(1,0,1,0)})
			return frame
		end

		function tabObj:AddDivider(txt)
			local frame = New("Frame", {Parent = page, Size = UDim2.new(1,0,0,28), BackgroundTransparency = 1})
			local bar = New("Frame", {Parent = frame, BackgroundColor3 = Color3.fromRGB(60,60,60), Size = UDim2.new(1,0,0,2), Position = UDim2.new(0,0,0.5,-1)})
			if txt and txt ~= "" then
				local label = New("TextLabel", {Parent = frame, Text = txt, Font = Enum.Font.GothamBold, TextSize = 12, TextColor3 = Color3.fromRGB(200,200,200), BackgroundTransparency = 1, Position = UDim2.new(0,6,0,0), Size = UDim2.new(0.5,0,1,0), TextXAlignment = Enum.TextXAlignment.Left})
			end
			return frame
		end

		function tabObj:AddButton(txt, callback)
			local frame = New("Frame", {Parent = page, Size = UDim2.new(1,0,0,36), BackgroundTransparency = 1})
			local btn = New("TextButton", {Parent = frame, Text = txt, Size = UDim2.new(0.45,0,0,28), Position = UDim2.new(0,6,0,4), BackgroundColor3 = Color3.fromRGB(50,50,50), Font = Enum.Font.GothamBold, TextSize = 14, TextColor3 = Color3.fromRGB(255,255,255)})
			New("UICorner", {Parent = btn, CornerRadius = UDim.new(0,6)})
			btn.MouseButton1Click:Connect(function() pcall(callback) end)
			return btn
		end

		function tabObj:AddToggle(txt, default, callback)
			local frame = New("Frame", {Parent = page, Size = UDim2.new(1,0,0,34), BackgroundTransparency = 1})
			local label = New("TextLabel", {Parent = frame, Text = txt, Font = Enum.Font.Gotham, TextSize = 14, TextColor3 = Color3.fromRGB(220,220,220), BackgroundTransparency = 1, Position = UDim2.new(0,6,0,0), Size = UDim2.new(0.7,0,1,0), TextXAlignment = Enum.TextXAlignment.Left})
			local btn = New("TextButton", {Parent = frame, Text = (default and "ON") or "OFF", Size = UDim2.new(0,68,0,24), Position = UDim2.new(1,-78,0.5,-12), BackgroundColor3 = default and Color3.fromRGB(0,170,0) or Color3.fromRGB(80,80,80), Font = Enum.Font.GothamBold, TextSize = 13, TextColor3 = Color3.fromRGB(255,255,255)})
			New("UICorner", {Parent = btn, CornerRadius = UDim.new(0,6)})
			local state = default or false
			btn.MouseButton1Click:Connect(function()
				state = not state
				btn.Text = state and "ON" or "OFF"
				btn.BackgroundColor3 = state and Color3.fromRGB(0,170,0) or Color3.fromRGB(80,80,80)
				if callback then pcall(callback, state) end
			end)
			return frame
		end

		function tabObj:AddSlider(txt, min, max, default, callback)
			min = min or 0; max = max or 100; default = default or min
			local frame = New("Frame", {Parent = page, Size = UDim2.new(1,0,0,48), BackgroundTransparency = 1})
			local label = New("TextLabel", {Parent = frame, Text = txt, Font = Enum.Font.Gotham, TextSize = 14, TextColor3 = Color3.fromRGB(220,220,220), BackgroundTransparency = 1, Position = UDim2.new(0,6,0,0), Size = UDim2.new(1,0,0,18), TextXAlignment = Enum.TextXAlignment.Left})
			local valLabel = New("TextLabel", {Parent = frame, Text = tostring(default), Font = Enum.Font.GothamBold, TextSize = 13, TextColor3 = Color3.fromRGB(200,200,200), BackgroundTransparency = 1, Position = UDim2.new(1,-60,0,0), Size = UDim2.new(0,54,0,18), TextXAlignment = Enum.TextXAlignment.Right})
			local bar = New("Frame", {Parent = frame, BackgroundColor3 = Color3.fromRGB(50,50,50), Size = UDim2.new(1,-92,0,10), Position = UDim2.new(0,6,0,26)})
			New("UICorner", {Parent = bar, CornerRadius = UDim.new(0,6)})
			local fill = New("Frame", {Parent = bar, BackgroundColor3 = Color3.fromRGB(181,1,31), Size = UDim2.new(((default-min)/(max-min)),0,1,0)})
			New("UICorner", {Parent = fill, CornerRadius = UDim.new(0,6)})

			local dragging = false
			bar.InputBegan:Connect(function(input)
				if input.UserInputType == Enum.UserInputType.MouseButton1 then
					dragging = true
				end
			end)
			bar.InputEnded:Connect(function(input)
				if input.UserInputType == Enum.UserInputType.MouseButton1 then
					dragging = false
				end
			end)
			UserInputService.InputChanged:Connect(function(input)
				if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
					local absPos = bar.AbsolutePosition.X
					local mX = UserInputService:GetMouseLocation().X
					local width = bar.AbsoluteSize.X
					local relative = math.clamp((mX - absPos) / width, 0, 1)
					fill.Size = UDim2.new(relative,0,1,0)
					local value = math.floor(min + (max-min) * relative)
					valLabel.Text = tostring(value)
					if callback then pcall(callback, value) end
				end
			end)

			return frame
		end

		function tabObj:AddDropdown(txt, options, default, callback)
			local frame = New("Frame", {Parent = page, Size = UDim2.new(1,0,0,42), BackgroundTransparency = 1})
			local label = New("TextLabel", {Parent = frame, Text = txt, Font = Enum.Font.Gotham, TextSize = 14, TextColor3 = Color3.fromRGB(220,220,220), BackgroundTransparency = 1, Position = UDim2.new(0,6,0,0), Size = UDim2.new(0.5,0,1,0), TextXAlignment = Enum.TextXAlignment.Left})
			local btn = New("TextButton", {Parent = frame, Text = tostring(default or options[1] or ""), Size = UDim2.new(0.6,0,0,28), Position = UDim2.new(0.35,0,0.12,0), BackgroundColor3 = Color3.fromRGB(40,40,40), Font = Enum.Font.Gotham, TextSize = 14, TextColor3 = Color3.fromRGB(255,255,255)})
			New("UICorner", {Parent = btn, CornerRadius = UDim.new(0,6)})
			local drop = New("Frame", {Parent = frame, Size = UDim2.new(1,0,0,0), Position = UDim2.new(0,0,1,4), BackgroundColor3 = Color3.fromRGB(30,30,30), ClipsDescendants = true})
			New("UICorner", {Parent = drop, CornerRadius = UDim.new(0,6)})

			local open = false
			local function refreshList()
				for i,v in pairs(drop:GetChildren()) do if v:IsA("TextButton") or v:IsA("TextLabel") then v:Destroy() end end
				local y = 6
				for i,opt in ipairs(options) do
					local optBtn = New("TextButton", {Parent = drop, Text = opt, Size = UDim2.new(1,-12,0,30), Position = UDim2.new(0,6,0,y), BackgroundColor3 = Color3.fromRGB(45,45,45), Font = Enum.Font.Gotham, TextSize = 14, TextColor3 = Color3.fromRGB(255,255,255)})
					New("UICorner", {Parent = optBtn, CornerRadius = UDim.new(0,6)})
					optBtn.MouseButton1Click:Connect(function()
						btn.Text = opt
						if callback then pcall(callback, opt) end
						-- close
						open = false
						tweenProperty(drop, {Size = UDim2.new(1,0,0,0)})
					end)
					y = y + 36
				end
				drop.Size = UDim2.new(1,0,0,0)
				drop.Position = UDim2.new(0,0,1,4)
				tweenProperty(drop, {Size = UDim2.new(1,0,0, math.max(0, y))})
			end

			btn.MouseButton1Click:Connect(function()
				open = not open
				if open then
					refreshList()
				else
					tweenProperty(drop, {Size = UDim2.new(1,0,0,0)})
				end
			end)

			return frame
		end

		function tabObj:AddMultiDropdown(txt, options, defaultTbl, callback)
			defaultTbl = defaultTbl or {}
			local frame = New("Frame", {Parent = page, Size = UDim2.new(1,0,0,46), BackgroundTransparency = 1})
			local label = New("TextLabel", {Parent = frame, Text = txt, Font = Enum.Font.Gotham, TextSize = 14, TextColor3 = Color3.fromRGB(220,220,220), BackgroundTransparency = 1, Position = UDim2.new(0,6,0,0), Size = UDim2.new(0.5,0,1,0), TextXAlignment = Enum.TextXAlignment.Left})
			local btn = New("TextButton", {Parent = frame, Text = table.concat(defaultTbl, ", ") ~= "" and table.concat(defaultTbl, ", ") or "Select...", Size = UDim2.new(0.6,0,0,30), Position = UDim2.new(0.35,0,0.08,0), BackgroundColor3 = Color3.fromRGB(40,40,40), Font = Enum.Font.Gotham, TextSize = 14, TextColor3 = Color3.fromRGB(255,255,255)})
			New("UICorner", {Parent = btn, CornerRadius = UDim.new(0,6)})
			local drop = New("Frame", {Parent = frame, Size = UDim2.new(1,0,0,0), Position = UDim2.new(0,0,1,4), BackgroundColor3 = Color3.fromRGB(30,30,30), ClipsDescendants = true})
			New("UICorner", {Parent = drop, CornerRadius = UDim.new(0,6)})

			local selected = {}
			for _, v in ipairs(defaultTbl) do selected[v] = true end

			local function refresh()
				btn.Text = table.concat((function()
					local t = {}
					for k,v in pairs(selected) do if v then table.insert(t,k) end end
					return t
				end)(), ", ")
				if btn.Text == "" then btn.Text = "Select..." end
			end

			local open = false
			local function build()
				for i,v in pairs(drop:GetChildren()) do if v:IsA("Frame") then v:Destroy() end end
				local y = 6
				for i,opt in ipairs(options) do
					local optFrm = New("Frame", {Parent = drop, Size = UDim2.new(1,-12,0,28), Position = UDim2.new(0,6,0,y), BackgroundTransparency = 1})
					local optLabel = New("TextLabel", {Parent = optFrm, Text = opt, Size = UDim2.new(0.7,0,1,0), Position = UDim2.new(0,0,0,0), BackgroundTransparency = 1, Font = Enum.Font.Gotham, TextSize = 14, TextColor3 = Color3.fromRGB(255,255,255), TextXAlignment = Enum.TextXAlignment.Left})
					local chk = New("TextButton", {Parent = optFrm, Text = selected[opt] and "✓" or "", Size = UDim2.new(0,36,0,20), Position = UDim2.new(1,-40,0,4), BackgroundColor3 = selected[opt] and Color3.fromRGB(0,170,0) or Color3.fromRGB(60,60,60), Font = Enum.Font.GothamBold, TextSize = 14, TextColor3 = Color3.fromRGB(255,255,255)})
					New("UICorner", {Parent = chk, CornerRadius = UDim.new(0,6)})
					chk.MouseButton1Click:Connect(function()
						selected[opt] = not selected[opt]
						chk.BackgroundColor3 = selected[opt] and Color3.fromRGB(0,170,0) or Color3.fromRGB(60,60,60)
						chk.Text = selected[opt] and "✓" or ""
						refresh()
						if callback then
							local out = {}
							for k,v in pairs(selected) do if v then table.insert(out,k) end end
							pcall(callback, out)
						end
					end)
					y = y + 34
				end
				tweenProperty(drop, {Size = UDim2.new(1,0,0, math.max(0, y))})
			end

			btn.MouseButton1Click:Connect(function()
				open = not open
				if open then build() else tweenProperty(drop, {Size = UDim2.new(1,0,0,0)}) end
			end)

			refresh()
			return frame
		end

		function tabObj:AddKeybind(txt, defaultKey, callback)
			local frame = New("Frame", {Parent = page, Size = UDim2.new(1,0,0,36), BackgroundTransparency = 1})
			local label = New("TextLabel", {Parent = frame, Text = txt, Font = Enum.Font.Gotham, TextSize = 14, TextColor3 = Color3.fromRGB(220,220,220), BackgroundTransparency = 1, Position = UDim2.new(0,6,0,0), Size = UDim2.new(0.7,0,1,0), TextXAlignment = Enum.TextXAlignment.Left})
			local keyBtn = New("TextButton", {Parent = frame, Text = tostring(defaultKey and defaultKey.Name or "None"), Size = UDim2.new(0,80,0,24), Position = UDim2.new(1,-92,0.5,-12), BackgroundColor3 = Color3.fromRGB(40,40,40), Font = Enum.Font.GothamBold, TextSize = 13, TextColor3 = Color3.fromRGB(255,255,255)})
			New("UICorner", {Parent = keyBtn, CornerRadius = UDim.new(0,6)})
			local boundKey = defaultKey

			keyBtn.MouseButton1Click:Connect(function()
				keyBtn.Text = "..."
				local a, b = UserInputService.InputBegan:wait()
				if a and a.KeyCode then
					boundKey = a.KeyCode
					keyBtn.Text = a.KeyCode.Name
				end
			end)

			UserInputService.InputBegan:Connect(function(inp, processed)
				if processed then return end
				if boundKey and inp.KeyCode == boundKey then
					pcall(callback)
				end
			end)

			return frame
		end

		function tabObj:AddTextBox(txt, placeholder, callback)
			local frame = New("Frame", {Parent = page, Size = UDim2.new(1,0,0,40), BackgroundTransparency = 1})
			local label = New("TextLabel", {Parent = frame, Text = txt, Font = Enum.Font.Gotham, TextSize = 14, TextColor3 = Color3.fromRGB(220,220,220), BackgroundTransparency = 1, Position = UDim2.new(0,6,0,0), Size = UDim2.new(0.5,0,0,18), TextXAlignment = Enum.TextXAlignment.Left})
			local boxBg = New("Frame", {Parent = frame, Position = UDim2.new(0.5,0,0,6), Size = UDim2.new(0.48,0,0,28), BackgroundColor3 = Color3.fromRGB(40,40,40)})
			New("UICorner", {Parent = boxBg, CornerRadius = UDim.new(0,6)})
			local txtBox = New("TextBox", {Parent = boxBg, BackgroundTransparency = 1, Size = UDim2.new(1, -8, 1, 0), Position = UDim2.new(0,8,0,0), Font = Enum.Font.Gotham, TextSize = 14, TextColor3 = Color3.fromRGB(255,255,255), PlaceholderText = placeholder or ""})
			txtBox.FocusLost:Connect(function(enter)
				if enter and callback then pcall(callback, txtBox.Text) end
			end)
			return frame
		end

		return tabObj
	end

	-- Return API
	local api = {}

	function api:CreateTab(name)
		local tab = createTab(name)
		-- if first tab, auto-select
		if not currentTab then
			for _,v in pairs(content:GetChildren()) do if v:IsA("ScrollingFrame") then v.Visible = false end end
			for _,v in pairs(sidebar:GetChildren()) do if v:IsA("TextButton") then v.BackgroundColor3 = Color3.fromRGB(28,28,28) end end
			-- find the created tab frame and select it
			for _,v in pairs(content:GetChildren()) do if v:IsA("ScrollingFrame") then v.Visible = false end end
			-- simulate click
			local btn = sidebar:FindFirstChildOfClass("TextButton")
			-- choose newly created (last)
			local lastBtn = sidebar:GetChildren()
			local chosen = nil
			for i = #lastBtn, 1, -1 do
				if lastBtn[i]:IsA("TextButton") then
					chosen = lastBtn[i]
					break
				end
			end
			if chosen then
				chosen:CaptureFocus()
				chosen:MouseButton1Click()
			end
		end
		return tab
	end

	function api:Toggle()
		toggleMin()
	end

	function api:Notify(titleText, descText, dur)
		Jarvis.Notify(self, titleText, descText, dur)
	end

	function api:GetScreenGui()
		return screenGui
	end

	return api
end

return setmetatable({}, { __call = function(_, ...) local obj = {}; setmetatable(obj, Jarvis); return Jarvis end })
