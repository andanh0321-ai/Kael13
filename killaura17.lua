local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")

local LocalPlayer = Players.LocalPlayer
local KillAuraEnabled = false

local ScreenGui = Instance.new("ScreenGui")
local Frame = Instance.new("Frame")
local ToggleButton = Instance.new("TextButton")
local UICorner = Instance.new("UICorner")
local UIStroke = Instance.new("UIStroke")

ScreenGui.Name = "OptimizedKillAura"
ScreenGui.Parent = game.CoreGui

Frame.Parent = ScreenGui
Frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
Frame.Position = UDim2.new(0.02, 0, 0.4, 0)
Frame.Size = UDim2.new(0, 140, 0, 70)
Frame.Active = true
Frame.Draggable = true

local FrameCorner = Instance.new("UICorner")
FrameCorner.CornerRadius = UDim.new(0, 10)
FrameCorner.Parent = Frame

ToggleButton.Parent = Frame
ToggleButton.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
ToggleButton.Position = UDim2.new(0.1, 0, 0.2, 0)
ToggleButton.Size = UDim2.new(0.8, 0, 0.6, 0)
ToggleButton.Font = Enum.Font.GothamBlack
ToggleButton.Text = "OFF"
ToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleButton.TextSize = 24

UICorner.CornerRadius = UDim.new(0, 8)
UICorner.Parent = ToggleButton

UIStroke.Parent = ToggleButton
UIStroke.Thickness = 2.5
UIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
UIStroke.Color = Color3.fromRGB(255, 255, 255)

ToggleButton.MouseButton1Click:Connect(function()
	KillAuraEnabled = not KillAuraEnabled
	if KillAuraEnabled then
		ToggleButton.Text = "ON"
		ToggleButton.BackgroundColor3 = Color3.fromRGB(50, 255, 50)
	else
		ToggleButton.Text = "OFF"
		ToggleButton.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
	end
end)

task.spawn(function()
	while true do
		if not KillAuraEnabled then
			task.wait(0.2)
		else
			local Character = LocalPlayer.Character
			if Character and Character:FindFirstChild("HumanoidRootPart") then
				local MyRoot = Character.HumanoidRootPart
				
				for _, Model in ipairs(Workspace:GetChildren()) do
					if Model:IsA("Model") and Model ~= Character then
						local Humanoid = Model:FindFirstChild("Humanoid")
						local RootPart = Model:FindFirstChild("HumanoidRootPart")
						
						if Humanoid and RootPart and Humanoid.Health > 0 then
							if not Players:GetPlayerFromCharacter(Model) then
								
								RootPart.CFrame = MyRoot.CFrame * CFrame.new(0, 0, -5)
								RootPart.Velocity = Vector3.new(0, 0, 0)
								RootPart.RotVelocity = Vector3.new(0, 0, 0)
								RootPart.CanCollide = false
								
								Humanoid.Health = 0
								Humanoid.MaxHealth = 0
								
								local Tool = Model:FindFirstChildOfClass("Tool")
								if Tool then Tool:Destroy() end
								
								task.spawn(function()
									task.wait() 
									if RootPart then
										RootPart.CFrame = CFrame.new(0, -9000, 0)
										RootPart:Destroy()
									end
									if Model then
										for _, Part in ipairs(Model:GetChildren()) do
											if Part:IsA("BasePart") then
												Part.CanCollide = false
												Part.Anchored = true
											end
										end
									end
								end)
							end
						end
					end
				end
			end
			task.wait(0.05) 
		end
	end
end)
