local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")

-- UI nút
local gui = Instance.new("ScreenGui", CoreGui)
gui.Name = "ESP_LockBase_Tele"
gui.ResetOnSpawn = false

local btn = Instance.new("TextButton", gui)
btn.Size = UDim2.new(0, 90, 0, 40)
btn.Position = UDim2.new(0.5, 55, 0, 10)  -- Gần nút Fall (giữa đỉnh màn hình)
btn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
btn.TextColor3 = Color3.fromRGB(255, 255, 255)
btn.Text = "⚡ LOCK TELE"
btn.Font = Enum.Font.GothamBold
btn.TextSize = 14
btn.Draggable = true
btn.Active = true
Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)

-- Logic teleport liên tục
local teleporting = false
btn.MouseButton1Click:Connect(function()
	if teleporting then return end
	local esp = workspace:FindFirstChild("ESP_LockBase")
	local hrp = Players.LocalPlayer.Character and Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")

	if esp and hrp then
		teleporting = true
		btn.Text = "⏳ LOCKING"
		while teleporting and hrp and esp and esp.Parent do
			hrp.CFrame = esp.CFrame + Vector3.new(0, 5, 0)
			task.wait(0.2)
			-- Update HRP nếu nhân vật respawn
			local newHRP = Players.LocalPlayer.Character and Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
			if newHRP and newHRP ~= hrp then
				hrp = newHRP
			end
		end
		btn.Text = "⚡ LOCK TELE"
	end
end)
