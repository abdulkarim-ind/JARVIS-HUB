-- ESPLock Library
local ESPLock = {}
local active = false
local connections = {}

local plots = workspace:WaitForChild("Plots")

-- bikin billboard besar dan sync text (TIDAK HAPUS, CUKUP BUAT SEKALI)
local function createBigBillboard(originalLabel, modelId)
	local main = originalLabel:FindFirstAncestor("Main")
	if not main then return end

	-- cari clone lama berdasarkan nama model (biar unik per model)
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

		-- label clone
		local cloneLabel = Instance.new("TextLabel")
		cloneLabel.Name = "Label"
		cloneLabel.Size = UDim2.new(1, 0, 1, 0)
		cloneLabel.BackgroundTransparency = 1
		cloneLabel.TextColor3 = originalLabel.TextColor3
		cloneLabel.TextScaled = true
		cloneLabel.Font = originalLabel.Font
		cloneLabel.TextStrokeTransparency = 0
		cloneLabel.Parent = cloneBillboard

		-- simpan agar bisa dibersihkan
		table.insert(connections, cloneBillboard)
	end

	-- ambil label clone (selalu ada sekarang)
	local cloneLabel = cloneBillboard:FindFirstChild("Label")
	if not cloneLabel then return end

	-- fungsi sync text
	local function sync()
		if originalLabel and originalLabel.Parent then
			cloneLabel.Text = originalLabel.Text
		end
	end
	sync()

	-- koneksi perubahan teks
	local textConn = originalLabel:GetPropertyChangedSignal("Text"):Connect(sync)
	table.insert(connections, textConn)
end

-- pasang listener buat BillboardGui dalam 1 model
local function setupBillboard(billboard, modelId)
	local rt = billboard:FindFirstChild("RemainingTime")
	if rt and rt:IsA("TextLabel") then
		createBigBillboard(rt, modelId)
	end

	-- kalau RemainingTime baru ditambah belakangan
	local conn = billboard.ChildAdded:Connect(function(child)
		if child.Name == "RemainingTime" and child:IsA("TextLabel") then
			createBigBillboard(child, modelId)
		end
	end)
	table.insert(connections, conn)
end

-- pasang listener buat 1 model
local function watchModel(model)
	local modelId = model.Name -- pakai nama model sebagai ID unik

	local purchases = model:FindFirstChild("Purchases")
	if not purchases then return end
	local plotBlock = purchases:FindFirstChild("PlotBlock")
	if not plotBlock then return end
	local main = plotBlock:FindFirstChild("Main")
	if not main then return end

	-- cek semua BillboardGui yang ada sekarang
	for _, child in ipairs(main:GetChildren()) do
		if child:IsA("BillboardGui") then
			setupBillboard(child, modelId)
		end
	end

	-- pantau kalau BillboardGui baru muncul belakangan
	local conn = main.ChildAdded:Connect(function(child)
		if child:IsA("BillboardGui") then
			setupBillboard(child, modelId)
		end
	end)
	table.insert(connections, conn)
end

-- ========== PUBLIC FUNCTIONS ==========
function ESPLock:Enable()
	if active then return end
	active = true

	-- scan semua plot (total 8 model)
	for _, model in pairs(plots:GetChildren()) do
		if model:IsA("Model") then
			watchModel(model)
		end
	end

	-- pantau plot baru
	local conn1 = plots.ChildAdded:Connect(function(model)
		if model:IsA("Model") then
			task.wait(1) -- kasih delay biar child sudah kebentuk
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
		end
		-- billboard clone TIDAK dihapus → tetap ada meski disable
	end
	connections = {}
end

return ESPLock
