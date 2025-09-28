-- [[ ESPLock Library ]]
local ESPLock = {}
local active = false
local connections = {}

local plots = workspace:WaitForChild("Plots")

-- [[ Buat Billboard Tambahan ]]
local function createBigBillboard(originalLabel, modelId)
	local main = originalLabel:FindFirstAncestor("Main")
	if not main then return end

	local cloneName = "RemainingTime_Big_" .. modelId
	local cloneBillboard = main:FindFirstChild(cloneName)

	-- kalau belum ada clone → buat
	if not cloneBillboard then
		cloneBillboard = Instance.new("BillboardGui")
		cloneBillboard.Name = cloneName
		cloneBillboard.AlwaysOnTop = true
		cloneBillboard.Size = UDim2.new(0, 100, 0, 35)
		cloneBillboard.StudsOffset = Vector3.new(0, 2, 0)
		cloneBillboard.MaxDistance = 1500
		cloneBillboard.Parent = main

		local cloneLabel = Instance.new("TextLabel")
		cloneLabel.Name = "Label"
		cloneLabel.Size = UDim2.new(1, 0, 1, 0)
		cloneLabel.BackgroundTransparency = 1
		cloneLabel.TextColor3 = originalLabel.TextColor3
		cloneLabel.TextScaled = true
		cloneLabel.Font = originalLabel.Font
		cloneLabel.TextStrokeTransparency = 0
		cloneLabel.Parent = cloneBillboard

		table.insert(connections, cloneBillboard)
	end

	local cloneLabel = cloneBillboard:FindFirstChild("Label")
	if not cloneLabel then return end

	-- tracking text
	local lastText = originalLabel.Text
	local lastChange = os.clock()
	local unlocked = false
	local defaultColor = originalLabel.TextColor3

	-- fungsi sync
	local function sync()
		if originalLabel and originalLabel.Parent then
			cloneLabel.Text = originalLabel.Text
			cloneLabel.TextColor3 = defaultColor
			lastText = originalLabel.Text
			lastChange = os.clock()
			unlocked = false
		end
	end
	sync()

	-- koneksi perubahan text
	local textConn = originalLabel:GetPropertyChangedSignal("Text"):Connect(function()
		if originalLabel.Text ~= lastText then
			cloneLabel.Text = originalLabel.Text
			cloneLabel.TextColor3 = defaultColor
			lastText = originalLabel.Text
			lastChange = os.clock()
			unlocked = false
		end
	end)
	table.insert(connections, textConn)

	-- loop cek per 0.5 detik
	task.spawn(function()
		while active and originalLabel.Parent and cloneLabel.Parent do
			if not unlocked and (os.clock() - lastChange) > 2.5 then
				cloneLabel.Text = "Unlocked"
				cloneLabel.TextColor3 = Color3.fromRGB(0, 15, 0)
				unlocked = true
			end
			task.wait(0.5)
		end
	end)
end

-- [[ Setup BillboardGui dalam model ]]
local function setupBillboard(billboard, modelId)
	local rt = billboard:FindFirstChild("RemainingTime")
	if rt and rt:IsA("TextLabel") then
		createBigBillboard(rt, modelId)
	end

	local conn = billboard.ChildAdded:Connect(function(child)
		if child.Name == "RemainingTime" and child:IsA("TextLabel") then
			createBigBillboard(child, modelId)
		end
	end)
	table.insert(connections, conn)
end

-- [[ Pantau 1 Model ]]
local function watchModel(model)
	local modelId = model.Name
	local purchases = model:FindFirstChild("Purchases")
	if not purchases then return end
	local plotBlock = purchases:FindFirstChild("PlotBlock")
	if not plotBlock then return end
	local main = plotBlock:FindFirstChild("Main")
	if not main then return end

	for _, child in ipairs(main:GetChildren()) do
		if child:IsA("BillboardGui") then
			setupBillboard(child, modelId)
		end
	end

	local conn = main.ChildAdded:Connect(function(child)
		if child:IsA("BillboardGui") then
			setupBillboard(child, modelId)
		end
	end)
	table.insert(connections, conn)
end

-- [[ PUBLIC FUNCTIONS ]]
function ESPLock:Enable()
	if active then return end
	active = true

	for _, model in pairs(plots:GetChildren()) do
		if model:IsA("Model") then
			watchModel(model)
		end
	end

	local conn1 = plots.ChildAdded:Connect(function(model)
		if model:IsA("Model") then
			task.wait(1)
			watchModel(model)
		end
	end)
	table.insert(connections, conn1)
end

function ESPLock:Disable()
	if not active then return end
	active = false

	for _, c in ipairs(connections) do
		if typeof(c) == "RBXScriptConnection" then
			c:Disconnect()
		end
	end
	connections = {}
end

return ESPLock
