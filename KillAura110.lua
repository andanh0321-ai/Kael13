local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

local ScreenGui = Instance.new("ScreenGui", LocalPlayer.PlayerGui)
local ToggleBtn = Instance.new("TextButton", ScreenGui)

ToggleBtn.Size = UDim2.new(0, 180, 0, 50)
ToggleBtn.Position = UDim2.new(0.05, 0, 0.4, 0)
ToggleBtn.Text = "ULTIMATE KILL: OFF"
ToggleBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
ToggleBtn.TextColor3 = Color3.new(1, 1, 1)
ToggleBtn.Font = Enum.Font.SourceSansBold
ToggleBtn.TextSize = 18

local active = false
local range = 10000 

ToggleBtn.MouseButton1Click:Connect(function()
	active = not active
	ToggleBtn.Text = active and "ULTIMATE KILL: ON" or "ULTIMATE KILL: OFF"
	ToggleBtn.BackgroundColor3 = active and Color3.fromRGB(255, 0, 0) or Color3.fromRGB(30, 30, 30)
end)

RunService.Heartbeat:Connect(function()
	if not active or not LocalPlayer.Character or not LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then return end
	
	local myPos = LocalPlayer.Character.HumanoidRootPart.Position
	
	for _, obj in pairs(workspace:GetDescendants()) do
		if obj:IsA("Humanoid") then
			local model = obj.Parent
			if model:IsA("Model") and model ~= LocalPlayer.Character then
				if not Players:GetPlayerFromCharacter(model) then
					local root = model:FindFirstChild("HumanoidRootPart") or model:FindFirstChild("Torso") or model:FindFirstChild("Head")
					
					if root and root:IsA("BasePart") then
						local dist = (myPos - root.Position).Magnitude
						if dist <= range then
							obj.Health = -100
							obj:ChangeState(Enum.HumanoidStateType.Dead)
							
							for _, v in pairs(model:GetDescendants()) do
								if v:IsA("BasePart") then
									v.CFrame = CFrame.new(0, -1000, 0)
									v.CanCollide = false
									v.CanTouch = false
									v.Transparency = 1
									v:BreakJoints()
								elseif v:IsA("Script") or v:IsA("LocalScript") or v:IsA("ModuleScript") then
									v:Destroy()
								elseif v:IsA("RemoteEvent") or v:IsA("BindableEvent") then
									v:Destroy()
								end
							end
							
							if not model:FindFirstChild("DeadTag") then
								local tag = Instance.new("BoolValue", model)
								tag.Name = "DeadTag"
								model:BreakJoints()
							end
						end
					end
				end
			end
		end
	end
end)