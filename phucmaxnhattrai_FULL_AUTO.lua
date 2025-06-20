repeat wait() until game:IsLoaded()

-- Vào Marines
pcall(function()
    game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("SetTeam", "Marines")
end)

-- Thông báo khởi động
pcall(function()
    game.StarterGui:SetCore("SendNotification", {
        Title = "phucmaxnhattrai",
        Text = "✅ Đã khởi động script thành công!",
        Duration = 6
    })
end)

-- Danh sách fruit cần lưu
local fruitList = {
    ["Bomb Fruit"] = "Bomb-Bomb", ["Spike Fruit"] = "Spike-Spike", ["Chop Fruit"] = "Chop-Chop",
    ["Spring Fruit"] = "Spring-Spring", ["Kilo Fruit"] = "Rocket-Rocket", ["Smoke Fruit"] = "Smoke-Smoke",
    ["Spin Fruit"] = "Spin-Spin", ["Flame Fruit"] = "Flame-Flame", ["Falcon Fruit"] = "Falcon",
    ["Ice Fruit"] = "Ice-Ice", ["Sand Fruit"] = "Sand-Sand", ["Dark Fruit"] = "Dark-Dark",
    ["Revive Fruit"] = "Ghost-Ghost", ["Diamond Fruit"] = "Diamond-Diamond", ["Light Fruit"] = "Light-Light",
    ["Love Fruit"] = "Love-Love", ["Rubber Fruit"] = "Rubber-Rubber", ["Barrier Fruit"] = "Barrier-Barrier",
    ["Magma Fruit"] = "Magma-Magma", ["Portal Fruit"] = "Door-Door", ["Quake Fruit"] = "Quake-Quake",
    ["Buddha Fruit"] = "Buddha", ["Spider Fruit"] = "Spider-Spider", ["Phoenix Fruit"] = "Phoenix",
    ["Rumble Fruit"] = "Rumble-Rumble", ["Pain Fruit"] = "Pain-Pain", ["Gravity Fruit"] = "Gravity-Gravity",
    ["Dough Fruit"] = "Dough-Dough", ["Shadow Fruit"] = "Shadow-Shadow", ["Venom Fruit"] = "Venom-Venom",
    ["Control Fruit"] = "Control-Control", ["Spirit Fruit"] = "Soul-Soul", ["Dragon Fruit"] = "Dragon-Dragon",
    ["Leopard Fruit"] = "Leopard-Leopard"
}

-- ESP
local espFolder = Instance.new("Folder", game.CoreGui)
espFolder.Name = "FruitESP"

function addESP(obj)
    if obj:IsA("Tool") and obj:FindFirstChild("Handle") and string.find(obj.Name:lower(), "fruit") and not espFolder:FindFirstChild("ESP_"..obj.Name) then
        local gui = Instance.new("BillboardGui", espFolder)
        gui.Name = "ESP_"..obj.Name
        gui.Adornee = obj.Handle
        gui.Size = UDim2.new(0, 100, 0, 40)
        gui.AlwaysOnTop = true
        local label = Instance.new("TextLabel", gui)
        label.Size = UDim2.new(1, 0, 1, 0)
        label.BackgroundTransparency = 1
        label.Text = obj.Name
        label.TextColor3 = Color3.fromRGB(255, 85, 0)
        label.TextStrokeTransparency = 0
        label.Font = Enum.Font.GothamBold
        label.TextSize = 16
    end
end

-- ESP liên tục
spawn(function()
    while wait(0.5) do
        for _, obj in pairs(game.Workspace:GetChildren()) do
            addESP(obj)
        end
    end
end)

-- Lưu trái
spawn(function()
    while wait(1.5) do
        pcall(function()
            local plr = game.Players.LocalPlayer
            for name, id in pairs(fruitList) do
                local fruit = plr.Character:FindFirstChild(name) or plr.Backpack:FindFirstChild(name)
                if fruit then
                    game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("StoreFruit", id, fruit)
                end
            end
        end)
    end
end)

