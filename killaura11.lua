local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local StarterGui = game:GetService("StarterGui")
local Workspace = game:GetService("Workspace")
local LocalPlayer = Players.LocalPlayer

local ScreenGui = Instance.new("ScreenGui")
local Frame = Instance.new("Frame")
local ToggleButton = Instance.new("TextButton")
local Corner = Instance.new("UICorner")
local Title = Instance.new("TextLabel")

ScreenGui.Name = "KillAuraGUI"
ScreenGui.Parent = game.CoreGui

Frame.Parent = ScreenGui
Frame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
Frame.Position = UDim2.new(0.05, 0, 0.5, 0)
Frame.Size = UDim2.new(0, 150, 0, 80)
Frame.Active = true
Frame.Draggable = true

Corner.Parent = Frame

Title.Parent = Frame
Title.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Title.BackgroundTransparency = 1
Title.Position = UDim2.new(0, 0, 0, 0)
Title.Size = UDim2.new(1, 0, 0, 30)
Title.Font = Enum.Font.SourceSansBold
Title.Text = "Kill Aura"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 18

ToggleButton.Parent = Frame
ToggleButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
ToggleButton.Position = UDim2.new(0.1, 0, 0.5, 0)
ToggleButton.Size = UDim2.new(0.8, 0, 0, 30)
ToggleButton.Font = Enum.Font.SourceSansBold
ToggleButton.Text = "OFF"
ToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleButton.TextSize = 18

local UICornerBtn = Instance.new("UICorner")
UICornerBtn.Parent = ToggleButton

local isRunning = false
local range = 100

ToggleButton.MouseButton1Click:Connect(function()
    isRunning = not isRunning
    if isRunning then
        ToggleButton.Text = "ON"
        ToggleButton.BackgroundColor3 = Color3.fromRGB(50, 200, 50)
    else
        ToggleButton.Text = "OFF"
        ToggleButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
    end
end)

local function IsPlayer(model)
    return Players:GetPlayerFromCharacter(model) ~= nil
end

local function KillTarget(humanoid, rootPart)
    if humanoid and humanoid.Health > 0 then
        humanoid.Health = 0
        humanoid:ChangeState(Enum.HumanoidStateType.Dead)
        if rootPart then
            rootPart.Velocity = Vector3.new(0, 0, 0)
            rootPart.Anchored = true
            for _, part in pairs(rootPart.Parent:GetChildren()) do
                if part:IsA("BasePart") then
                    part.CanCollide = false
                end
            end
        end
    end
end

RunService.Heartbeat:Connect(function()
    if not isRunning then return end
    
    local myCharacter = LocalPlayer.Character
    local myRoot = myCharacter and myCharacter:FindFirstChild("HumanoidRootPart")
    
    if not myRoot then return end

    for _, obj in pairs(Workspace:GetDescendants()) do
        if obj:IsA("Humanoid") and obj.Parent ~= myCharacter then
            local targetChar = obj.Parent
            local targetRoot = targetChar:FindFirstChild("HumanoidRootPart") or targetChar:FindFirstChild("Torso")
            
            if targetRoot and not IsPlayer(targetChar) then
                local distance = (myRoot.Position - targetRoot.Position).Magnitude
                if distance <= range then
                    KillTarget(obj, targetRoot)
                    if targetChar:FindFirstChild("Head") then
                        targetChar.Head:Destroy()
                    end
                end
            end
        end
    end
end)
