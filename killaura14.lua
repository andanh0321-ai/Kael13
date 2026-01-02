local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local LocalPlayer = Players.LocalPlayer

local ScreenGui = Instance.new("ScreenGui")
local ToggleButton = Instance.new("TextButton")
local UICorner = Instance.new("UICorner")

local KillAuraEnabled = false
local Range = 1000 

ScreenGui.Name = "KillAuraUI"
ScreenGui.Parent = CoreGui

ToggleButton.Name = "ToggleBtn"
ToggleButton.Parent = ScreenGui
ToggleButton.BackgroundColor3 = Color3.fromRGB(255, 60, 60)
ToggleButton.Position = UDim2.new(0.5, -75, 0.1, 0)
ToggleButton.Size = UDim2.new(0, 150, 0, 50)
ToggleButton.Font = Enum.Font.GothamBold
ToggleButton.Text = "KILL AURA: OFF"
ToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleButton.TextSize = 18

UICorner.CornerRadius = UDim.new(0, 10)
UICorner.Parent = ToggleButton

ToggleButton.MouseButton1Click:Connect(function()
    KillAuraEnabled = not KillAuraEnabled
    if KillAuraEnabled then
        ToggleButton.Text = "KILL AURA: ON"
        ToggleButton.BackgroundColor3 = Color3.fromRGB(60, 255, 60)
    else
        ToggleButton.Text = "KILL AURA: OFF"
        ToggleButton.BackgroundColor3 = Color3.fromRGB(255, 60, 60)
    end
end)

task.spawn(function()
    while task.wait() do
        if KillAuraEnabled then
            pcall(function()
                local MyCharacter = LocalPlayer.Character
                local MyRoot = MyCharacter and MyCharacter:FindFirstChild("HumanoidRootPart")

                if MyRoot then
                    for _, Obj in pairs(workspace:GetDescendants()) do
                        if Obj:IsA("Model") and Obj:FindFirstChild("Humanoid") and Obj:FindFirstChild("HumanoidRootPart") then
                            local Hum = Obj.Humanoid
                            local Root = Obj.HumanoidRootPart
                            local Player = Players:GetPlayerFromCharacter(Obj)

                            if not Player and Hum.Health > 0 then
                                local Distance = (MyRoot.Position - Root.Position).Magnitude
                                if Distance <= Range then
                                    Hum.MaxHealth = 0
                                    Hum.Health = -math.huge
                                    Hum:ChangeState(Enum.HumanoidStateType.Dead)
                                    Obj:BreakJoints()
                                    
                                    if Root then
                                        Root.Velocity = Vector3.new(0,0,0)
                                        Root.CanCollide = false
                                    end
                                end
                            end
                        end
                    end
                end
            end)
        end
    end
end)
