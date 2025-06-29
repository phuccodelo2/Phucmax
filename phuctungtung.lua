local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local root = Players.LocalPlayer.Character:WaitForChild("HumanoidRootPart")

local doorPositions = {
	Vector3.new(-466, -1, 220),
	Vector3.new(-466, -2, 116),
	Vector3.new(-466, -2, 8),
	Vector3.new(-464, -2, -102),
	Vector3.new(-351, -2, -100),
	Vector3.new(-354, -2, 5),
	Vector3.new(-354, -2, 115),
	Vector3.new(-358, -2, 223)
}

-- Hàm tìm cửa gần nhất
local function getNearestDoor()
	local closest, minDist = nil, math.huge
	for _, door in ipairs(doorPositions) do
		local dist = (root.Position - door).Magnitude
		if dist < minDist then
			minDist = dist
			closest = door
		end
	end
	return closest
end

-- Hàm bật NoClip
local noclipConn
local function enableNoClip()
	if noclipConn then noclipConn:Disconnect() end
	noclipConn = RunService.Stepped:Connect(function()
		if Players.LocalPlayer.Character and Players.LocalPlayer.Character:FindFirstChild("Humanoid") then
			Players.LocalPlayer.Character.Humanoid:ChangeState(11) -- NoClip
		end
	end)
end

-- Hàm tắt NoClip
local function disableNoClip()
	if noclipConn then
		noclipConn:Disconnect()
		noclipConn = nil
	end
end

-- Hàm bay lên cửa gần nhất + NoClip
local function goUp()
	local door = getNearestDoor()
	if not door then return end

	local targetPosition = door + Vector3.new(0, 200, 0)
	local goalCFrame = CFrame.new(targetPosition)

	enableNoClip() -- Bật NoClip trước khi bay

	local tween = TweenService:Create(root, TweenInfo.new(2, Enum.EasingStyle.Linear), {CFrame = goalCFrame})
	tween:Play()

	tween.Completed:Connect(function()
		disableNoClip() -- Tắt NoClip sau khi bay xong
	end)
end

-- Gọi thử
-- goUp()repeat wait() until game:IsLoaded()

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local player = Players.LocalPlayer

local char, root
local jumpEnabled = false

local function updateChar()
	char = player.Character or player.CharacterAdded:Wait()
	root = char:WaitForChild("HumanoidRootPart")
end

updateChar()
player.CharacterAdded:Connect(function()
	wait(1)
	updateChar()
end)


local TweenService = game:GetService("TweenService")


local function dropDown()
	if root then
		root.CFrame = root.CFrame - Vector3.new(0, 50, 0)
	end
end

UserInputService.JumpRequest:Connect(function()
	if jumpEnabled and char and char:FindFirstChildOfClass("Humanoid") then
		char:FindFirstChildOfClass("Humanoid"):ChangeState("Jumping")
	end
end)

local godConnection = nil

function setGodMode(on)
	local hum = char and char:FindFirstChildOfClass("Humanoid")
	if not hum then return end

	if on then
		hum.MaxHealth = math.huge
		hum.Health = math.huge
		if godConnection then godConnection:Disconnect() end
		godConnection = hum:GetPropertyChangedSignal("Health"):Connect(function()
			if hum.Health < math.huge then
				hum.Health = math.huge
			end
		end)
	else
		if godConnection then godConnection:Disconnect() end
		hum.MaxHealth = 100
		hum.Health = 100
	end
end

function setInvisible(on)
	for _, part in ipairs(char:GetDescendants()) do
		if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
			part.Transparency = on and 1 or 0
		elseif part:IsA("Decal") then
			part.Transparency = on and 1 or 0
		end
	end
end
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local player = Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local root = char:WaitForChild("HumanoidRootPart")

_G.SuperJump = false

