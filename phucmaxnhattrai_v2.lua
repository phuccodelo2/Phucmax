repeat wait() until game:IsLoaded()

-- Auto vào Hải Quân
pcall(function()
    game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("SetTeam", "Marines")
end)

-- Gửi thông báo khởi động
pcall(function()
    game.StarterGui:SetCore("SendNotification", {
        Title = "phucmaxnhattrai",
        Text = "✅ Script khởi động thành công!",
        Duration = 6
    })
end)

-- Danh sách trái cần lưu
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

-- ESP trái
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
        label.Text = obj.Name
        label.TextColor3 = Color3.fromRGB(255, 170, 0)
        label.TextStrokeTransparency = 0
        label.Font = Enum.Font.GothamBold
        label.TextScaled = true
    end
end

-- Tìm trái gần nhất
function getNearestFruit()
    local closest, dist = nil, math.huge
    for _, obj in pairs(workspace:GetDescendants()) do
        if obj:IsA("Tool") and obj:FindFirstChild("Handle") and obj.Name:lower():find("fruit") then
            local mag = (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - obj.Handle.Position).Magnitude
            if mag < dist then
                closest, dist = obj, mag
            end
        end
    end
    return closest
end

-- Bay xuyên vật thể (noclip)
local flying = false
local fruitTarget = nil
function flyToFruitStraight(pos)
    local char = game.Players.LocalPlayer.Character
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end

    -- Bật noclip
    local noclipConn = game:GetService("RunService").Stepped:Connect(function()
        for _, v in pairs(char:GetDescendants()) do
            if v:IsA("BasePart") then
                v.CanCollide = false
            end
        end
    end)

    local bv = Instance.new("BodyVelocity", hrp)
    bv.Name = "FruitFly"
    bv.MaxForce = Vector3.new(1e9, 1e9, 1e9)
    bv.Velocity = Vector3.zero

    flying = true
    spawn(function()
        while flying and fruitTarget and fruitTarget:FindFirstChild("Handle") do
            local dir = (fruitTarget.Handle.Position - hrp.Position)
            if dir.Magnitude < 5 then flying = false break end
            bv.Velocity = dir.Unit * 300
            wait()
        end
        bv:Destroy()
        noclipConn:Disconnect()
    end)
end

-- Quét trái + bay đến
spawn(function()
    while wait(0.5) do
        for _, obj in pairs(workspace:GetDescendants()) do addESP(obj) end
        local fruit = getNearestFruit()
        if fruit and fruit:FindFirstChild("Handle") then
            fruitTarget = fruit
            flyToFruitStraight(fruit.Handle.Position)
        end
    end
end)

-- Lưu trái
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

-- Auto hop server nếu không còn trái
function HopServer()
    local HttpService = game:GetService("HttpService")
    local TeleportService = game:GetService("TeleportService")
    local PlaceId = game.PlaceId
    local url = "https://games.roblox.com/v1/games/"..PlaceId.."/servers/Public?sortOrder=Asc&limit=100"
    local servers = HttpService:JSONDecode(game:HttpGet(url)).data
    for _, s in pairs(servers) do
        if s.playing < s.maxPlayers and s.id ~= game.JobId then
            TeleportService:TeleportToPlaceInstance(PlaceId, s.id, game.Players.LocalPlayer)
            break
        end
    end
end

-- Đổi server nếu không còn trái
spawn(function()
    while wait(5) do
        if not getNearestFruit() then
            HopServer()
        end
    end
end)
