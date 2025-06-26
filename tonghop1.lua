repeat wait() until game:IsLoaded()

local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")

local function rainbowStroke(target)
	local stroke = Instance.new("UIStroke", target)
	stroke.Thickness = 2
	stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
	local gradient = Instance.new("UIGradient", stroke)
	gradient.Color = ColorSequence.new({
		ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 0, 0)),
		ColorSequenceKeypoint.new(0.2, Color3.fromRGB(255, 255, 0)),
		ColorSequenceKeypoint.new(0.4, Color3.fromRGB(0, 255, 0)),
		ColorSequenceKeypoint.new(0.6, Color3.fromRGB(0, 255, 255)),
		ColorSequenceKeypoint.new(0.8, Color3.fromRGB(0, 0, 255)),
		ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 0, 255)),
	})
	coroutine.wrap(function()
		while gradient and gradient.Parent do
			gradient.Rotation = (gradient.Rotation + 1) % 360
			wait(0.02)
		end
	end)()
end

local gui = Instance.new("ScreenGui", CoreGui)
gui.Name = "PhucMaxHub"
gui.ResetOnSpawn = false

-- Logo nút bật menu
local logo = Instance.new("ImageButton", gui)
logo.Size = UDim2.new(0, 50, 0, 50)
logo.Position = UDim2.new(0, 10, 0.4, 0)
logo.Image = "rbxassetid://96060225144044"
logo.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
logo.AutoButtonColor = true
Instance.new("UICorner", logo).CornerRadius = UDim.new(1, 0)
logo.Draggable = true
rainbowStroke(logo)

-- Main menu
local main = Instance.new("Frame", gui)
main.Size = UDim2.new(0, 550, 0, 400)
main.Position = UDim2.new(0.5, -275, 0.5, -200)
main.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
main.Visible = true
main.Active = true
main.Draggable = true
Instance.new("UICorner", main).CornerRadius = UDim.new(0, 10)
rainbowStroke(main)

logo.MouseButton1Click:Connect(function()
	main.Visible = not main.Visible
end)

-- Tabs frame
local tabBar = Instance.new("ScrollingFrame", main)
tabBar.Size = UDim2.new(1, -20, 0, 45)
tabBar.Position = UDim2.new(0, 10, 0, 10)
tabBar.CanvasSize = UDim2.new(0, 1500, 0, 0)
tabBar.ScrollingDirection = Enum.ScrollingDirection.X
tabBar.ScrollBarThickness = 4
tabBar.BackgroundTransparency = 1

local tabPages = {}
local tabNames = {
	["THÔNG TIN"] = {},
	["SCRIPT FARM"] = {},
	["SCRIPT HOP"] = {},
	["SCRIPT BOUNTY"] = {},
	["SCRIPT KAITUN"] = {},
	["SCRIPT FIXLAG"] = {},
	["SCRIPT NHẶT TRÁI"] = {},
	["SCRIPT AIMBOT"] = {},
	["SCRIPT TỔNG HỢP"] = {},
	["GROW A GARDEN"] = {}
}

local function switchTab(name)
	for tab, page in pairs(tabPages) do
		page.Visible = (tab == name)
	end
end

local tabIndex = 0
for tabName in pairs(tabNames) do
	local btn = Instance.new("TextButton", tabBar)
	btn.Size = UDim2.new(0, 130, 0, 40)
	btn.Position = UDim2.new(0, tabIndex * 135, 0, 0)
	btn.Text = tabName
	btn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
	btn.TextColor3 = Color3.new(1, 1, 1)
	btn.Font = Enum.Font.GothamBold
	btn.TextSize = 13
	Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)

	local page = Instance.new("Frame", main)
	page.Size = UDim2.new(1, -20, 1, -70)
	page.Position = UDim2.new(0, 10, 0, 60)
	page.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
	page.Visible = (tabIndex == 0)
	Instance.new("UICorner", page).CornerRadius = UDim.new(0, 6)
	tabPages[tabName] = page

	btn.MouseButton1Click:Connect(function()
		switchTab(tabName)
	end)

	tabIndex += 1
end

