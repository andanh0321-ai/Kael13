local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local StarterGui = game:GetService("StarterGui")
local Workspace = game:GetService("Workspace")

local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera

local KillAuraEnabled = false
local Range = 500

local ScreenGui = Instance.new("ScreenGui")
local Frame = Instance.new("Frame")
local ToggleButton = Instance.new("TextButton")
local UICorner = Instance.new("UICorner")
local UIStroke = Instance.new("UIStroke")

ScreenGui.Name = "KillAuraUI"
ScreenGui.Parent = game.CoreGui

Frame.Parent = ScreenGui
Frame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
Frame.Position = UDim2.new(0.02, 0, 0.4, 0)
Frame.Size = UDim2.new(0, 150, 0, 80)
Frame.Active = true
Frame.Draggable = true

local FrameCorner = Instance.new("UICorner")
FrameCorner.CornerRadius = UDim.new(0, 10)
FrameCorner.Parent = Frame

ToggleButton.Parent = Frame
ToggleButton.BackgroundColor3 = Color3.fromRGB(255, 60, 60)
ToggleButton.Position = UDim2.new(0.1, 0, 0.25, 0)
ToggleButton.Size = UDim2.new(0.8, 0, 0.5, 0)
ToggleButton.Font = Enum.Font.GothamBold
ToggleButton.Text = "OFF"
ToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleButton.TextSize = 20

UICorner.CornerRadius = UDim.new(0, 8)
UICorner.Parent = ToggleButton

UIStroke.Parent = ToggleButton
UIStroke.Thickness = 2
UIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
UIStroke.Color = Color3.fromRGB(255, 255, 255)

ToggleButton.MouseButton1Click:Connect(function()
	KillAuraEnabled = not KillAuraEnabled
	if KillAuraEnabled then
		ToggleButton.Text = "ON"
		ToggleButton.BackgroundColor3 = Color3.fromRGB(60, 255, 60)
	else
		ToggleButton.Text = "OFF"
		ToggleButton.BackgroundColor3 = Color3.fromRGB(255, 60, 60)
	end
end)

local function GetTarget()
	local Character = LocalPlayer.Character
	if not Character or not Character:FindFirstChild("HumanoidRootPart") then return end

	for _, Obj in pairs(Workspace:GetDescendants()) do
		if Obj:IsA("Humanoid") and Obj.Health > 0 then
			local MobChar = Obj.Parent
			local MobRoot = MobChar:FindFirstChild("HumanoidRootPart")
			
			if MobRoot and MobChar ~= Character then
				if not Players:GetPlayerFromCharacter(MobChar) then
					local Distance = (Character.HumanoidRootPart.Position - MobRoot.Position).Magnitude
					if Distance <= Range then
						return Obj, MobChar, MobRoot
					end
				end
			end
		end
	end
end

RunService.RenderStepped:Connect(function()
	if not KillAuraEnabled then return end
    
	local Character = LocalPlayer.Character
	if not Character then return end

	for _, Obj in pairs(Workspace:GetDescendants()) do
		if Obj:IsA("Humanoid") and Obj.Health > 0 then
			local MobChar = Obj.Parent
			local MobRoot = MobChar:FindFirstChild("HumanoidRootPart")

			if MobRoot and MobChar ~= Character then
				if not Players:GetPlayerFromCharacter(MobChar) then
					local Distance = (Character.HumanoidRootPart.Position - MobRoot.Position).Magnitude
					
					if Distance <= Range then
						Obj.Health = -math.huge
						Obj.MaxHealth = -math.huge
						
                        if MobRoot then
                            MobRoot.Velocity = Vector3.new(0,0,0)
                            MobRoot.RotVelocity = Vector3.new(0,0,0)
                            MobRoot.Anchored = false
                            MobRoot.CanCollide = false
                        end

						Obj:ChangeState(Enum.HumanoidStateType.Dead)
						
						for _, Part in pairs(MobChar:GetChildren()) do
							if Part:IsA("BasePart") then
								Part.CanCollide = false
                                Part.Velocity = Vector3.new(0,0,0)
							end
						end
                        
                        spawn(function()
                            task.wait(0.1)
                            if MobChar and MobChar:FindFirstChild("HumanoidRootPart") then
                                MobChar:BreakJoints()
                            end
                        end)
					end
				end
			end
		end
	end
end)
