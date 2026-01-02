local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local LocalPlayer = Players.LocalPlayer

local ScreenGui = Instance.new("ScreenGui")
local ToggleButton = Instance.new("TextButton")
local UICorner = Instance.new("UICorner")

ScreenGui.Name = "KillAuraGUI"
if gethui then
    ScreenGui.Parent = gethui()
else
    ScreenGui.Parent = CoreGui
end

ToggleButton.Name = "Toggle"
ToggleButton.Parent = ScreenGui
ToggleButton.BackgroundColor3 = Color3.fromRGB(255, 60, 60)
ToggleButton.Position = UDim2.new(0.02, 0, 0.5, 0)
ToggleButton.Size = UDim2.new(0, 150, 0, 50)
ToggleButton.Font = Enum.Font.GothamBold
ToggleButton.Text = "Kill Aura: OFF"
ToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleButton.TextSize = 20

UICorner.CornerRadius = UDim.new(0, 10)
UICorner.Parent = ToggleButton

local isEnabled = false
local range = 100

ToggleButton.MouseButton1Click:Connect(function()
    isEnabled = not isEnabled
    if isEnabled then
        ToggleButton.Text = "Kill Aura: ON"
        ToggleButton.BackgroundColor3 = Color3.fromRGB(60, 255, 60)
    else
        ToggleButton.Text = "Kill Aura: OFF"
        ToggleButton.BackgroundColor3 = Color3.fromRGB(255, 60, 60)
    end
end)

local function killTarget(humanoid, rootPart)
    if humanoid.Health > 0 then
        humanoid.Health = -999999
        humanoid.MaxHealth = -999999
        humanoid:ChangeState(Enum.HumanoidStateType.Dead)
        
        if rootPart then
            rootPart.Velocity = Vector3.new(0, 0, 0)
            rootPart.RotVelocity = Vector3.new(0, 0, 0)
            
            for _, part in pairs(humanoid.Parent:GetChildren()) do
                if part:IsA("BasePart") then
                    part.CanCollide = false
                    part.Anchored = true
                end
            end
        end
    end
end

RunService.Heartbeat:Connect(function()
    if not isEnabled or not LocalPlayer.Character then return end
    
    local myRoot = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not myRoot then return end

    for _, model in pairs(workspace:GetDescendants()) do
        if model:IsA("Model") and model:FindFirstChild("Humanoid") and model:FindFirstChild("HumanoidRootPart") then
            local humanoid = model.Humanoid
            local rootPart = model.HumanoidRootPart
            
            if model ~= LocalPlayer.Character and humanoid.Health > 0 then
                if not Players:GetPlayerFromCharacter(model) then
                    local distance = (myRoot.Position - rootPart.Position).Magnitude
                    if distance <= range then
                        sethiddenproperty(humanoid, "MaxHealth", -math.huge)
                        sethiddenproperty(humanoid, "Health", -math.huge)
                        killTarget(humanoid, rootPart)
                    end
                end
            end
        end
    end
end)
