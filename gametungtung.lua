
if getgenv then
    if getgenv()._phucmax_ui_loaded then return end
    getgenv()._phucmax_ui_loaded = true
end
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local CoreGui = game:GetService("CoreGui")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local gui = Instance.new("ScreenGui", CoreGui)
gui.Name = "PhucmaxUI"
gui.ResetOnSpawn = false

local main = Instance.new("Frame", gui)
main.Size = UDim2.new(0, 260, 0, 300)
main.Position = UDim2.new(0.5, -130, 0.4, -150)
main.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
main.Active = true
main.Draggable = true
Instance.new("UICorner", main).CornerRadius = UDim.new(0, 10)

local title = Instance.new("TextLabel", main)
title.Size = UDim2.new(1, 0, 0, 40)
title.BackgroundTransparency = 1
title.Text = "phucmax"
title.Font = Enum.Font.FredokaOne
title.TextScaled = true
title.TextColor3 = Color3.new(1, 1, 1)

-- Rainbow title
local rainbowColors = {
	Color3.fromRGB(255, 0, 0), Color3.fromRGB(255, 127, 0),
	Color3.fromRGB(255, 255, 0), Color3.fromRGB(0, 255, 0),
	Color3.fromRGB(0, 255, 255), Color3.fromRGB(0, 0, 255),
	Color3.fromRGB(139, 0, 255)
}
task.spawn(function()
	while true do
		for _, color in ipairs(rainbowColors) do
			title.TextColor3 = color
			task.wait(0.1)
		end
	end
end)

-- Scrollable UI
local contentHolder = Instance.new("Frame", main)
contentHolder.Size = UDim2.new(1, 0, 1, -45)
contentHolder.Position = UDim2.new(0, 0, 0, 45)
contentHolder.BackgroundTransparency = 1
contentHolder.ClipsDescendants = true

local scroller = Instance.new("ScrollingFrame", contentHolder)
scroller.Size = UDim2.new(1, 0, 1, 0)
scroller.CanvasSize = UDim2.new(0, 0, 0, 0)
scroller.BackgroundTransparency = 1
scroller.ScrollBarThickness = 6
scroller.AutomaticCanvasSize = Enum.AutomaticSize.Y

local layout = Instance.new("UIListLayout", scroller)
layout.Padding = UDim.new(0, 8)
layout.SortOrder = Enum.SortOrder.LayoutOrder
layout.HorizontalAlignment = Enum.HorizontalAlignment.Center

-- Toggle GUI button
local logo = Instance.new("ImageButton")
logo.Name = "ToggleButton"
logo.Parent = gui
logo.Size = UDim2.new(0, 50, 0, 50)
logo.Position = UDim2.new(0, 10, 0.5, -25)
logo.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
logo.Image = "rbxassetid://113632547593752"
logo.Draggable = true
Instance.new("UICorner", logo).CornerRadius = UDim.new(0, 12)
logo.MouseButton1Click:Connect(function()
	main.Visible = not main.Visible
end)

-- Notify function
local function showNotification(msg)
	local notify = Instance.new("TextLabel")
	notify.Parent = gui
	notify.Size = UDim2.new(0, 300, 0, 40)
	notify.Position = UDim2.new(1, -310, 1, -60)
	notify.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
	notify.TextColor3 = Color3.fromRGB(255, 255, 255)
	notify.Font = Enum.Font.GothamBold
	notify.TextSize = 18
	notify.Text = msg
	notify.BackgroundTransparency = 0.2
	Instance.new("UICorner", notify).CornerRadius = UDim.new(0, 8)
	game:GetService("TweenService"):Create(notify, TweenInfo.new(0.5), {TextTransparency = 0}):Play()
	wait(2.5)
	game:GetService("TweenService"):Create(notify, TweenInfo.new(0.5), {TextTransparency = 1}):Play()
	wait(0.6)
	notify:Destroy()
end

showNotification("Thank you for using this script!")

-- Button creator
local function createButton(text, callback)
	local btn = Instance.new("TextButton", scroller)
	btn.Size = UDim2.new(0.85, 0, 0, 32)
	btn.BackgroundColor3 = Color3.fromRGB(170, 0, 0)
	btn.TextColor3 = Color3.new(1, 1, 1)
	btn.Text = text
	btn.Font = Enum.Font.GothamBold
	btn.TextSize = 14
	btn.AutoButtonColor = false
	Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)

	local state = false
	btn.MouseButton1Click:Connect(function()
		state = not state
		btn.BackgroundColor3 = state and Color3.fromRGB(0, 170, 0) or Color3.fromRGB(170, 0, 0)
		callback(state)
	end)
end

