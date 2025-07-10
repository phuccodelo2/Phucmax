-- ⚠️ Đảm bảo đã có ESP_LockBase trong workspace

local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

local gui = CoreGui:FindFirstChild("PhucTeleportBtn") or Instance.new("ScreenGui", CoreGui)
gui.Name = "PhucTeleportBtn"
gui.ResetOnSpawn = false

-- Nút UI
local btn = Instance.new("TextButton", gui)
btn.Size = UDim2.new(0, 80, 0, 50)
btn.Position = UDim2.new(0.5, 60, 0.36, 0) -- Nằm cạnh nút Fall Down
btn.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
btn.TextColor3 = Color3.fromRGB(0, 255, 255)
btn.Text = "▶ Tele Lock"
btn.TextScaled = true
btn.Font = Enum.Font.GothamBold
btn.BorderSizePixel = 0
btn.AutoButtonColor = true
Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 10)

-- Viền 7 màu
local stroke = Instance.new("UIStroke", btn)
stroke.Thickness = 2
stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

local gradient = Instance.new("UIGradient", stroke)
gradient.Color = ColorSequence.new{
	ColorSequenceKeypoint.new(0, Color3.fromRGB(0,255,255)),
	ColorSequenceKeypoint.new(0.5, Color3.fromRGB(0,150,255)),
	ColorSequenceKeypoint.new(1, Color3.fromRGB(0,255,255))
}
task.spawn(function()
	while true do
		gradient.Rotation = gradient.Rotation + 1
		task.wait(0.03)
	end
end)

-- Teleport liên tục
local teleporting = false
btn.MouseButton1Click:Connect(function()
	teleporting = not teleporting
	btn.BackgroundColor3 = teleporting and Color3.fromRGB(0, 170, 255) or Color3.fromRGB(25, 25, 25)
	btn.Text = teleporting and "Tele Locking..." or "▶ Tele Lock"

	while teleporting do
		local part = workspace:FindFirstChild("ESP_LockBase")
		local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")

		if part and hrp then
			-- Tele mượt đến vị trí ESP_LockBase
			local target = part.Position
			local dist = (hrp.Position - target).Magnitude

			while teleporting and hrp and (hrp.Position - target).Magnitude > 3 do
				local dir = (target - hrp.Position).Unit
				hrp.CFrame = hrp.CFrame + dir * (90/60)
				task.wait(1/60)
			end
		end

		task.wait(0.3)
	end
end)