UserInputService.JumpRequest:Connect(function()
	if _G.SuperJump then
		local hum = char:FindFirstChildOfClass("Humanoid")
		if hum then
			hum:ChangeState(Enum.HumanoidStateType.Jumping)
			root.Velocity = root.CFrame.LookVector * 2000 + Vector3.new(0, 200, 0)
		end
	end
end)
function setESPPlayer(on)
	for _, plr in pairs(Players:GetPlayers()) do
		if plr ~= player and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
			if on then
				local highlight = Instance.new("Highlight", plr.Character)
				highlight.Name = "PlayerESP"
				highlight.FillColor = Color3.fromRGB(255, 0, 0)

				local nameTag = Instance.new("BillboardGui", plr.Character.HumanoidRootPart)
				nameTag.Name = "NameTag"
				nameTag.Size = UDim2.new(0, 100, 0, 40)
				nameTag.AlwaysOnTop = true

				local nameText = Instance.new("TextLabel", nameTag)
				nameText.Size = UDim2.new(1, 0, 1, 0)
				nameText.Text = plr.DisplayName
				nameText.TextColor3 = Color3.new(1, 0, 0)
				nameText.BackgroundTransparency = 1
			else
				if plr.Character:FindFirstChild("PlayerESP") then plr.Character.PlayerESP:Destroy() end
				if plr.Character:FindFirstChild("HumanoidRootPart"):FindFirstChild("NameTag") then
					plr.Character.HumanoidRootPart.NameTag:Destroy()
				end
			end
		end
	end
end

local gui = Instance.new("ScreenGui", game.CoreGui)
gui.Name = "PhucmaxUI"
gui.ResetOnSpawn = false

local main = Instance.new("Frame", gui)
main.Size = UDim2.new(0, 260, 0, 320)
main.Position = UDim2.new(0.5, -130, 0.4, -175)
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


local rainbowColors = {
	Color3.fromRGB(255, 0, 0),    
	Color3.fromRGB(255, 127, 0), 
	Color3.fromRGB(255, 255, 0),  
	Color3.fromRGB(0, 255, 0),    
	Color3.fromRGB(0, 255, 255),  
	Color3.fromRGB(0, 0, 255),    
	Color3.fromRGB(139, 0, 255)   
}

spawn(function()
	while true do
		for _, color in ipairs(rainbowColors) do
			title.TextColor3 = color
			wait(0.1)
		end
	end
end)
local content = Instance.new("ScrollingFrame", main)
content.Size = UDim2.new(1, -10, 1, -50)
content.Position = UDim2.new(0, 5, 0, 45)
content.BackgroundTransparency = 1
content.CanvasSize = UDim2.new(0, 0, 0, 0)
content.ScrollBarThickness = 6
content.ScrollingDirection = Enum.ScrollingDirection.Y
content.AutomaticCanvasSize = Enum.AutomaticSize.Y
content.ClipsDescendants = true

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
local layout = Instance.new("UIListLayout", content)
layout.Padding = UDim.new(0, 8)
layout.SortOrder = Enum.SortOrder.LayoutOrder
layout.HorizontalAlignment = Enum.HorizontalAlignment.Center


local function createButton(text, callback)
	local btn = Instance.new("TextButton", content)
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


createButton("Teleport to Sky", function(on) if on then goUp() end end)
createButton("Go Down", function(on) if on then dropDown() end end)
createButton("Unlimited Jump", function(on)
	local hum = char and char:FindFirstChildOfClass("Humanoid")
	if hum then hum.JumpPower = on and 250 or 50 end
	jumpEnabled = on
end)
createButton("God Mode", function(on)
	setGodMode(on)
end)
-- Tàng hình
createButton("Invisibility", function(on)
	setInvisible(on)
end)

-- Nhảy bay
createButton("High Jump", function(on)
	_G.FlyJump = on
end)

-- ESP người chơi
createButton("ESP player", function(on)
	setESPPlayer(on)
end)

-- Anti Stun
createButton("Anti Stun", function(on)
	antiStun(on)
end)

local sound = Instance.new("Sound", gui)
sound.SoundId = "rbxassetid://120471255813363" 
sound.Volume = 100
sound:Play()

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
	notify.TextStrokeTransparency = 0.5
	notify.TextStrokeColor3 = Color3.new(0, 0, 0)
	notify.BackgroundTransparency = 0.2

	Instance.new("UICorner", notify).CornerRadius = UDim.new(0, 8)

	
	game:GetService("TweenService"):Create(notify, TweenInfo.new(0.5), {TextTransparency = 0, BackgroundTransparency = 0.2}):Play()
	wait(2.5)
	game:GetService("TweenService"):Create(notify, TweenInfo.new(0.5), {TextTransparency = 1, BackgroundTransparency = 1}):Play()
	wait(0.6)
	notify:Destroy()
end


showNotification("cảm ơn bạn đã sử dụng script ")
