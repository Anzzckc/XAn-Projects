-- ===== ESP STANDALONE [IY] =====
-- Refactored by Xuan An

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

local CoreGui = game:GetService("CoreGui")
if not CoreGui or not CoreGui:IsA("CoreGui") then
    CoreGui = LocalPlayer:FindFirstChildWhichIsA("PlayerGui")
end

local ESP_Enabled = false
local ESP_Transparency = 0.3

local function round(num, decimal)
    local mult = 10^(decimal or 0)
    return math.floor(num * mult + 0.5) / mult
end

local function getRoot(char)
    if char and char:FindFirstChildOfClass("Humanoid") then
        return char:FindFirstChildOfClass("Humanoid").RootPart
    end
    return nil
end

function CreateESP(plr, teamMode)
    task.spawn(function()
        for _, v in pairs(CoreGui:GetChildren()) do
            if v.Name == plr.Name.."_ESP" then
                v:Destroy()
            end
        end
        wait()
        
        if plr.Name == LocalPlayer.Name then return end
        if CoreGui:FindFirstChild(plr.Name.."_ESP") then return end
        
        local holder = Instance.new("Folder")
        holder.Name = plr.Name.."_ESP"
        holder.Parent = CoreGui
        
        local function CreateBoxes(character)
            if not character then return end
            for _, child in pairs(holder:GetChildren()) do
                if child:IsA("BoxHandleAdornment") then
                    child:Destroy()
                end
            end
            for _, part in pairs(character:GetChildren()) do
                if part:IsA("BasePart") then
                    local box = Instance.new("BoxHandleAdornment")
                    box.Name = plr.Name
                    box.Parent = holder
                    box.Adornee = part
                    box.AlwaysOnTop = true
                    box.ZIndex = 10
                    box.Size = part.Size
                    box.Transparency = ESP_Transparency
                    if teamMode then
                        box.Color = BrickColor.new(plr.TeamColor == LocalPlayer.TeamColor and "Bright green" or "Bright red")
                    else
                        box.Color = plr.TeamColor
                    end
                end
            end
        end
        
        local function CreateBillboard(character)
            for _, child in pairs(holder:GetChildren()) do
                if child:IsA("BillboardGui") then
                    child:Destroy()
                end
            end
            if not character or not character:FindFirstChild("Head") then
                return
            end
            local bill = Instance.new("BillboardGui")
            local text = Instance.new("TextLabel")
            bill.Adornee = character.Head
            bill.Name = plr.Name
            bill.Parent = holder
            bill.Size = UDim2.new(0, 100, 0, 150)
            bill.StudsOffset = Vector3.new(0, 1, 0)
            bill.AlwaysOnTop = true
            text.Parent = bill
            text.BackgroundTransparency = 1
            text.Position = UDim2.new(0, 0, 0, -50)
            text.Size = UDim2.new(0, 100, 0, 100)
            text.Font = Enum.Font.SourceSansSemibold
            text.TextSize = 20
            text.TextColor3 = Color3.new(1, 1, 1)
            text.TextStrokeTransparency = 0
            text.TextYAlignment = Enum.TextYAlignment.Bottom
            
            task.spawn(function()
                while bill and bill.Parent and ESP_Enabled do
                    if plr.Character and getRoot(plr.Character) and LocalPlayer.Character and getRoot(LocalPlayer.Character) then
                        local dist = math.floor((getRoot(LocalPlayer.Character).Position - getRoot(plr.Character).Position).magnitude)
                        local hum = plr.Character:FindFirstChildOfClass("Humanoid")
                        if hum then
                            text.Text = "Name: "..plr.Name.." | Health: "..round(hum.Health, 1).." | Studs: "..dist
                        else
                            text.Text = "Name: "..plr.Name
                        end
                    else
                        text.Text = "Name: "..plr.Name
                    end
                    task.wait(0.1)
                end
            end)
        end
        
        local function FullRefresh()
            if not ESP_Enabled then return end
            local char = plr.Character
            if char and getRoot(char) and char:FindFirstChildOfClass("Humanoid") then
                pcall(function()
                    CreateBoxes(char)
                    CreateBillboard(char)
                end)
            end
        end
        
        local refreshThread = task.spawn(function()
            while holder and holder.Parent and ESP_Enabled do
                task.wait(1)
                pcall(FullRefresh)
            end
        end)
        
        plr.CharacterAdded:Connect(function(char)
            task.wait(0.3)
            pcall(function()
                CreateBoxes(char)
                CreateBillboard(char)
            end)
        end)
        
        plr:GetPropertyChangedSignal("TeamColor"):Connect(function()
            pcall(FullRefresh)
        end)
        
        if plr.Character then
            task.wait(0.3)
            pcall(function()
                CreateBoxes(plr.Character)
                CreateBillboard(plr.Character)
            end)
        end
        
        local function Cleanup()
            if refreshThread then task.cancel(refreshThread) end
            pcall(function() holder:Destroy() end)
        end
        Players.PlayerRemoving:Connect(function(p)
            if p == plr then Cleanup() end
        end)
    end)
end

function EnableESP()
    if ESP_Enabled then return end
    ESP_Enabled = true
    for _, plr in pairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer then
            CreateESP(plr)
        end
    end
end

function EnableESPTeam()
    if ESP_Enabled then return end
    ESP_Enabled = true
    for _, plr in pairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer then
            CreateESP(plr, true)
        end
    end
end

function DisableESP()
    ESP_Enabled = false
    for _, v in pairs(CoreGui:GetChildren()) do
        if string.sub(v.Name, -4) == "_ESP" then
            v:Destroy()
        end
    end
end

Players.PlayerAdded:Connect(function(plr)
    if ESP_Enabled then
        CreateESP(plr)
    end
end)
