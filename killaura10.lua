local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")

local LocalPlayer = Players.LocalPlayer
local Range = 100 

local ScreenGui = Instance.new("ScreenGui")
local Frame = Instance.new("Frame")
local ToggleBtn = Instance.new("TextButton")
local Title = Instance.new("TextLabel")
local UICorner = Instance.new("UICorner")
local UICornerBtn = Instance.new("UICorner")

ScreenGui.Name = "KillAuraGUI"
if gethui then
    ScreenGui.Parent = gethui()
else
    ScreenGui.Parent = CoreGui
end

Frame.Parent = ScreenGui
Frame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
Frame.Position = UDim2.new(0.05, 0, 0.4, 0)
Frame.Size = UDim2.new(0, 150, 0, 100)
Frame.Active = true
Frame.Draggable = true

UICorner.Parent = Frame

Title.Parent = Frame
Title.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Title.BackgroundTransparency = 1
Title.Position = UDim2.new(0, 0, 0, 0)
Title.Size = UDim2.new(1, 0, 0, 30)
Title.Font = Enum.Font.SourceSansBold
Title.Text = "Kill Aura NPC"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 18

ToggleBtn.Parent = Frame
ToggleBtn.BackgroundColor3 = Color3.fromRGB(255, 60, 60)
ToggleBtn.Position = UDim2.new(0.1, 0, 0.4, 0)
ToggleBtn.Size = UDim2.new(0.8, 0, 0.4, 0)
ToggleBtn.Font = Enum.Font.SourceSansBold
ToggleBtn.Text = "OFF"
ToggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleBtn.TextSize = 20

UICornerBtn.Parent = ToggleBtn

local Enabled = false

ToggleBtn.MouseButton1Click:Connect(function()
    Enabled = not Enabled
    if Enabled then
        ToggleBtn.Text = "ON"
        ToggleBtn.BackgroundColor3 = Color3.fromRGB(60, 255, 60)
    else
        ToggleBtn.Text = "OFF"
        ToggleBtn.BackgroundColor3 = Color3.fromRGB(255, 60, 60)
    end
end)

RunService.RenderStepped:Connect(function()
    if not Enabled then return end
    if not LocalPlayer.Character then return end
    
    local MyRoot = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not MyRoot then return end

    for _, v in pairs(workspace:GetDescendants()) do
        if v:IsA("Model") and v:FindFirstChild("Humanoid") and v:FindFirstChild("HumanoidRootPart") then
            local Hum = v.Humanoid
            local Root = v.HumanoidRootPart
            
            if v ~= LocalPlayer.Character and not Players:GetPlayerFromCharacter(v) then
                if (MyRoot.Position - Root.Position).Magnitude <= Range then
                    if Hum.Health > 0 then
                        Hum.Health = 0
                        Hum:ChangeState(Enum.HumanoidStateType.Dead)
                        if v:FindFirstChild("Head") then
                            v.Head:Destroy()
                        end
                    end
                end
            end
        end
    end
end)
