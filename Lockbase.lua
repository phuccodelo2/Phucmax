-- Tạo nút Tele Lock cạnh Fall Down
local teleLockBtn = Instance.new("TextButton", gui)
teleLockBtn.Size = UDim2.new(0, 100, 0, 40)
teleLockBtn.Position = UDim2.new(0.5, -50, 0.1, 60) -- đặt gần "Fall Down"
teleLockBtn.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
teleLockBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
teleLockBtn.Text = "▶ Tele Lock"
teleLockBtn.Font = Enum.Font.GothamBold
teleLockBtn.TextScaled = true
teleLockBtn.AutoButtonColor = true
Instance.new("UICorner", teleLockBtn).CornerRadius = UDim.new(0, 8)

local stroke = Instance.new("UIStroke", teleLockBtn)
stroke.Thickness = 2
stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

local gradient = Instance.new("UIGradient", stroke)
gradient.Color = ColorSequence.new{
	ColorSequenceKeypoint.new(0, Color3.fromRGB(0,255,255)),
	ColorSequenceKeypoint.new(0.2, Color3.fromRGB(0,170,255)),
	ColorSequenceKeypoint.new(0.4, Color3.fromRGB(0,85,255)),
	ColorSequenceKeypoint.new(0.6, Color3.fromRGB(0,170,255)),
	ColorSequenceKeypoint.new(0.8, Color3.fromRGB(0,255,255)),
	ColorSequenceKeypoint.new(1, Color3.fromRGB(0,255,255))
}
task.spawn(function()
	while true do
		gradient.Rotation += 1
		task.wait(0.03)
	end
end)

-- Tele đến ESP_LockBase mỗi 0.5s
local teleporting = false
teleLockBtn.MouseButton1Click:Connect(function()
	teleporting = not teleporting
	teleLockBtn.BackgroundColor3 = teleporting and Color3.fromRGB(0, 170, 255) or Color3.fromRGB(25, 25, 25)
	teleLockBtn.Text = teleporting and "LOCKING..." or "▶ Tele Lock"

	while teleporting do
		local part = workspace:FindFirstChild("ESP_LockBase")
		local char = LocalPlayer.Character
		local hrp = char and char:FindFirstChild("HumanoidRootPart")

		if part and hrp then
			hrp.CFrame = CFrame.new(part.Position - Vector3.new(0, 2, 0)) -- THẤP XUỐNG 2
		end

		task.wait(0.5)
	end
end)
