repeat wait() until game:IsLoaded()
local CoreGui = game:GetService("CoreGui")
local TS = game:GetService("TweenService")

-- ⚙️ Tạo giao diện chính
local gui = Instance.new("ScreenGui", CoreGui)
gui.Name = "PhucMaxHub"
gui.ResetOnSpawn = false

-- ⚙️ Logo bật/tắt menu
local logo = Instance.new("ImageButton", gui)
logo.Size = UDim2.new(0, 60, 0, 60)
logo.Position = UDim2.new(0, 10, 0.4, 0)
logo.Image = "rbxassetid://96060225144044"
logo.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
logo.Draggable = true
Instance.new("UICorner", logo).CornerRadius = UDim.new(0, 14)

-- ⚙️ Main menu
local main = Instance.new("Frame", gui)
main.Size = UDim2.new(0, 550, 0, 400)
main.Position = UDim2.new(0.5, -275, 0.5, -200)
main.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
main.Visible = true
main.Draggable = true
Instance.new("UICorner", main).CornerRadius = UDim.new(0, 10)

logo.MouseButton1Click:Connect(function()
	main.Visible = not main.Visible
end)

-- ⚙️ Tab names và frame chứa
local tabNames = {
	"THÔNG TIN", "SCRIPT FARM", "SCRIPT HOP", 
	"SCRIPT KAITUN", "SCRIPT FIXLAG", "SCRIPT NHẶT TRÁI",
	"SCRIPT AIMBOT", "SCRIPT TỔNG HỢP", "GROW A GARDEN"
}

local tabHolder = Instance.new("ScrollingFrame", main)
tabHolder.Size = UDim2.new(1, -20, 0, 50)
tabHolder.Position = UDim2.new(0, 10, 0, 10)
tabHolder.CanvasSize = UDim2.new(0, #tabNames * 150, 0, 0)
tabHolder.ScrollBarThickness = 4
tabHolder.ScrollingDirection = Enum.ScrollingDirection.X
tabHolder.BackgroundTransparency = 1

local tabPages = {}

-- ⚙️ Tạo từng tab
for i, name in ipairs(tabNames) do
	local btn = Instance.new("TextButton", tabHolder)
	btn.Size = UDim2.new(0, 140, 0, 40)
	btn.Position = UDim2.new(0, (i - 1) * 145, 0, 5)
	btn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
	btn.TextColor3 = Color3.fromRGB(255, 255, 255)
	btn.Font = Enum.Font.GothamBold
	btn.TextSize = 14
	btn.Text = name
	Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)

	local page = Instance.new("ScrollingFrame", main)
	page.Name = name
	page.Size = UDim2.new(1, -20, 1, -70)
	page.Position = UDim2.new(0, 10, 0, 60)
	page.CanvasSize = UDim2.new(0, 0, 0, 1000)
	page.ScrollBarThickness = 4
	page.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
	page.Visible = (i == 1)
	Instance.new("UICorner", page).CornerRadius = UDim.new(0, 6)

	tabPages[name] = page

	btn.MouseButton1Click:Connect(function()
		for _, v in pairs(tabPages) do v.Visible = false end
		page.Visible = true
	end)
end

-- ⚙️ Tạo nút chạy script
local function createScriptButton(tab, name, url)
	local count = 0
	for _, c in ipairs(tab:GetChildren()) do
		if c:IsA("TextButton") then count += 1 end
	end

	local btn = Instance.new("TextButton", tab)
	btn.Size = UDim2.new(1, -20, 0, 40)
	btn.Position = UDim2.new(0, 10, 0, (count) * 45 + 10)
	btn.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
	btn.Text = "CHẠY SCRIPT: " .. name
	btn.TextColor3 = Color3.fromRGB(255, 255, 255)
	btn.Font = Enum.Font.GothamBold
	btn.TextSize = 14
	btn.AutoButtonColor = true
	Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)

	btn.MouseButton1Click:Connect(function()
		pcall(function()
			loadstring(game:HttpGet(url))()
			game.StarterGui:SetCore("SendNotification", {
				Title = "✅ Thành công!",
				Text = name .. " đã được chạy!",
				Duration = 3
			})
		end)
	end)
