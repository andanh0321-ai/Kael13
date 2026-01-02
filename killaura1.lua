local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

local ScreenGui = Instance.new("ScreenGui", LocalPlayer.PlayerGui)
local ToggleBtn = Instance.new("TextButton", ScreenGui)

ToggleBtn.Size = UDim2.new(0, 200, 0, 60)
ToggleBtn.Position = UDim2.new(0.05, 0, 0.4, 0)
ToggleBtn.Text = "GLOBAL KILL: OFF"
ToggleBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
ToggleBtn.TextColor3 = Color3.new(1, 1, 1)
ToggleBtn.Font = Enum.Font.SourceSansBold
ToggleBtn.TextSize = 20

local active = false
local range = 20000

ToggleBtn.MouseButton1Click:Connect(function()
	active = not active
	ToggleBtn.Text = active and "GLOBAL KILL: ON" or "GLOBAL KILL: OFF"
	ToggleBtn.BackgroundColor3 = active and Color3.fromRGB(255, 0, 0) or Color3.fromRGB(30, 30, 30)
end)

RunService.Heartbeat:Connect(function()
	if not active or not LocalPlayer.Character or not LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then return end
	
	local myPos = LocalPlayer.Character.HumanoidRootPart.Position
	
	for _, obj in pairs(workspace:GetDescendants()) do
		if obj:IsA("Humanoid") then
			local model = obj.Parent
			if model and model:IsA("Model") and model ~= LocalPlayer.Character then
				if not Players:GetPlayerFromCharacter(model) then
					local root = model:FindFirstChild("HumanoidRootPart") or model:FindFirstChild("Torso") or model:FindFirstChild("Head")
					
					if root and root:IsA("BasePart") then
						local dist = (myPos - root.Position).Magnitude
						if dist <= range then
							obj.Health = -1e9
							obj:ChangeState(Enum.HumanoidStateType.Dead)
							
							if not model:FindFirstChild("AlreadyKilled") then
								local tag = Instance.new("BoolValue", model)
								tag.Name = "AlreadyKilled"
								
								model:BreakJoints()
								
								for _, v in pairs(model:GetDescendants()) do
									if v:IsA("BasePart") then
										v.CFrame = CFrame.new(0, -500, 0)
										v.CanCollide = false
										v.CanTouch = false
										v.Transparency = 1
										v.Velocity = Vector3.new(0, -1000, 0)
									elseif v:IsA("Script") or v:IsA("LocalScript") then
										v.Disabled = true
									end
								end
							end
						end
					end
				end
			end
		end
	end
end)