repeat wait() until game:IsLoaded()

-- ✅ Auto vào Hải Quân
pcall(function()
    game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("SetTeam", "Marines")
end)

-- ✅ Thông báo khởi động
pcall(function()
    game.StarterGui:SetCore("SendNotification", {
        Title = "phucmaxnhattrai",
        Text = "✅ Lần đầu mình làm, nếu lỗi báo ad nha",
        Duration = 6
    })
end)

-- ✅ Danh sách trái lưu
local fruitList = {
    ["Rocket Fruit"] = "Rocket-Rocket", ["Spin Fruit"] = "Spin-Spin", ["Chop Fruit"] = "Chop-Chop",
    ["Spring Fruit"] = "Spring-Spring", ["Bomb Fruit"] = "Bomb-Bomb", ["Smoke Fruit"] = "Smoke-Smoke",
    ["Spike Fruit"] = "Spike-Spike", ["Flame Fruit"] = "Flame-Flame", ["Eagle Fruit"] = "Eagle-Eagle",
    ["Ice Fruit"] = "Ice-Ice", ["Sand Fruit"] = "Sand-Sand", ["Dark Fruit"] = "Dark-Dark",
    ["Diamond Fruit"] = "Diamond-Diamond", ["Light Fruit"] = "Light-Light", ["Rubber Fruit"] = "Rubber-Rubber",
    ["Creation Fruit"] = "Creation-Creation", ["Ghost Fruit"] = "Ghost-Ghost", ["Magma Fruit"] = "Magma-Magma",
    ["Quake Fruit"] = "Quake-Quake", ["Buddha Fruit"] = "Buddha", ["Love Fruit"] = "Love-Love",
    ["Spider Fruit"] = "Spider-Spider", ["Sound Fruit"] = "Sound-Sound", ["Phoenix Fruit"] = "Phoenix",
    ["Portal Fruit"] = "Door-Door", ["Rumble Fruit"] = "Rumble-Rumble", ["Pain Fruit"] = "Pain-Pain",
    ["Blizzard Fruit"] = "Blizzard-Blizzard", ["Gravity Fruit"] = "Gravity-Gravity", ["Mammoth Fruit"] = "Mammoth",
    ["T-Rex Fruit"] = "T-Rex", ["Dough Fruit"] = "Dough-Dough", ["Shadow Fruit"] = "Shadow-Shadow",
    ["Venom Fruit"] = "Venom-Venom", ["Control Fruit"] = "Control-Control", ["Spirit Fruit"] = "Soul-Soul",
    ["Dragon Fruit"] = "Dragon-Dragon", ["Leopard Fruit"] = "Leopard-Leopard", ["Kitsune Fruit"] = "Kitsune-Kitsune"
}

-- ✅ ESP Trái
local espFolder = Instance.new("Folder", game.CoreGui)
espFolder.Name = "FruitESP"

function addESP(obj)
    if obj:IsA("Tool") and obj:FindFirstChild("Handle") and obj.Name:lower():find("fruit") and not espFolder:FindFirstChild("ESP_"..obj.Name) then
        local gui = Instance.new("BillboardGui", espFolder)
        gui.Name = "ESP_"..obj.Name
        gui.Adornee = obj.Handle
        gui.Size = UDim2.new(0, 120, 0, 40)
        gui.AlwaysOnTop = true

        local label = Instance.new("TextLabel", gui)
        label.Size = UDim2.new(1, 0, 1, 0)
        label.BackgroundTransparency = 1
        label.Text = obj.Name .. " (" .. math.floor((game.Players.LocalPlayer.Character.HumanoidRootPart.Position - obj.Handle.Position).Magnitude) .. "m)"
        label.TextColor3 = Color3.fromRGB(255, 170, 0)
        label.TextStrokeTransparency = 0
        label.Font = Enum.Font.GothamBold
        label.TextScaled = true
    end
end

-- ✅ Tìm trái gần nhất
function getNearestFruit()
    local closest, dist = nil, math.huge
    for _, obj in pairs(game.Workspace:GetChildren()) do
        if obj:IsA("Tool") and obj:FindFirstChild("Handle") and obj.Name:lower():find("fruit") then
            local mag = (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - obj.Handle.Position).Magnitude
            if mag < dist then
                closest, dist = obj, mag
            end
        end
    end
    return closest
end

-- ✅ Bay mượt đến trái
local flying = false
local fruitTarget = nil

function flyToFruitSmooth(fruitPos)
    local hrp = game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not hrp then return end

    if hrp:FindFirstChild("FruitFly") then
        hrp.FruitFly:Destroy()
    end

    local bv = Instance.new("BodyVelocity")
    bv.Name = "FruitFly"
    bv.MaxForce = Vector3.new(1e9, 1e9, 1e9)
    bv.Velocity = Vector3.zero
    bv.P = 300
    bv.Parent = hrp

    flying = true
    spawn(function()
        while flying and fruitTarget and fruitTarget:FindFirstChild("Handle") do
            local dir = (fruitTarget.Handle.Position + Vector3.new(0, 20, 0) - hrp.Position)
            local dist = dir.Magnitude
            if dist < 5 then
                flying = false
                break
            end
            bv.Velocity = dir.Unit * 300
            wait()
        end
        if bv and bv.Parent then bv:Destroy() end
    end)
end

-- ✅ Bay + ESP liên tục
spawn(function()
    while wait(0.5) do
        for _, obj in pairs(game.Workspace:GetChildren()) do
            addESP(obj)
        end
        local fruit = getNearestFruit()
        if fruit and fruit:FindFirstChild("Handle") then
            fruitTarget = fruit
            flyToFruitSmooth(fruit.Handle.Position)
        end
    end
end)

-- ✅ Auto lưu vào kho
spawn(function()
    while wait(1) do
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

-- ✅ Auto hop server
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

-- ✅ Kiểm tra đứng yên hoặc không có trái thì hop
spawn(function()
    local lastPos = nil
    local idleTime = 0
    while wait(1) do
        local hrp = game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if hrp then
            if lastPos and (hrp.Position - lastPos).Magnitude < 1 then
                idleTime += 1
            else
                idleTime = 0
            end
            lastPos = hrp.Position

            if idleTime >= 5 or not getNearestFruit() then
                HopServer()
            end
        end
    end
end)

-- ✅ Logo + FPS
local idLogo = "rbxassetid://123394707028201"
local RunService = game:GetService("RunService")

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
    local frameCount = 0
    local lastTime = tick()
    while true do
        RunService.RenderStepped:Wait()
        frameCount += 1
        if tick() - lastTime >= 1 then
            fpsLabel.Text = "FPS: " .. tostring(frameCount)
            frameCount = 0
            lastTime = tick()
        end
    end
end)
