-- ESPLock Library
local ESPLock = {}
local active = false
local connections = {}

local plots = workspace:WaitForChild("Plots")

-- bikin billboard besar dan sync text
local function createBigBillboard(originalLabel)
	local main = originalLabel:FindFirstAncestor("Main")
	if not main then return end

	-- hapus lama
	local old = main:FindFirstChild("RemainingTime_Big")
	if old then old:Destroy() end

	-- buat clone Billboard
	local cloneBillboard = Instance.new("BillboardGui")
	cloneBillboard.Name = "RemainingTime_Big"
	cloneBillboard.AlwaysOnTop = true
	cloneBillboard.Size = UDim2.new(0, 100, 0, 35)
	cloneBillboard.StudsOffset = Vector3.new(0, 2, 0)
	cloneBillboard.MaxDistance = 1500
	cloneBillboard.Parent = main

	-- label clone
	local cloneLabel = Instance.new("TextLabel")
	cloneLabel.Size = UDim2.new(1, 0, 1, 0)
	cloneLabel.BackgroundTransparency = 1
	cloneLabel.TextColor3 = originalLabel.TextColor3
	cloneLabel.TextScaled = true
	cloneLabel.Font = originalLabel.Font
	cloneLabel.TextStrokeTransparency = 0
	cloneLabel.Parent = cloneBillboard

	-- sinkron teks
	local function sync()
		if originalLabel and originalLabel.Parent then
			cloneLabel.Text = originalLabel.Text
		end
	end
	sync()

	local textConn = originalLabel:GetPropertyChangedSignal("Text"):Connect(sync)

	-- simpan biar bisa dibersihkan saat disable
	table.insert(connections, textConn)
	table.insert(connections, cloneBillboard)
end

-- pasang listener buat 1 model
local function watchModel(model)
	local purchases = model:FindFirstChild("Purchases")
	if not purchases then return end
	local plotBlock = purchases:FindFirstChild("PlotBlock")
	if not plotBlock then return end
	local main = plotBlock:FindFirstChild("Main")
	if not main then return end

	if main:FindFirstChild("BillboardGui") then
		local rt = main.BillboardGui:FindFirstChild("RemainingTime")
		if rt then
			createBigBillboard(rt)
		end

		-- pantau kalau RemainingTime ditambah belakangan
		local conn = main.BillboardGui.ChildAdded:Connect(function(child)
			if child.Name == "RemainingTime" and child:IsA("TextLabel") then
				createBigBillboard(child)
			end
		end)
		table.insert(connections, conn)
	end
end

-- ========== PUBLIC FUNCTIONS ==========
function ESPLock:Enable()
	if active then return end
	active = true

	-- scan semua plot
	for _, model in pairs(plots:GetChildren()) do
		if model:IsA("Model") then
			watchModel(model)
		end
	end

	-- pantau plot baru
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

	-- bersihkan semua billboard & connections
	for _, c in ipairs(connections) do
		if typeof(c) == "RBXScriptConnection" then
			c:Disconnect()
		elseif typeof(c) == "Instance" and c:IsA("BillboardGui") then
			c:Destroy()
		end
	end
	connections = {}
end

return ESPLock
