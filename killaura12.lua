local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local StarterGui = game:GetService("StarterGui")
local LocalPlayer = Players.LocalPlayer

local ScreenGui = Instance.new("ScreenGui")
local Frame = Instance.new("Frame")
local ToggleButton = Instance.new("TextButton")
local UICorner = Instance.new("UICorner")

ScreenGui.Name = "KillAuraGui"
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
ScreenGui.ResetOnSpawn = false

Frame.Parent = ScreenGui
Frame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
Frame.Position = UDim2.new(0.02, 0, 0.4, 0)
Frame.Size = UDim2.new(0, 150, 0, 60)
Frame.Active = true
Frame.Draggable = true

ToggleButton.Parent = Frame
ToggleButton.BackgroundColor3 = Color3.fromRGB(255, 60, 60)
ToggleButton.Size = UDim2.new(0.9, 0, 0.8, 0)
ToggleButton.Position = UDim2.new(0.05, 0, 0.1, 0)
ToggleButton.Font = Enum.Font.GothamBold
ToggleButton.Text = "OFF"
ToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleButton.TextSize = 24

UICorner.CornerRadius = UDim.new(0, 8)
UICorner.Parent = ToggleButton

local isEnabled = false
local range = 300 

ToggleButton.MouseButton1Click:Connect(function()
	isEnabled = not isEnabled
	if isEnabled then
		ToggleButton.Text = "ON"
		ToggleButton.BackgroundColor3 = Color3.fromRGB(60, 255, 60)
	else
		ToggleButton.Text = "OFF"
		ToggleButton.BackgroundColor3 = Color3.fromRGB(255, 60, 60)
	end
end)

RunService.Heartbeat:Connect(function()
	if not isEnabled then return end
	if not LocalPlayer.Character then return end
	local myRoot = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
	if not myRoot then return end

	for _, obj in pairs(workspace:GetChildren()) do
		if obj:IsA("Model") and obj ~= LocalPlayer.Character then
			local hum = obj:FindFirstChild("Humanoid")
			local root = obj:FindFirstChild("HumanoidRootPart")
			
			if hum and root and hum.Health > 0 then
				if not Players:GetPlayerFromCharacter(obj) then
					local dist = (myRoot.Position - root.Position).Magnitude
					if dist <= range then
						hum.MaxHealth = 0
						hum.Health = -math.huge
						obj:BreakJoints()
						
						if root then
							root.Velocity = Vector3.new(0, 0, 0)
							root.RotVelocity = Vector3.new(0, 0, 0)
						end
					end
				end
			end
		end
	end
end)