-- === Teleport to Sky ===
local doorPositions = {
    Vector3.new(-466.9, 2.2, 220.4),  -- Noledaxanh
    Vector3.new(-466.2, 5.1, 111.5),  -- second
    Vector3.new(-466.0, 5.0, -99.3),  -- LinhCut1
    Vector3.new(-353.4, 5.0, 219.9),  -- tucony4753
    Vector3.new(-352.2, 3.7, 114.4),  -- third
    Vector3.new(-352.6, 5.1, -97.8),  -- chayf1d7a147526
}
local function getClosestDoor()
	local hrp = Players.LocalPlayer.Character:WaitForChild("HumanoidRootPart")
	local closest, minDist = nil, math.huge
	for _, pos in ipairs(doorPositions) do
		local dist = (hrp.Position - pos).Magnitude
		if dist < minDist then
			minDist = dist
			closest = pos
		end
	end
	return closest
end
createButton("Teleport Sky", function()
	local hrp = Players.LocalPlayer.Character:WaitForChild("HumanoidRootPart")
	local target = getClosestDoor()
	if not target then return end
	while (hrp.Position - target).Magnitude > 5 do
		local dir = (target - hrp.Position).Unit
		hrp.CFrame = hrp.CFrame + dir * (80 / 60)
		task.wait(1/60)
	end
	hrp.CFrame = hrp.CFrame + Vector3.new(0, 200, 0)
end)

createButton("Fall Down", function()
	local hrp = Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
	if hrp then
		hrp.CFrame = hrp.CFrame - Vector3.new(0, 200, 0)
	end
end)

-- === ESP Players (Auto Update) ===
local espEnabled = false
local espFolder = Instance.new("Folder", CoreGui)
espFolder.Name = "ESPFolder"

local function clearESP()
	for _, v in ipairs(espFolder:GetChildren()) do
		v:Destroy()
	end
end

local function createESP()
	clearESP()
	for _, player in ipairs(Players:GetPlayers()) do
		if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("Head") then
			local head = player.Character.Head
			local billboard = Instance.new("BillboardGui", espFolder)
			billboard.Adornee = head
			billboard.Size = UDim2.new(0, 100, 0, 40)
			billboard.StudsOffset = Vector3.new(0, 2, 0)
			billboard.AlwaysOnTop = true

			local label = Instance.new("TextLabel", billboard)
			label.Size = UDim2.new(1, 0, 1, 0)
			label.BackgroundTransparency = 1
			label.Text = player.Name
			label.TextColor3 = Color3.fromRGB(0, 255, 0)
			label.Font = Enum.Font.GothamBold
			label.TextScaled = true
		end
	end
end

createButton("ESP ", function(state)
	espEnabled = state
	if state then
		spawn(function()
			while espEnabled do
				createESP()
				wait(0.5)
			end
		end)
	else
		clearESP()
	end
end)

-- === Infinite Jump ===
createButton("Infinite Jump", function(state)
	if state then
		UserInputService.JumpRequest:Connect(function()
			if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
				LocalPlayer.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
			end
		end)
	end
end)

-- === Godmode ===
local godConn
createButton("Godmode", function(state)
	local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
	local hum = char:WaitForChild("Humanoid")
	if state then
		godConn = hum:GetPropertyChangedSignal("Health"):Connect(function()
			if hum.Health < 100 then
				hum.Health = 100
			end
		end)
	else
		if godConn then godConn:Disconnect() end
	end
end)

-- === Anti-Stun ===
createButton("Anti-Stun", function(state)
	if state then
		RunService.Stepped:Connect(function()
			local char = LocalPlayer.Character
			if char then
				for _, obj in pairs(char:GetDescendants()) do
					if obj:IsA("BoolValue") and obj.Name:lower():find("stun") then
						obj:Destroy()
					end
				end
			end
		end)
	end
end)

-- === Invisibility ===
local invisConns = {}
createButton("Invisibility", function(state)
	local char = LocalPlayer.Character
	if not char then return end
	if state then
		for _, v in ipairs(char:GetDescendants()) do
			if v:IsA("BasePart") and v.Transparency < 1 then
				v.Transparency = 0.6
				if v.Name ~= "HumanoidRootPart" then
					local old = v:FindFirstChild("originalTransparency") or Instance.new("NumberValue", v)
					old.Name = "originalTransparency"
					old.Value = 0.6
				end
			end
		end
	else
		for _, v in ipairs(char:GetDescendants()) do
			if v:IsA("BasePart") then
				local old = v:FindFirstChild("originalTransparency")
				if old then
					v.Transparency = old.Value
					old:Destroy()
				end
			end
		end
	end
end)