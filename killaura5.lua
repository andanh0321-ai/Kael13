local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local CoreGui = game:GetService("CoreGui")

local ScreenGui = Instance.new("ScreenGui")
local Frame = Instance.new("Frame")
local ToggleButton = Instance.new("TextButton")
local UICorner = Instance.new("UICorner")

ScreenGui.Name = "AuraGUI"
if gethui then
	ScreenGui.Parent = gethui()
elseif game:GetService("RunService"):IsStudio() then
	ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
else
	ScreenGui.Parent = CoreGui
end

Frame.Parent = ScreenGui
Frame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
Frame.Position = UDim2.new(0.05, 0, 0.2, 0)
Frame.Size = UDim2.new(0, 150, 0, 80)
Frame.Active = true
Frame.Draggable = true

ToggleButton.Parent = Frame
ToggleButton.BackgroundColor3 = Color3.fromRGB(255, 60, 60)
ToggleButton.Position = UDim2.new(0.1, 0, 0.25, 0)
ToggleButton.Size = UDim2.new(0.8, 0, 0.5, 0)
ToggleButton.Font = Enum.Font.GothamBold
ToggleButton.Text = "OFF"
ToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleButton.TextSize = 20

UICorner.Parent = ToggleButton

local isActive = false
local range = 25

ToggleButton.MouseButton1Click:Connect(function()
	isActive = not isActive
	if isActive then
		ToggleButton.Text = "ON"
		ToggleButton.BackgroundColor3 = Color3.fromRGB(60, 255, 60)
	else
		ToggleButton.Text = "OFF"
		ToggleButton.BackgroundColor3 = Color3.fromRGB(255, 60, 60)
	end
end)

RunService.Heartbeat:Connect(function()
	if not isActive then return end
	
	local character = LocalPlayer.Character
	if not character then return end
	local rootPart = character:FindFirstChild("HumanoidRootPart")
	if not rootPart then return end

	for _, v in pairs(workspace:GetDescendants()) do
		if v:IsA("Model") and v:FindFirstChild("Humanoid") and v:FindFirstChild("HumanoidRootPart") then
			local targetHum = v.Humanoid
			local targetRoot = v.HumanoidRootPart
			
			if targetHum.Health > 0 and v ~= character then
				if not Players:GetPlayerFromCharacter(v) then
					local distance = (rootPart.Position - targetRoot.Position).Magnitude
					if distance <= range then
						targetHum.Health = 0
					end
				end
			end
		end
	end
end)
