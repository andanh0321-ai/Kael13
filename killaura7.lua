local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local CoreGui = game:GetService("CoreGui")

local ScreenGui = Instance.new("ScreenGui")
local Frame = Instance.new("Frame")
local ToggleButton = Instance.new("TextButton")
local UICorner = Instance.new("UICorner")
local RangeLabel = Instance.new("TextLabel")

ScreenGui.Name = "WideAuraGUI"
if gethui then
	ScreenGui.Parent = gethui()
elseif game:GetService("RunService"):IsStudio() then
	ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
else
	ScreenGui.Parent = CoreGui
end

Frame.Parent = ScreenGui
Frame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Frame.Position = UDim2.new(0.05, 0, 0.2, 0)
Frame.Size = UDim2.new(0, 160, 0, 100)
Frame.Active = true
Frame.Draggable = true
Frame.BorderSizePixel = 0

ToggleButton.Parent = Frame
ToggleButton.BackgroundColor3 = Color3.fromRGB(200, 40, 40)
ToggleButton.Position = UDim2.new(0.1, 0, 0.45, 0)
ToggleButton.Size = UDim2.new(0.8, 0, 0.45, 0)
ToggleButton.Font = Enum.Font.GothamBlack
ToggleButton.Text = "OFF"
ToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleButton.TextSize = 24

UICorner.Parent = ToggleButton
local Corner2 = UICorner:Clone()
Corner2.Parent = Frame

RangeLabel.Parent = Frame
RangeLabel.BackgroundTransparency = 1
RangeLabel.Position = UDim2.new(0, 0, 0.05, 0)
RangeLabel.Size = UDim2.new(1, 0, 0.35, 0)
RangeLabel.Font = Enum.Font.GothamBold
RangeLabel.Text = "RANGE: 100"
RangeLabel.TextColor3 = Color3.fromRGB(255, 255, 0)
RangeLabel.TextSize = 18

local isActive = false
local range = 100 

ToggleButton.MouseButton1Click:Connect(function()
	isActive = not isActive
	if isActive then
		ToggleButton.Text = "ON"
		ToggleButton.BackgroundColor3 = Color3.fromRGB(40, 200, 40)
		
		sethiddenproperty(LocalPlayer, "SimulationRadius", 1000)
	else
		ToggleButton.Text = "OFF"
		ToggleButton.BackgroundColor3 = Color3.fromRGB(200, 40, 40)
	end
end)

RunService.RenderStepped:Connect(function()
	if not isActive then return end
	
	local character = LocalPlayer.Character
	if not character then return end
	local rootPart = character:FindFirstChild("HumanoidRootPart")
	if not rootPart then return end

	for _, v in pairs(workspace:GetDescendants()) do
		if v:IsA("Model") and v:FindFirstChild("Humanoid") and v:FindFirstChild("HumanoidRootPart") then
			if v ~= character then
				if not Players:GetPlayerFromCharacter(v) then
					local targetHum = v.Humanoid
					local targetRoot = v.HumanoidRootPart
					
					if targetHum.Health > 0 then
						local distance = (rootPart.Position - targetRoot.Position).Magnitude
						if distance <= range then
							targetHum.Health = 0
							targetHum:ChangeState(Enum.HumanoidStateType.Dead)
							v:BreakJoints()
                            
                            if targetRoot then
                                targetRoot.Velocity = Vector3.new(0, -1000, 0)
                                targetRoot.CanCollide = false
                            end
						end
					end
				end
			end
		end
	end
end)