-- Tự bay đến fruit (không tele)
spawn(function()
    local speed = 300
    local ts = game:GetService("TweenService")
    while wait(0.5) do
        for _, v in pairs(game.Workspace:GetChildren()) do
            if v:IsA("Tool") and v:FindFirstChild("Handle") and string.find(v.Name:lower(), "fruit") then
                local hrp = game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                if hrp then
                    local dist = (hrp.Position - v.Handle.Position).magnitude
                    local time = dist / speed
                    local tween = ts:Create(hrp, TweenInfo.new(time, Enum.EasingStyle.Linear), {CFrame = v.Handle.CFrame + Vector3.new(0, 4, 0)})
                    tween:Play()
                    tween.Completed:Wait()
                    wait(0.1)
                    firetouchinterest(hrp, v.Handle, 0)
                    wait(0.1)
                    firetouchinterest(hrp, v.Handle, 1)
                end
            end
        end
    end
end)

-- Tự đổi server nếu đứng yên > 5s
local lastPos = nil
local idleTime = 0

spawn(function()
    while wait(1) do
        local hrp = game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if hrp then
            if lastPos and (hrp.Position - lastPos).magnitude < 1 then
                idleTime = idleTime + 1
            else
                idleTime = 0
                lastPos = hrp.Position
            end
            if idleTime >= 5 then
                game.StarterGui:SetCore("SendNotification", {
                    Title = "phucmaxnhattrai",
                    Text = "⏱ Đứng yên quá lâu, đang chuyển server...",
                    Duration = 5
                })
                wait(1)
                HopServer()
            end
        end
    end
end)

-- Kiểm tra trái
function HasFruit()
    for _, v in pairs(game.Workspace:GetChildren()) do
        if v:IsA("Tool") and v:FindFirstChild("Handle") and string.find(v.Name:lower(), "fruit") then
            return true
        end
    end
    return false
end

-- Auto hop server (ít người)
function HopServer()
    local HttpService = game:GetService("HttpService")
    local TeleportService = game:GetService("TeleportService")
    local PlaceId = game.PlaceId
    local url = "https://games.roblox.com/v1/games/"..PlaceId.."/servers/Public?sortOrder=Asc&limit=100"
    local servers = HttpService:JSONDecode(game:HttpGet(url)).data
    table.sort(servers, function(a, b) return a.playing < b.playing end)
    for _, server in pairs(servers) do
        if server.playing < server.maxPlayers and server.id ~= game.JobId then
            TeleportService:TeleportToPlaceInstance(PlaceId, server.id, game.Players.LocalPlayer)
            break
        end
    end
end

-- UI + FPS + Logo
local idLogo = "rbxassetid://123394707028201"
local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
ScreenGui.Name = "phucmaxnhattraiUI"

local logoFrame = Instance.new("ImageLabel")
logoFrame.Name = "LogoFrame"
logoFrame.Parent = ScreenGui
logoFrame.AnchorPoint = Vector2.new(0.5, 0)
logoFrame.Position = UDim2.new(0.5, 0, 0.01, 0)
logoFrame.Size = UDim2.new(0, 220, 0, 80)
logoFrame.BackgroundTransparency = 1
logoFrame.Image = idLogo
logoFrame.ScaleType = Enum.ScaleType.Stretch

local stroke = Instance.new("UIStroke", logoFrame)
stroke.Thickness = 3
stroke.Color = Color3.fromRGB(255, 0, 0)
stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

spawn(function()
    local colors = {
        Color3.fromRGB(255, 0, 0),
        Color3.fromRGB(148, 0, 211),
        Color3.fromRGB(255, 255, 0)
    }
    while true do
        for _, color in ipairs(colors) do
            stroke.Color = color
            wait(0.5)
        end
    end
end)

local fpsLabel = Instance.new("TextLabel", ScreenGui)
fpsLabel.Name = "FPSCounter"
fpsLabel.Position = UDim2.new(0.01, 0, 0.01, 0)
fpsLabel.Size = UDim2.new(0, 100, 0, 30)
fpsLabel.BackgroundTransparency = 1
fpsLabel.TextColor3 = Color3.fromRGB(255, 0, 0)
fpsLabel.TextStrokeTransparency = 0
fpsLabel.TextSize = 20
fpsLabel.Font = Enum.Font.GothamBold
fpsLabel.Text = "FPS: ..."

spawn(function()
    local RunService = game:GetService("RunService")
    while wait(0.2) do
        local fps = math.floor(1 / RunService.RenderStepped:Wait())
        fpsLabel.Text = "FPS: " .. tostring(fps)
    end
end)