-- Script button generator
local function createScriptButton(parent, name, url)
	local btn = Instance.new("TextButton", parent)
	btn.Size = UDim2.new(1, 0, 0, 40)
	btn.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
	btn.TextColor3 = Color3.new(1, 1, 1)
	btn.Font = Enum.Font.Gotham
	btn.TextSize = 14
	btn.Text = "CHẠY SCRIPT: " .. name
	btn.AutoButtonColor = true
	Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)

	btn.MouseButton1Click:Connect(function()
		pcall(function()
			loadstring(game:HttpGet(url))()
			game.StarterGui:SetCore("SendNotification", {
				Title = "✅ Đã chạy!",
				Text = name,
				Duration = 3,
				Icon = "rbxassetid://7072718364"
			})
		end)
	end)
end

-- THÊM CÁC SCRIPT VÀO ĐÂY:
-- Ví dụ: createScriptButton(tabPages["SCRIPT FARM"], "Tên script", "link raw")

createScriptButton(tabPages["THÔNG TIN"], "Copy Discord", "https://discord.gg/Ed66pVng")

-- SCRIPT FARM
createScriptButton(tabPages["SCRIPT FARM"], "tuananhios", "https://raw.githubusercontent.com/AnhTuanDzai-Hub/TuanAnhIOS/refs/heads/main/TuanAnhIOS.lua")
createScriptButton(tabPages["SCRIPT FARM"], "banana", "https://raw.githubusercontent.com/LuaStupid/ExecuteGames/main/QuestGames.lua")
createScriptButton(tabPages["SCRIPT FARM"], "speed", "https://raw.githubusercontent.com/AhmadV99/Speed-Hub-X/main/Speed%20Hub%20X.lua")
createScriptButton(tabPages["SCRIPT FARM"], "vxeze", "https://pandadevelopment.net/virtual/file/e50b45018b39ad3e")
createScriptButton(tabPages["SCRIPT FARM"], "fly", "https://raw.githubusercontent.com/TurboLite/Script/refs/heads/main/Fly.lua")
createScriptButton(tabPages["SCRIPT FARM"], "redz", "https://raw.githubusercontent.com/tlredz/Scripts/refs/heads/main/main.luau")
createScriptButton(tabPages["SCRIPT FARM"], "maru1", "https://raw.githubusercontent.com/LuaCrack/KimP/refs/heads/main/MaruHub")
-- ... tiếp tục thêm các dòng tương tự

-- SCRIPT FIXLAG
createScriptButton(tabPages["SCRIPT FIXLAG"], "Turbo FixLag", "https://raw.githubusercontent.com/TurboLite/Script/main/FixLag.lua")

-- SCRIPT NHẶT TRÁI
createScriptButton(tabPages["SCRIPT NHẶT TRÁI"], "tuananhnhattrai", "https://raw.githubusercontent.com/AnhTuanDzai-Hub/AutoFruitDepzai/refs/heads/main/TuanAnhIOS-Find-Fruit.Lua")

-- SCRIPT AIMBOT
createScriptButton(tabPages["SCRIPT AIMBOT"], "tuananhaimbot", "https://raw.githubusercontent.com/AnhTuanDzai-Hub/AimBotSkibidi/refs/heads/main/TuanAnhIOS-AIMBOT.Lua")

-- SCRIPT TỔNG HỢP
createScriptButton(tabPages["SCRIPT TỔNG HỢP"], "nghia11n", "https://raw.githubusercontent.com/Nghia11n/VIP/main/allscript.lua")
createScriptButton(tabPages["SCRIPT TỔNG HỢP"], "scripttonghop", "https://isnahamzahpastebin.tech/loader/isna_scripthub_30")
createScriptButton(tabPages["SCRIPT TỔNG HỢP"], "stuckez", "https://raw.githubusercontent.com/stuckez999/main/refs/heads/main/tonghoproblox.lua")

-- GROW A GARDEN
createScriptButton(tabPages["GROW A GARDEN"], "NoLag", "https://raw.githubusercontent.com/NoLag-id/No-Lag-HUB/refs/heads/main/Loader/LoaderV1.lua")
createScriptButton(tabPages["GROW A GARDEN"], "Kenniel", "https://raw.githubusercontent.com/Kenniel123/Grow-a-garden/refs/heads/main/Grow%20A%20Garden")
createScriptButton(tabPages["GROW A GARDEN"], "Blue", "https://raw.githubusercontent.com/tesghg/Grow-a-Garden/main/ameicaa_Grow_A_Garden.lua")

-- Thêm tiếp các script bạn cần như trên nếu thiếu