end

-- ⚙️ Tab THÔNG TIN
local infoTab = tabPages["THÔNG TIN"]
local copyBtn = Instance.new("TextButton", infoTab)
copyBtn.Size = UDim2.new(1, -20, 0, 50)
copyBtn.Position = UDim2.new(0, 10, 0, 20)
copyBtn.BackgroundColor3 = Color3.fromRGB(88, 101, 242)
copyBtn.Text = "COPY LINK DISCORD"
copyBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
copyBtn.Font = Enum.Font.GothamBold
copyBtn.TextSize = 16
Instance.new("UICorner", copyBtn).CornerRadius = UDim.new(0, 8)

copyBtn.MouseButton1Click:Connect(function()
	setclipboard("https://discord.gg/Ed66pVng")
end)

local farmTab = tabPages["SCRIPT FARM"]

createScriptButton(farmTab, "TuanAnhIOS", "https://raw.githubusercontent.com/AnhTuanDzai-Hub/TuanAnhIOS/refs/heads/main/TuanAnhIOS.lua")
createScriptButton(farmTab, "banana", "https://raw.githubusercontent.com/LuaStupid/ExecuteGames/main/QuestGames.lua")
createScriptButton(farmTab, "speed", "https://raw.githubusercontent.com/AhmadV99/Speed-Hub-X/main/Speed%20Hub%20X.lua")
createScriptButton(farmTab, "vxeze", "https://pandadevelopment.net/virtual/file/e50b45018b39ad3e")
createScriptButton(farmTab, "fly", "https://raw.githubusercontent.com/TurboLite/Script/refs/heads/main/Fly.lua")
createScriptButton(farmTab, "redz", "https://raw.githubusercontent.com/tlredz/Scripts/refs/heads/main/main.luau")
createScriptButton(farmTab, "maru1", "https://raw.githubusercontent.com/LuaCrack/KimP/refs/heads/main/MaruHub")
createScriptButton(farmTab, "xero", "https://raw.githubusercontent.com/Xero2409/XeroHub/refs/heads/main/main.lua")
createScriptButton(farmTab, "banana2", "https://raw.githubusercontent.com/obiiyeuem/vthangsitink/main/BananaHub.lua")
createScriptButton(farmTab, "maru2", "https://raw.githubusercontent.com/xshiba/MaruBitkub/main/Mobile.lua")
createScriptButton(farmTab, "mince", "https://raw.githubusercontent.com/LuaCrack/Min/refs/heads/main/MinCE")
createScriptButton(farmTab, "trade scam", "https://raw.githubusercontent.com/Rabbb216/FreezeTradeScam/refs/heads/main/FreezeTradeScam.lua")
createScriptButton(farmTab, "hoho", "https://raw.githubusercontent.com/acsu123/HOHO_H/main/Loading_UI")
createScriptButton(farmTab, "sukuna", "https://raw.githubusercontent.com/pokelokbr/Dr.peste/main/sukunav9")
createScriptButton(farmTab, "zis", "https://raw.githubusercontent.com/LuaCrack/Zis/refs/heads/main/ZisRobloxHub")
createScriptButton(farmTab, "quantum", "https://raw.githubusercontent.com/Trustmenotcondom/QTONYX/refs/heads/main/QuantumOnyx.lua")
createScriptButton(farmTab, "ziner", "https://raw.githubusercontent.com/Tienvn123tkvn/Test/main/ZINERHUB.lua")
createScriptButton(farmTab, "hiru", "https://raw.githubusercontent.com/NGUYENVUDUY1/Dev-Hiru/refs/heads/main/HiruHub.lua")
createScriptButton(farmTab, "rubu", "https://raw.githubusercontent.com/LuaCrack/RubuRoblox/refs/heads/main/RubuBF")
createScriptButton(farmTab, "bapred", "https://raw.githubusercontent.com/LuaCrack/BapRed/main/BapRedHub")
createScriptButton(farmTab, "andepzai", "https://raw.githubusercontent.com/AnDepZaiHub/AnDepZaiHubBeta/refs/heads/main/AnDepZaiHubNewUpdated.lua")
createScriptButton(farmTab, "vocanol", "https://raw.githubusercontent.com/wpisstestfprg/Volcano/refs/heads/main/VolcanoLocal.lua")
createScriptButton(farmTab, "cokka", "https://raw.githubusercontent.com/UserDevEthical/Loadstring/main/CokkaHub.lua")
createScriptButton(farmTab, "mingaming", "https://raw.githubusercontent.com/MinGamingHubNew/RealMinGaming/refs/heads/main/MinGaminvHubBloxFruits.lua")

