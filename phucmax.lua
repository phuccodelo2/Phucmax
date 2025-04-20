
-- PhucMax Fix Lag Script UI

local ScreenGui = Instance.new("ScreenGui")
local Main = Instance.new("Frame")
local ToggleButton = Instance.new("TextButton")
local Title = Instance.new("TextLabel")
local UICorner = Instance.new("UICorner")

ScreenGui.Name = "PhucMaxFixLag"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = game.CoreGui

-- Toggle Button Setup
ToggleButton.Size = UDim2.new(0, 100, 0, 35)
ToggleButton.Position = UDim2.new(0, 10, 0, 10)
ToggleButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
ToggleButton.Text = "Ẩn / Hiện Menu"
ToggleButton.TextColor3 = Color3.new(1,1,1)
ToggleButton.Font = Enum.Font.GothamBold
ToggleButton.TextSize = 12
ToggleButton.Parent = ScreenGui
Instance.new("UICorner", ToggleButton)

-- Main UI Setup
Main.Size = UDim2.new(0, 220, 0, 360)
Main.Position = UDim2.new(0.5, -110, 0.5, -180)
Main.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
Main.Parent = ScreenGui
UICorner.Parent = Main

Title.Size = UDim2.new(1, 0, 0, 40)
Title.Text = "PhucMax Fix Lag"
Title.TextColor3 = Color3.new(1, 1, 1)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 16
Title.BackgroundTransparency = 1
Title.Parent = Main

local UIListLayout = Instance.new("UIListLayout", Main)
UIListLayout.Padding = UDim.new(0, 10)
UIListLayout.FillDirection = Enum.FillDirection.Vertical
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder

-- Toggle Function
ToggleButton.MouseButton1Click:Connect(function()
	Main.Visible = not Main.Visible
end)

-- Tạo button nhanh
local function createButton(text, parent, callback)
	local btn = Instance.new("TextButton")
	btn.Size = UDim2.new(0, 200, 0, 40)
	btn.Text = text
	btn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
	btn.TextColor3 = Color3.new(1, 1, 1)
	btn.Font = Enum.Font.GothamBold
	btn.TextSize = 14
	btn.Parent = parent
	local corner = Instance.new("UICorner", btn)
	btn.MouseButton1Click:Connect(callback)
	return btn
end

-- Hàm fix lag chính
local function fixLag(level)
	for _, v in pairs(workspace:GetDescendants()) do
		if v:IsA("Part") or v:IsA("MeshPart") or v:IsA("UnionOperation") then
			if level >= 1 then v.CastShadow = false end
			if level >= 2 then v.Material = Enum.Material.SmoothPlastic end
			if level >= 3 then v.Reflectance = 0; pcall(function() v.TextureID = "" end) end
		elseif v:IsA("Decal") or v:IsA("Texture") then
			if level >= 2 then v:Destroy() end
		elseif v:IsA("ParticleEmitter") or v:IsA("Trail") or v:IsA("Beam") then
			if level >= 3 then v.Enabled = false end
		elseif v:IsA("Sky") and level >= 2 then
			v:Destroy()
		elseif v:IsA("Tree") or (v.Name:lower():find("tree") or v.Name:lower():find("bush")) then
			if level >= 3 then v:Destroy() end
		end
	end
	if level >= 4 then
		local lighting = game:GetService("Lighting")
		lighting.GlobalShadows = false
		lighting.FogEnd = 100000
		lighting.Brightness = 1
		lighting.ClockTime = 14
		lighting.OutdoorAmbient = Color3.fromRGB(127,127,127)
	end
end

-- Các nút chức năng
createButton("Fix Lag X3 | Xóa 60%", Main, function() fixLag(2) end)
createButton("Fix Lag X4 | Xóa 70%", Main, function() fixLag(3) end)
createButton("Fix Lag X5 | Xóa 80%", Main, function() fixLag(4) end)
createButton("Fix Lag X6 | Xóa 90%", Main, function() fixLag(5) end)

createButton("Tối Ưu Toàn Bộ | Sức Mạnh", Main, function()
	fixLag(5)
	for _,v in pairs(game.Lighting:GetChildren()) do if not v:IsA("ValueBase") then v:Destroy() end end
end)

-- Logo góc phải
local logo = Instance.new("ImageLabel")
logo.Size = UDim2.new(0, 60, 0, 60)
logo.Position = UDim2.new(1, -70, 0, 10)
logo.Image = "rbxassetid://14810441703" -- Logo PhucMax
logo.BackgroundTransparency = 1
logo.Parent = ScreenGui
