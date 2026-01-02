local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

local ScreenGui = Instance.new("ScreenGui", LocalPlayer.PlayerGui)
local ToggleBtn = Instance.new("TextButton", ScreenGui)

ToggleBtn.Size = UDim2.new(0, 180, 0, 50)
ToggleBtn.Position = UDim2.new(0.05, 0, 0.4, 0)
ToggleBtn.Text = "TOTAL ERASE: OFF"
ToggleBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
ToggleBtn.TextColor3 = Color3.new(1, 1, 1)
ToggleBtn.Font = Enum.Font.SourceSansBold
ToggleBtn.TextSize = 18

local active = false
local range = 500

ToggleBtn.MouseButton1Click:Connect(function()
	active = not active
	ToggleBtn.Text = active and "TOTAL ERASE: ON" or "TOTAL ERASE: OFF"
	ToggleBtn.BackgroundColor3 = active and Color3.fromRGB(255, 85, 0) or Color3.fromRGB(20, 20, 20)
end)

local function Erase(model)
	local hum = model:FindFirstChildOfClass("Humanoid")
	if hum then
		hum.Health = 0
		hum:ChangeState(Enum.HumanoidStateType.Dead)
	end
	
	for _, part in pairs(model:GetDescendants()) do
		if part:IsA("BasePart") then
			part.CanCollide = false
			part.Anchored = false
			part.Velocity = Vector3.new(0, -99999, 0)
			part.CFrame = CFrame.new(0, -500, 0)
		end
	end
end

RunService.Heartbeat:Connect(function()
	if not active or not LocalPlayer.Character or not LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then return end
	
	local myRoot = LocalPlayer.Character.HumanoidRootPart
	
	for _, obj in pairs(workspace:GetDescendants()) do
		if obj:IsA("Humanoid") and obj.Health > 0 then
			local model = obj.Parent
			if model:IsA("Model") and not Players:GetPlayerFromCharacter(model) then
				local root = model:FindFirstChild("HumanoidRootPart") or model:FindFirstChild("Torso") or model:FindFirstChild("Head")
				
				if root and root:IsA("BasePart") then
					if (myRoot.Position - root.Position).Magnitude <= range then
						spawn(function()
							Erase(model)
						end)
					end
				end
			end
		end
	end
end)