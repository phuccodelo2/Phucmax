local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")

local gui = Instance.new("ScreenGui", CoreGui)
gui.Name = "ESP_LockBase_Tele"
gui.ResetOnSpawn = false

local btn = Instance.new("TextButton", gui)
btn.Size = UDim2.new(0, 90, 0, 40)
btn.Position = UDim2.new(0.5, 55, 0, 10) -- Cạnh nút Fall (giữa top màn hình)
btn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
btn.TextColor3 = Color3.fromRGB(255, 255, 255)
btn.Text = " LOCK base"
btn.Font = Enum.Font.GothamBold
btn.TextSize = 14
btn.Draggable = true
btn.Active = true
Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)

local teleporting = false

btn.MouseButton1Click:Connect(function()
	if teleporting then return end
	teleporting = true
	btn.Text = "⏳ TELE..."

	-- Reset nhân vật
	local char = Players.LocalPlayer.Character
	if char and char:FindFirstChild("Humanoid") then
		char:FindFirstChild("Humanoid"):BreakJoints()
	end

	-- Chờ hồi sinh
	local newChar = Players.LocalPlayer.CharacterAdded:Wait()
	local hrp = newChar:WaitForChild("HumanoidRootPart", 5)

	local esp = workspace:FindFirstChild("ESP_LockBase")
	if esp and hrp then
		repeat
			task.wait(0.1)
			hrp.CFrame = esp.CFrame + Vector3.new(0, 5, 0)
		until not teleporting or Players.LocalPlayer.Character:FindFirstChild("Humanoid").Health > 0
	end

	btn.Text = " LOCK base"
	teleporting = false
end)
