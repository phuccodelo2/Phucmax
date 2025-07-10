local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local gui = CoreGui:FindFirstChild("PhucTeleportBtn") or Instance.new("ScreenGui", CoreGui)
gui.Name = "PhucTeleportBtn"
gui.ResetOnSpawn = false

-- Nút UI
local btn = Instance.new("TextButton", gui)
btn.Size = UDim2.new(0, 80, 0, 50)
btn.Position = UDim2.new(0.5, 150, 0.36, 0) -- Bên phải nút Fall Down
btn.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
btn.TextColor3 = Color3.fromRGB(0, 255, 255)
btn.Text = "▶ Tele Lock"
btn.TextScaled = true
btn.Font = Enum.Font.GothamBold
btn.BorderSizePixel = 0
btn.AutoButtonColor = true
Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 10)

-- Viền màu xanh nước biển
local stroke = Instance.new("UIStroke", btn)
stroke.Thickness = 2
stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

local gradient = Instance.new("UIGradient", stroke)
gradient.Color = ColorSequence.new{
	ColorSequenceKeypoint.new(0, Color3.fromRGB(0,255,255)),
	ColorSequenceKeypoint.new(1, Color3.fromRGB(0,150,255))
}
task.spawn(function()
	while true do
		gradient.Rotation = gradient.Rotation + 1
		task.wait(0.03)
	end
end)

-- Teleport thẳng đến ESP_LockBase
local teleporting = false
btn.MouseButton1Click:Connect(function()
	teleporting = not teleporting
	btn.BackgroundColor3 = teleporting and Color3.fromRGB(0, 170, 255) or Color3.fromRGB(25, 25, 25)
	btn.Text = teleporting and "LOCKING..." or "▶ Tele Lock"

	while teleporting do
		local part = workspace:FindFirstChild("ESP_LockBase")
		local char = LocalPlayer.Character
		local hrp = char and char:FindFirstChild("HumanoidRootPart")
		
		if part and hrp then
			-- 👇 Tele thấp xuống 2 đơn vị
			hrp.CFrame = CFrame.new(part.Position - Vector3.new(0, 3, 0))
		end

		task.wait(0.5)
	end
end)
