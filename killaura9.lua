local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local LocalPlayer = Players.LocalPlayer

local ScreenGui = Instance.new("ScreenGui")
local ToggleBtn = Instance.new("TextButton")
local UICorner = Instance.new("UICorner")

ScreenGui.Name = "KillAuraGui"
ScreenGui.Parent = game:GetService("CoreGui")

ToggleBtn.Name = "ToggleBtn"
ToggleBtn.Parent = ScreenGui
ToggleBtn.BackgroundColor3 = Color3.fromRGB(255, 60, 60)
ToggleBtn.Position = UDim2.new(0.1, 0, 0.1, 0)
ToggleBtn.Size = UDim2.new(0, 150, 0, 50)
ToggleBtn.Font = Enum.Font.SourceSansBold
ToggleBtn.Text = "Kill Aura: OFF"
ToggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleBtn.TextSize = 20
ToggleBtn.Draggable = true

UICorner.CornerRadius = UDim.new(0, 12)
UICorner.Parent = ToggleBtn

local Enabled = false
local Range = 100

ToggleBtn.MouseButton1Click:Connect(function()
    Enabled = not Enabled
    if Enabled then
        ToggleBtn.Text = "Kill Aura: ON"
        ToggleBtn.BackgroundColor3 = Color3.fromRGB(60, 255, 60)
    else
        ToggleBtn.Text = "Kill Aura: OFF"
        ToggleBtn.BackgroundColor3 = Color3.fromRGB(255, 60, 60)
    end
end)

RunService.Heartbeat:Connect(function()
    if not Enabled then return end
    
    local Character = LocalPlayer.Character
    if not Character or not Character:FindFirstChild("HumanoidRootPart") then return end
    
    local MyRoot = Character.HumanoidRootPart

    for _, Obj in pairs(Workspace:GetChildren()) do
        if Obj:IsA("Model") and Obj:FindFirstChild("Humanoid") and Obj:FindFirstChild("HumanoidRootPart") then
            local MobHumanoid = Obj.Humanoid
            local MobRoot = Obj.HumanoidRootPart
            
            if MobHumanoid.Health > 0 then
                if not Players:GetPlayerFromCharacter(Obj) then
                    local Distance = (MyRoot.Position - MobRoot.Position).Magnitude
                    
                    if Distance <= Range then
                        MobHumanoid.Health = 0
                        MobHumanoid:ChangeState(Enum.HumanoidStateType.Dead)
                        Obj:BreakJoints()
                    end
                end
            end
        end
    end
end)
