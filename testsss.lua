
repeat wait() until game:IsLoaded()

-- 📦 Dịch vụ
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local Lighting = game:GetService("Lighting")
local player = Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()

-- 📁 Tạo giao diện chính
local gui = Instance.new("ScreenGui", CoreGui)
gui.Name = "PhucMaxHub"
gui.ResetOnSpawn = false

-- 🔘 Nút logo
local logo = Instance.new("ImageButton", gui)
logo.Size = UDim2.new(0, 60, 0, 60)
logo.Position = UDim2.new(0, 10, 0.4, 0)
logo.Image = "rbxassetid://96060225144044"
logo.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
logo.Draggable = true
Instance.new("UICorner", logo).CornerRadius = UDim.new(0, 14)

-- 📦 Main Menu
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

-- 🧱 Layout
local UIGrid = Instance.new("UIGridLayout", main)
UIGrid.CellSize = UDim2.new(0, 170, 0, 40)
UIGrid.CellPadding = UDim2.new(0, 10, 0, 10)
UIGrid.FillDirectionMaxCells = 3
UIGrid.SortOrder = Enum.SortOrder.LayoutOrder
UIGrid.HorizontalAlignment = Enum.HorizontalAlignment.Center
UIGrid.VerticalAlignment = Enum.VerticalAlignment.Top

-- 🔘 Tạo Toggle Button
function createButton(text, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 170, 0, 40)
    btn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 14
    local state = false
    btn.MouseButton1Click:Connect(function()
        state = not state
        btn.BackgroundColor3 = state and Color3.fromRGB(0, 170, 127) or Color3.fromRGB(40, 40, 40)
        callback(state)
    end)
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
    btn.Parent = main
end

-- 🧠 Các chức năng
createButton("Bất tử", function(on)
    local humanoid = char:FindFirstChildOfClass("Humanoid")

    if on and humanoid then
        -- Set máu vĩnh viễn
        humanoid.Name = "GodHumanoid"
        humanoid.Health = math.huge
        humanoid.MaxHealth = math.huge

        -- Xóa thanh máu
        local head = char:FindFirstChild("Head")
        if head and head:FindFirstChild("HealthDisplayDistance") then
            head:FindFirstChild("HealthDisplayDistance"):Destroy()
        end

        -- Vòng lặp giữ máu = vô hạn
        spawn(function()
            while on and humanoid and humanoid.Parent do
                if humanoid.Health < math.huge then
                    humanoid.Health = math.huge
                end
                wait(0.1)
            end
        end)

        -- Miễn nhiễm ragdoll
        humanoid.PlatformStand = false
        humanoid:GetPropertyChangedSignal("PlatformStand"):Connect(function()
            if on and humanoid.PlatformStand then
                humanoid.PlatformStand = false
            end
        end)
    else
        -- Tắt GodMode
        if humanoid then
            humanoid.Name = "Humanoid"
            humanoid.MaxHealth = 100
            humanoid.Health = 100
        end
    end
end)

createButton("Chống té ngã", function(on)
    local humanoid = char:FindFirstChildOfClass("Humanoid")
    if on and humanoid then
        humanoid.PlatformStand = false
        humanoid:GetPropertyChangedSignal("PlatformStand"):Connect(function()
            if humanoid.PlatformStand then
                humanoid.PlatformStand = false
            end
        end)
    end
end)

createButton("ESP căn cứ", function(on)
    for _, v in pairs(workspace:GetDescendants()) do
        if v:IsA("Model") and v:FindFirstChild("Base") then
            if on then
                -- Highlight
                if not v:FindFirstChild("ESPPlot") then
                    local highlight = Instance.new("Highlight", v)
                    highlight.Name = "ESPPlot"
                    highlight.FillColor = Color3.fromRGB(0, 255, 0)
                end

                -- Billboard
                if not v:FindFirstChild("ESPLabel") then
                    local billboard = Instance.new("BillboardGui", v)
                    billboard.Name = "ESPLabel"
                    billboard.Size = UDim2.new(0, 200, 0, 50)
                    billboard.Adornee = v:FindFirstChild("Base")
                    billboard.AlwaysOnTop = true

                    local label = Instance.new("TextLabel", billboard)
                    label.Size = UDim2.new(1, 0, 1, 0)
                    label.BackgroundTransparency = 1
                    label.TextColor3 = Color3.fromRGB(255, 255, 255)
                    label.TextScaled = true
                    label.Font = Enum.Font.GothamBold
                    label.Name = "Label"

                    -- Cập nhật text liên tục
                    task.spawn(function()
                        while billboard and billboard.Parent and on do
                            local isOpen = v:FindFirstChild("IsOpen") and v.IsOpen.Value
                            local timeLeft = v:FindFirstChild("OpenTimeRemaining") and math.floor(v.OpenTimeRemaining.Value) or 0
                            local owner = v:FindFirstChild("Owner") and v.Owner.Value or "Không rõ"

                            label.Text = isOpen and ("Nhà mở (" .. timeLeft .. "s)") or owner
                            task.wait(1)
                        end
                    end)
                end
            else
                if v:FindFirstChild("ESPPlot") then v.ESPPlot:Destroy() end
                if v:FindFirstChild("ESPLabel") then v.ESPLabel:Destroy() end
            end
        end
    end
end)

createButton("esp người chơi", function(on)
    for _, plr in pairs(Players:GetPlayers()) do
        if plr ~= player and plr.Character then
            if on then
                local highlight = Instance.new("Highlight", plr.Character)
                highlight.Name = "ESPPlayer"
                highlight.FillColor = Color3.fromRGB(255, 0, 0)
            else
                if plr.Character:FindFirstChild("ESPPlayer") then
                    plr.Character.ESPPlayer:Destroy()
                end
            end
        end
    end
end)

createButton("Tăng sức bật", function(on)
    local humanoid = char:FindFirstChildOfClass("Humanoid")
    if humanoid then
        humanoid.UseJumpPower = false
        humanoid.JumpHeight = on and 80 or 7.2  -- 80 là cao vừa, không gây lỗi
    end
end)

createButton("Nhảy không giới hạn", function(on)
    local UIS = game:GetService("UserInputService")
    local debounce = false
    if on then
        _G.InfJump = true
        UIS.JumpRequest:Connect(function()
            if _G.InfJump and not debounce then
                local humanoid = player.Character and player.Character:FindFirstChildOfClass("Humanoid")
                if humanoid and humanoid:GetState() ~= Enum.HumanoidStateType.Freefall then
                    debounce = true
                    humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
                    wait(0.25) -- cooldown để tránh spam
                    debounce = false
                end
            end
        end)
    else
        _G.InfJump = false
    end
end)

createButton("Thông báo khi mở khóa", function(on)
    if on then
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "Mở khóa";
            Text = "Bạn vừa mở được 1 thứ!";
            Duration = 3;
        })
    end
end)

createButton("Hiện nút cướp não", function(on)
    if on then
        print("Bật nút cướp não")
    end
end)

createButton("Hiện nút về căn cứ", function(on)
    if on then
        print("Bật nút đi về căn cứ")
    end
end)

createButton("Tàng hình", function(on)
    for _, part in pairs(char:GetDescendants()) do
        if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
            part.Transparency = on and 1 or 0
        end
    end
end)
