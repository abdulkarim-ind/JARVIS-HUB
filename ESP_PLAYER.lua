-- ESP Library
local ESP = {}
local active = false
local connections = {}

-- Tambah ESP ke player
function ESP:Add(plr)
    if plr == game.Players.LocalPlayer then return end

    local function applyESP(char)
        local head = char:WaitForChild("Head", 5)
        if not head then return end

        -- Billboard
        local gui = Instance.new("BillboardGui")
        gui.AlwaysOnTop = true
        gui.Size = UDim2.new(0, 100, 0, 20)
        gui.StudsOffset = Vector3.new(0, 2, 0)
        gui.Name = "ESP_Billboard"
        gui.Parent = head

        local txt = Instance.new("TextLabel")
        txt.Size = UDim2.new(1, 0, 1, 0)
        txt.BackgroundTransparency = 1
        txt.Text = plr.Name
        txt.TextColor3 = Color3.fromRGB(255, 50, 50)
        txt.TextScaled = true
        txt.TextStrokeTransparency = 0
        txt.Font = Enum.Font.SourceSansBold
        txt.Parent = gui

        -- Highlight
        local hl = Instance.new("Highlight")
        hl.FillTransparency = 0.5
        hl.OutlineColor = Color3.fromRGB(255, 50, 50)
        hl.Name = "ESP_Highlight"
        hl.Parent = char

        -- Simpan referensi
        connections[plr] = connections[plr] or {}
        table.insert(connections[plr], gui)
        table.insert(connections[plr], hl)
    end

    -- Kalau sudah ada char
    if plr.Character then
        applyESP(plr.Character)
    end

    -- Tambahin listener supaya respawn juga dapet ESP
    local charAddedConn = plr.CharacterAdded:Connect(function(char)
        if active then
            task.wait(1) -- delay dikit biar Head & body kebentuk
            applyESP(char)
        end
    end)

    -- Simpan connection
    connections[plr] = connections[plr] or {}
    table.insert(connections[plr], charAddedConn)
end

-- Hapus ESP dari player
function ESP:Remove(plr)
    if connections[plr] then
        for _, v in pairs(connections[plr]) do
            if typeof(v) == "Instance" then
                v:Destroy()
            elseif typeof(v) == "RBXScriptConnection" then
                v:Disconnect()
            end
        end
        connections[plr] = nil
    end
end

-- Aktifkan ESP
function ESP:Enable()
    if active then return end
    active = true
    for _, plr in ipairs(game.Players:GetPlayers()) do
        ESP:Add(plr)
    end

    -- Kalau ada player join setelah ESP aktif
    connections["_PlayerAdded"] = game.Players.PlayerAdded:Connect(function(plr)
        ESP:Add(plr)
    end)

    connections["_PlayerRemoving"] = game.Players.PlayerRemoving:Connect(function(plr)
        ESP:Remove(plr)
    end)
end

-- Nonaktifkan ESP
function ESP:Disable()
    active = false
    for plr, _ in pairs(connections) do
        ESP:Remove(plr)
    end
end

return ESP