local fixlagTab = tabPages["SCRIPT FIXLAG"]
createScriptButton(fixlagTab, "Turbo FixLag", "https://raw.githubusercontent.com/TurboLite/Script/main/FixLag.lua")
local kaitunTab = tabPages["SCRIPT KAITUN"]
createScriptButton(kaitunTab, "kaitun royx", "https://api.realaya.xyz/v1/files/l/73mkp0aqyfo4ypy8hvl0nz10lq49fey5.lua")
createScriptButton(kaitunTab, "kaitun v1", "https://raw.githubusercontent.com/skibidip1/Hack/refs/heads/main/4ca1f2ace4cc1d14.txt")

local fruitTab = tabPages["SCRIPT NHẶT TRÁI"]
createScriptButton(fruitTab, "TuanAnhFruit", "https://raw.githubusercontent.com/AnhTuanDzai-Hub/AutoFruitDepzai/refs/heads/main/TuanAnhIOS-Find-Fruit.Lua")

local aimbotTab = tabPages["SCRIPT AIMBOT"]
createScriptButton(aimbotTab, "TuanAnhAimbot", "https://raw.githubusercontent.com/AnhTuanDzai-Hub/AimBotSkibidi/refs/heads/main/TuanAnhIOS-AIMBOT.Lua")

local tonghopTab = tabPages["SCRIPT TỔNG HỢP"]
createScriptButton(tonghopTab, "nghia11n", "https://raw.githubusercontent.com/Nghia11n/VIP/main/allscript.lua")
createScriptButton(tonghopTab, "TuanAnhIOS tổng", "https://raw.githubusercontent.com/AnhDzaiScript/TuanAnhIOSNew/refs/heads/main/TuanAnhIOS-TongHop.Lua")
createScriptButton(tonghopTab, "scriptTongHop", "https://isnahamzahpastebin.tech/loader/isna_scripthub_30")
createScriptButton(tonghopTab, "stuckez", "https://raw.githubusercontent.com/stuckez999/main/refs/heads/main/tonghoproblox.lua")

local growTab = tabPages["GROW A GARDEN"]
createScriptButton(growTab, "NoLag", "https://raw.githubusercontent.com/NoLag-id/No-Lag-HUB/refs/heads/main/Loader/LoaderV1.lua")
createScriptButton(growTab, "Lion", "https://raw.githubusercontent.com/Dev-BlueX/BlueX-Hub/refs/heads/main/Main.lua")
createScriptButton(growTab, "Kenniel", "https://raw.githubusercontent.com/Kenniel123/Grow-a-garden/refs/heads/main/Grow%20A%20Garden")
createScriptButton(growTab, "Thunder", "https://raw.githubusercontent.com/ThundarZ/Welcome/refs/heads/main/Main/GaG/Main.lua")
createScriptButton(growTab, "Stock", "https://pastebin.com/raw/90r2yXNi")
createScriptButton(growTab, "Money", "https://raw.githubusercontent.com/Bern0va/Scripts/refs/heads/main/gag-dupe.lua")
createScriptButton(growTab, "Blue", "https://raw.githubusercontent.com/tesghg/Grow-a-Garden/main/ameicaa_Grow_A_Garden.lua")
createScriptButton(growTab, "Nathub", "https://get.nathub.xyz/loader")
createScriptButton(growTab, "Kaitun GrowA", "https://api.luarmor.net/files/v3/loaders/a95faa4e81c4b5ae6a1ebb3a853debe0.lua")
