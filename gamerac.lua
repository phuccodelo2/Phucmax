repeat wait() until game:IsLoaded()

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


local doorPositions = {
	Vector3.new(-466, -1, 220),Vector3.new(-466, -2, 116),
	Vector3.new(-466, -2, 8),Vector3.new(-464, -2, -102),Vector3.new(-351, -2, -100),
	Vector3.new(-354, -2, 5),Vector3.new(-354, -2, 115),Vector3.new(-358, -2, 223)
}


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


local function goUp()
	local door = getNearestDoor()
	if door then
		TweenService:Create(root, TweenInfo.new(1.2), {CFrame = CFrame.new(door)}):Play()
		wait(1.3)
		root.CFrame = root.CFrame + Vector3.new(0, 200, 0)
	end
end 

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
local humanoid = char:FindFirstChildOfClass("Humanoid")

_G.SlowFallJump = false

-- Tạo trạng thái bay lên
UserInputService.JumpRequest:Connect(function()
	if _G.SlowFallJump and humanoid and root then
		-- Bay lên cao
		root.AssemblyLinearVelocity = Vector3.new(0, 100, 0)

		-- Giảm trọng lực tạm thời để rơi chậm
		local gravityConn
		gravityConn = RunService.Stepped:Connect(function()
			if not char or not root or not humanoid then
				gravityConn:Disconnect()
				return
			end

			-- Kiểm tra nếu nhân vật đã chạm đất thì dừng giảm lực
			if humanoid:GetState() == Enum.HumanoidStateType.Freefall then
				-- Làm giảm tốc độ rơi
				root.Velocity = Vector3.new(root.Velocity.X, math.clamp(root.Velocity.Y, -20, 150), root.Velocity.Z)
			elseif humanoid.FloorMaterial ~= Enum.Material.Air then
				gravityConn:Disconnect()
			end
		end)
	end
end)

local gui = Instance.new("ScreenGui", game.CoreGui)
gui.Name = "Phuclocal Players = game:GetService("Players")

function applyESP(plr)
	if plr == player then return end
		if not char:FindFirstChild("HumanoidRootPart") then return end

		-- Gỡ ESP cũ nếu có
		if char:FindFirstChild("PlayerESP") then char.PlayerESP:Destroy() end
		if char:FindFirstChild("HumanoidRootPart"):FindFirstChild("NameTag") then
			char.HumanoidRootPart.NameTag:Destroy()
		end

		-- Highlight
		local highlight = Instance.new("Highlight", char)
		highlight.Name = "PlayerESP"
		highlight.FillColor = Color3.fromRGB(255, 0, 0)
		highlight.OutlineColor = Color3.new(1, 1, 1)

		-- Name tag
		local nameTag = Instance.new("BillboardGui", char.HumanoidRootPart)
		nameTag.Name = "NameTag"
		nameTag.Size = UDim2.new(0, 100, 0, 30)
		nameTag.AlwaysOnTop = true
		nameTag.StudsOffset = Vector3.new(0, 2, 0)

		local nameText = Instance.new("TextLabel", nameTag)
		nameText.Size = UDim2.new(1, 0, 1, 0)
		nameText.BackgroundTransparency = 1
		nameText.TextColor3 = Color3.fromRGB(255, 0, 0)
		nameText.Text = plr.DisplayName
		nameText.Font = Enum.Font.GothamBold
		nameText.TextScaled = true
	end

	if plr.Character then
		addESP(plr.Character)
	end

	plr.CharacterAdded:Connect(function(char)
		repeat wait() until char:FindFirstChild("HumanoidRootPart")
		addESP(char)
	end)
end

-- Hàm bật / tắt ESP toàn bộ
_G.espEnabled = false

function setESPPlayer(on)
	_G.espEnabled = on
	if on then
		for _, plr in pairs(Players:GetPlayers()) do
			applyESP(plr)
		end
		Players.PlayerAdded:Connect(applyESP)
	else
		for _, plr in pairs(Players:GetPlayers()) do
			if plr.Character and plr.Character:FindFirstChild("PlayerESP") then
				plr.Character.PlayerESP:Destroy()
			end
			if plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
				local tag = plr.Character.HumanoidRootPart:FindFirstChild("NameTag")
				if tag then tag:Destroy() end
			end
		end
	end
end

local gui = Instance.new("ScreenGui", game.CoreGui)
gui.Name = "PhucmaxUI"
gui.ResetOnSpawn = false

local main = Instance.new("Frame", gui)
main.Size = UDim2.new(0, 260, 0, 270)
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
local content = Instance.new("Frame", main)
content.Size = UDim2.new(1, 0, 1, -50)
content.Position = UDim2.new(0, 0, 0, 45)
content.BackgroundTransparency = 1

local logo = Instance.new("ImageButton")
logo.Name = "ToggleButton"
logo.Parent = gui
logo.Size = UDim2.new(0, 50, 0, 50)
logo.Position = UDim2.new(0, 15, 1, 30) 
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



local sound = Instance.new("Sound", gui)
sound.SoundId = "rbxassetid://120471255813363" 
sound.Volume = 100
sound:Play()

local function showNotification(msg)
	local notify = Instance.new("TextLabel")
	notify.Parent = gui
	notify.Size = UDim2.new(0, 300, 0, 40)
	notify.Position = UDim2.new(0.5, -150, 0.1, 20)
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