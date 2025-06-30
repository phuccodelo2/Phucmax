
-- GUI hiện đại kéo được + logo
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local mouse = LocalPlayer:GetMouse()

local doorPositions = {
	Vector3.new(-466, -1, 220), Vector3.new(-466, -2, 116),
	Vector3.new(-466, -2, 8), Vector3.new(-464, -2, -102),
	Vector3.new(-351, -2, -100), Vector3.new(-354, -2, 5),
	Vector3.new(-354, -2, 115), Vector3.new(-358, -2, 223)
}

local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
ScreenGui.Name = "ModernUI"

local Frame = Instance.new("Frame", ScreenGui)
Frame.Size = UDim2.new(0, 300, 0, 400)
Frame.Position = UDim2.new(0.05, 0, 0.2, 0)
Frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
Frame.BorderSizePixel = 0
Frame.Active = true
Frame.Draggable = true

local UICorner = Instance.new("UICorner", Frame)
UICorner.CornerRadius = UDim.new(0, 12)

local UIList = Instance.new("UIListLayout", Frame)
UIList.Padding = UDim.new(0, 10)
UIList.SortOrder = Enum.SortOrder.LayoutOrder

local Logo = Instance.new("ImageLabel", Frame)
Logo.Size = UDim2.new(1, 0, 0, 80)
Logo.BackgroundTransparency = 1
Logo.Image = "rbxassetid://6031265976"

-- Toggle Button
local toggle = false
local ToggleButton = Instance.new("TextButton", ScreenGui)
ToggleButton.Size = UDim2.new(0, 100, 0, 40)
ToggleButton.Position = UDim2.new(0, 10, 0.05, 0)
ToggleButton.Text = "Menu"
ToggleButton.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
ToggleButton.TextColor3 = Color3.new(1, 1, 1)
ToggleButton.MouseButton1Click:Connect(function()
	toggle = not toggle
	Frame.Visible = toggle
end)

-- Helper: teleport to closest door
local function getClosestDoor()
	local char = LocalPlayer.Character
	if not char or not char:FindFirstChild("HumanoidRootPart") then return end
	local pos = char.HumanoidRootPart.Position
	local closest, dist = nil, math.huge
	for _, v in ipairs(doorPositions) do
		local d = (v - pos).Magnitude
		if d < dist then
			dist = d
			closest = v
		end
	end
	return closest
end

-- Create button function
local function createButton(name, callback)
	local btn = Instance.new("TextButton", Frame)
	btn.Size = UDim2.new(1, -20, 0, 40)
	btn.Text = name
	btn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
	btn.TextColor3 = Color3.new(1, 1, 1)
	btn.BorderSizePixel = 0
	btn.MouseButton1Click:Connect(callback)
	return btn
end

-- Chức năng 1: Bay đến door gần nhất rồi tele lên 200
createButton("Bay đến gần nhất + lên 200", function()
	local pos = getClosestDoor()
	if pos then
		local hrp = LocalPlayer.Character:WaitForChild("HumanoidRootPart")
		local speed = 50
		local distance = (pos - hrp.Position).Magnitude
		local travelTime = distance / speed
		local steps = travelTime * 60
		local stepVector = (pos - hrp.Position) / steps

		for i = 1, steps do
			hrp.CFrame = hrp.CFrame + stepVector
			wait(1/60)
		end

		wait(0.1)
		hrp.CFrame = hrp.CFrame + Vector3.new(0, 200, 0)
	end
end)

-- Chức năng 2
createButton("Rơi xuống từ trên", function()
	local pos = getClosestDoor()
	if pos then
		local hrp = LocalPlayer.Character:WaitForChild("HumanoidRootPart")
		hrp.CFrame = CFrame.new(pos + Vector3.new(0, 50, 0))
	end
end)

-- Chức năng 3: ESP
local espEnabled = true
createButton("ESP Player", function()
	while espEnabled do
		for _, plr in ipairs(Players:GetPlayers()) do
			if plr ~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("Head") and not plr.Character.Head:FindFirstChild("BillboardGui") then
				local esp = Instance.new("BillboardGui", plr.Character.Head)
				esp.Size = UDim2.new(0, 100, 0, 40)
				esp.AlwaysOnTop = true
				local text = Instance.new("TextLabel", esp)
				text.Size = UDim2.new(1, 0, 1, 0)
				text.BackgroundTransparency = 1
				text.Text = plr.Name
				text.TextColor3 = Color3.new(1, 0, 0)
			end
		end
		wait(5)
	end
end)

-- Chức năng 4: God mode
createButton("Bất tử", function()
	local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
	if hum then
		hum.Name = "GodHumanoid"
		local new = hum:Clone()
		new.Parent = LocalPlayer.Character
		new.Name = "Humanoid"
		wait()
		hum:Destroy()
		LocalPlayer.Character.Animate.Disabled = true
		wait()
		LocalPlayer.Character.Animate.Disabled = false
	end
end)

-- Chức năng 5: Fly + nhảy vô hạn
createButton("Fly + Nhảy vô hạn", function()
	local UIS = game:GetService("UserInputService")
	local flying = true
	local bp = Instance.new("BodyPosition")
	bp.MaxForce = Vector3.new(0, math.huge, 0)
	bp.Position = LocalPlayer.Character.HumanoidRootPart.Position
	bp.Parent = LocalPlayer.Character.HumanoidRootPart
	local run = game:GetService("RunService").RenderStepped:Connect(function()
		if flying then
			bp.Position = LocalPlayer.Character.HumanoidRootPart.Position + Vector3.new(0, 0.1, 0)
		end
	end)
	UIS.InputBegan:Connect(function(input)
		if input.KeyCode == Enum.KeyCode.Space then
			LocalPlayer.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
		end
	end)
end)

-- Chức năng 6: Anti stun
createButton("Anti Stun", function()
	while true do
		for _, v in pairs(LocalPlayer.Character:GetDescendants()) do
			if v:IsA("BoolValue") and v.Name == "Stunned" then
				v:Destroy()
			end
		end
		wait(1)
	end
end)
