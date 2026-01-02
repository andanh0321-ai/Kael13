local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")

local LocalPlayer = Players.LocalPlayer
local KillAuraEnabled = false

-- GUI SETUP
local ScreenGui = Instance.new("ScreenGui")
local Frame = Instance.new("Frame")
local ToggleButton = Instance.new("TextButton")
local UICorner = Instance.new("UICorner")
local UIStroke = Instance.new("UIStroke")

ScreenGui.Name = "UniversalKillAura"
ScreenGui.Parent = game.CoreGui

Frame.Parent = ScreenGui
Frame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Frame.Position = UDim2.new(0.02, 0, 0.4, 0)
Frame.Size = UDim2.new(0, 160, 0, 80)
Frame.Active = true
Frame.Draggable = true

local FrameCorner = Instance.new("UICorner")
FrameCorner.CornerRadius = UDim.new(0, 12)
FrameCorner.Parent = Frame

ToggleButton.Parent = Frame
ToggleButton.BackgroundColor3 = Color3.fromRGB(255, 40, 40)
ToggleButton.Position = UDim2.new(0.1, 0, 0.25, 0)
ToggleButton.Size = UDim2.new(0.8, 0, 0.5, 0)
ToggleButton.Font = Enum.Font.GothamBold
ToggleButton.Text = "OFF"
ToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleButton.TextSize = 22

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
		ToggleButton.BackgroundColor3 = Color3.fromRGB(40, 255, 40)
	else
		ToggleButton.Text = "OFF"
		ToggleButton.BackgroundColor3 = Color3.fromRGB(255, 40, 40)
	end
end)

task.spawn(function()
	while true do
		if KillAuraEnabled then
			local Character = LocalPlayer.Character
			if Character and Character:FindFirstChild("HumanoidRootPart") then
				local MyRoot = Character.HumanoidRootPart
				
				for _, Obj in pairs(Workspace:GetDescendants()) do
					if Obj:IsA("Humanoid") and Obj.Health > 0 then
						local MobChar = Obj.Parent
						local MobRoot = MobChar:FindFirstChild("HumanoidRootPart")
						
						if MobRoot and MobChar ~= Character then
							
							if not Players:GetPlayerFromCharacter(MobChar) then
						
								MobRoot.CFrame = MyRoot.CFrame * CFrame.new(0, -2, -3)
                                MobRoot.Velocity = Vector3.new(0,0,0)
								Obj.Health = 0
                                Obj.MaxHealth = 0                         
                                local Tool = MobChar:FindFirstChildOfClass("Tool")
                                if Tool then Tool:Destroy() end

                                task.spawn(function()
                                    MobRoot.CanCollide = false
                                    MobRoot.Anchored = true
                                    task.wait(0.1) 
                                    if MobRoot then
                                        MobRoot.CFrame = CFrame.new(0, -5000, 0) 
                                    end
                                    if MobChar then
                                        MobChar:BreakJoints() 
                                    end
                                end)
							end
						end
					end
				end
			end
		end
		task.wait(0.15) 
	end
end)
