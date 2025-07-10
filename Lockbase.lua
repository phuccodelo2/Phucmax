-- Teleport thẳng đến ESP_LockBase và thấp xuống 2 đơn vị
btn.MouseButton1Click:Connect(function()
	teleporting = not teleporting
	btn.BackgroundColor3 = teleporting and Color3.fromRGB(0, 170, 255) or Color3.fromRGB(25, 25, 25)
	btn.Text = teleporting and "LOCKING..." or "▶Lock base"

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
