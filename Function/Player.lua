-- FLY LOGIC
local flying = false
local flyVel

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
		if UserInputService:IsKeyDown(Enum.KeyCode.W) then dir = dir + hrp.CFrame.LookVector end
		if UserInputService:IsKeyDown(Enum.KeyCode.S) then dir = dir - hrp.CFrame.LookVector end
		if UserInputService:IsKeyDown(Enum.KeyCode.A) then dir = dir - hrp.CFrame.RightVector end
		if UserInputService:IsKeyDown(Enum.KeyCode.D) then dir = dir + hrp.CFrame.RightVector end
		if UserInputService:IsKeyDown(Enum.KeyCode.Space) then dir = dir + Vector3.new(0,1,0) end
		if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then dir = dir - Vector3.new(0,1,0) end
		local speed = Options.FlySlider.Value
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
