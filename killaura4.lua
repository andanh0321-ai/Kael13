local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

local ScreenGui = Instance.new("ScreenGui", LocalPlayer.PlayerGui)
local ToggleBtn = Instance.new("TextButton", ScreenGui)

ToggleBtn.Size = UDim2.new(0, 200, 0, 60)
ToggleBtn.Position = UDim2.new(0.05, 0, 0.4, 0)
ToggleBtn.Text = "FORCE KILL: OFF"
ToggleBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
ToggleBtn.TextColor3 = Color3.new(1, 1, 1)
ToggleBtn.Font = Enum.Font.SourceSansBold
ToggleBtn.TextSize = 20

local active = false
local range = 1000

ToggleBtn.MouseButton1Click:Connect(function()
	active = not active
	ToggleBtn.Text = active and "FORCE KILL: ON" or "FORCE KILL: OFF"
	ToggleBtn.BackgroundColor3 = active and Color3.fromRGB(200, 0, 0) or Color3.fromRGB(30, 30, 30)
end)

local function FastKill(model)
	local hum = model:FindFirstChildOfClass("Humanoid")
	if hum then
		hum.Health = 0
		hum.MaxHealth = 0
		hum:ChangeState(Enum.HumanoidStateType.Dead)
	end
	
	for _, v in pairs(model:GetDescendants()) do
		if v:IsA("BasePart") then
			v:BreakJoints()
			v.CFrame = CFrame.new(0, -999, 0)
			v.Velocity = Vector3.new(0, -1000, 0)
			v.Transparency = 1
			v.CanCollide = false
		end
	end
end

RunService.Heartbeat:Connect(function()
	if not active or not LocalPlayer.Character or not LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then return end
	
	local myRoot = LocalPlayer.Character.HumanoidRootPart
	
	for _, v in pairs(workspace:GetDescendants()) do
		if v:IsA("Humanoid") and v.Parent:IsA("Model") then
			local model = v.Parent
			if not Players:GetPlayerFromCharacter(model) then
				local targetRoot = model:FindFirstChild("HumanoidRootPart") or model:FindFirstChild("Torso") or model:FindFirstChild("Head")
				if targetRoot and targetRoot:IsA("BasePart") then
					local dist = (myRoot.Position - targetRoot.Position).Magnitude
					if dist <= range then
						FastKill(model)
					end
				end
			end
		end
	end
end)