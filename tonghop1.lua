-- Tạo vùng scroll để chứa tất cả nút trong farm tab
local farmTab = tabPages["SCRIPT FARM"]

local scrollFrame = Instance.new("ScrollingFrame", farmTab)
scrollFrame.Size = UDim2.new(1, 0, 1, 0)
scrollFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
scrollFrame.ScrollBarThickness = 4
scrollFrame.BackgroundTransparency = 1
scrollFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
scrollFrame.CanvasPosition = Vector2.new(0, 0)
scrollFrame.ScrollingDirection = Enum.ScrollingDirection.Y

local UIListLayout = Instance.new("UIListLayout", scrollFrame)
UIListLayout.Padding = UDim.new(0, 6)
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder

local function createScriptButton(parent, name, url)
	local btn = Instance.new("TextButton", parent)
	btn.Size = UDim2.new(1, -10, 0, 40)
	btn.BackgroundColor3 = Color3.fromRGB(20, 20, 20) -- Đen đậm
	btn.Text = "CHẠY SCRIPT: " .. name
	btn.TextColor3 = Color3.fromRGB(255, 255, 255)
	btn.Font = Enum.Font.Gotham
	btn.TextSize = 14
	btn.AutoButtonColor = true
	Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)

	btn.MouseButton1Click:Connect(function()
		loadstring(game:HttpGet(url))()
		pcall(function()
			game.StarterGui:SetCore("SendNotification", {
				Title = "✅ Đã chạy!",
				Text = "Script '" .. name .. "' đã được chạy!",
				Duration = 4,
				Icon = "rbxassetid://96060225144044"
			})
		end)
	end)
end

-- Tạo các nút script trong farmTab (KHÔNG TRÙNG, KHÔNG THIẾU)
local scripts = {
	{"tuananhios", "https://raw.githubusercontent.com/AnhTuanDzai-Hub/TuanAnhIOS/refs/heads/main/TuanAnhIOS.lua"},
	{"banana", "https://raw.githubusercontent.com/LuaStupid/ExecuteGames/main/QuestGames.lua"},
	{"speed", "https://raw.githubusercontent.com/AhmadV99/Speed-Hub-X/main/Speed%20Hub%20X.lua"},
	{"vxeze", "https://pandadevelopment.net/virtual/file/e50b45018b39ad3e"},
	{"fly", "https://raw.githubusercontent.com/TurboLite/Script/refs/heads/main/Fly.lua"},
	{"redz", "https://raw.githubusercontent.com/tlredz/Scripts/refs/heads/main/main.luau"},
	{"maru1", "https://raw.githubusercontent.com/LuaCrack/KimP/refs/heads/main/MaruHub"},
	{"xero", "https://raw.githubusercontent.com/Xero2409/XeroHub/refs/heads/main/main.lua"},
	{"banana2", "https://raw.githubusercontent.com/obiiyeuem/vthangsitink/main/BananaHub.lua"},
	{"maru2", "https://raw.githubusercontent.com/xshiba/MaruBitkub/main/Mobile.lua"},
	{"minCE", "https://raw.githubusercontent.com/LuaCrack/Min/refs/heads/main/MinCE"},
	{"trade scam", "https://raw.githubusercontent.com/Rabbb216/FreezeTradeScam/refs/heads/main/FreezeTradeScam.lua"},
	{"hoho", "https://raw.githubusercontent.com/acsu123/HOHO_H/main/Loading_UI"},
	{"sukuna", "https://raw.githubusercontent.com/pokelokbr/Dr.peste/main/sukunav9"},
	{"zis", "https://raw.githubusercontent.com/LuaCrack/Zis/refs/heads/main/ZisRobloxHub"},
	{"quantum", "https://raw.githubusercontent.com/Trustmenotcondom/QTONYX/refs/heads/main/QuantumOnyx.lua"},
	{"ziner", "https://raw.githubusercontent.com/Tienvn123tkvn/Test/main/ZINERHUB.lua"},
	{"hiru", "https://raw.githubusercontent.com/NGUYENVUDUY1/Dev-Hiru/refs/heads/main/HiruHub.lua"},
	{"rubu", "https://raw.githubusercontent.com/LuaCrack/RubuRoblox/refs/heads/main/RubuBF"},
	{"bapred", "https://raw.githubusercontent.com/LuaCrack/BapRed/main/BapRedHub"},
	{"andepzai", "https://raw.githubusercontent.com/AnDepZaiHub/AnDepZaiHubBeta/refs/heads/main/AnDepZaiHubNewUpdated.lua"},
	{"vocanol", "https://raw.githubusercontent.com/wpisstestfprg/Volcano/refs/heads/main/VolcanoLocal.lua"},
	{"Cokka", "https://raw.githubusercontent.com/UserDevEthical/Loadstring/main/CokkaHub.lua"},
	{"minGamin", "https://raw.githubusercontent.com/MinGamingHubNew/RealMinGaming/refs/heads/main/MinGaminvHubBloxFruits.lua"}
}

for _, s in ipairs(scripts) do
	createScriptButton(scrollFrame, s[1], s[2])
end
