-- ESP Library
local ESP = {}
local active = false
local connections = {}
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- Tambah ESP ke player
function ESP:Add(plr)
    if plr == LocalPlayer then return end

    local function applyESP(char)
        local head = char:WaitForChild("Head", 5)
        if not head then return end

        -- Billboard GUI
        local gui = Instance.new("BillboardGui")
        gui.AlwaysOnTop = true
        gui.Size = UDim2.new(0, 150, 0, 30)
        gui.StudsOffset = Vector3.new(0, 2.5, 0)
        gui.Name = "ESP_Billboard"
        gui.Parent = head

        local txt = Instance.new("TextLabel")
        txt.Size = UDim2.new(1, 0, 1, 0)
        txt.BackgroundTransparency = 1
        txt.TextColor3 = Color3.fromRGB(255, 50, 50)
        txt.TextScaled = true
        txt.TextStrokeTransparency = 0
        txt.Font = Enum.Font.GothamBold
        txt.Parent = gui

        -- Highlight
        local hl = Instance.new("Highlight")
        hl.FillTransparency = 0.5
        hl.OutlineColor = Color3.fromRGB(255, 50, 50)
        hl.Name = "ESP_Highlight"
        hl.Parent = char

        -- Update teks dengan jarak
        task.spawn(function()
            while gui.Parent and active do
                task.wait(0.2)
                local myChar = LocalPlayer.Character
                if myChar and myChar:FindFirstChild("HumanoidRootPart") and char:FindFirstChild("HumanoidRootPart") then
                    local dist = (myChar.HumanoidRootPart.Position - char.HumanoidRootPart.Position).Magnitude
                    txt.Text = string.format("%s\n[%.0f studs]", plr.DisplayName, dist)
                else
                    txt.Text = plr.DisplayName
                end
            end
            if gui and gui.Parent then
                gui:Destroy()
            end
        end)

        -- Simpan referensi
        connections[plr] = connections[plr] or {}
        table.insert(connections[plr], gui)
        table.insert(connections[plr], hl)
    end

    -- Kalau sudah ada character
    if plr.Character then
        applyESP(plr.Character)
    end

    -- Listener kalau respawn
    local charAddedConn = plr.CharacterAdded:Connect(function(char)
        if active then
            task.wait(1)
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

    for _, plr in ipairs(Players:GetPlayers()) do
        ESP:Add(plr)
    end

    -- Player join/leave handler
    connections["_PlayerAdded"] = Players.PlayerAdded:Connect(function(plr)
        ESP:Add(plr)
    end)

    connections["_PlayerRemoving"] = Players.PlayerRemoving:Connect(function(plr)
        ESP:Remove(plr)
    end)
end

-- Nonaktifkan ESP
function ESP:Disable()
    active = false
    -- Hapus ESP dari setiap player
    for plr, objs in pairs(connections) do
        if typeof(plr) == "Instance" and plr:IsA("Player") then
            ESP:Remove(plr)
        end
    end

    -- Putuskan event global
    if connections["_PlayerAdded"] then
        connections["_PlayerAdded"]:Disconnect()
        connections["_PlayerAdded"] = nil
    end
    if connections["_PlayerRemoving"] then
        connections["_PlayerRemoving"]:Disconnect()
        connections["_PlayerRemoving"] = nil
    end
end

return ESP
