local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

local ScreenGui = Instance.new("ScreenGui", LocalPlayer.PlayerGui)
local ToggleBtn = Instance.new("TextButton", ScreenGui)

ToggleBtn.Size = UDim2.new(0, 200, 0, 60)
ToggleBtn.Position = UDim2.new(0.05, 0, 0.4, 0)
ToggleBtn.Text = "ERASE ALL: OFF"
ToggleBtn.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
ToggleBtn.TextColor3 = Color3.new(1, 1, 1)
ToggleBtn.Font = Enum.Font.SourceSansBold
ToggleBtn.TextSize = 20

local active = false
local range = 2000 

ToggleBtn.MouseButton1Click:Connect(function()
	active = not active
	ToggleBtn.Text = active and "ERASE ALL: ON" or "ERASE ALL: OFF"
	ToggleBtn.BackgroundColor3 = active and Color3.fromRGB(150, 0, 0) or Color3.fromRGB(0, 0, 0)
end)

local function UltimateKill(model)
	local hum = model:FindFirstChildOfClass("Humanoid")
	if hum then
		hum.Health = 0
		hum:ChangeState(Enum.HumanoidStateType.Dead)
	end
	
	for _, v in pairs(model:GetDescendants()) do
		if v:IsA("BasePart") then
			v.CanCollide = false
			v.Anchored = false
			v.Transparency = 1
			v.Size = Vector3.new(0,0,0)
			v.CFrame = CFrame.new(0, -1000, 0)
			v.Velocity = Vector3.new(0, -5000, 0)
			v.RotVelocity = Vector3.new(0, -5000, 0)
		elseif v:IsA("Script") or v:IsA("LocalScript") then
			v.Disabled = true
		end
	end
	
	model:BreakJoints()
end

RunService.RenderStepped:Connect(function()
	if not active or not LocalPlayer.Character or not LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then return end
	
	local charPos = LocalPlayer.Character.HumanoidRootPart.Position
	
	for _, model in pairs(workspace:GetChildren()) do
		if model:IsA("Model") and model ~= LocalPlayer.Character then
			local hum = model:FindFirstChildOfClass("Humanoid")
			if hum and hum.Health > 0 then
				if not Players:GetPlayerFromCharacter(model) then
					local root = model:FindFirstChild("HumanoidRootPart") or model:FindFirstChild("Torso") or model:FindFirstChild("Head")
					if root and (root.Position - charPos).Magnitude <= range then
						task.spawn(function()
							UltimateKill(model)
						end)
					end
				end
			end
		end
	end
end)