-- TELEPORT MULTI-GAME
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")
local MarketplaceService = game:GetService("MarketplaceService")
local CoreGui = game:GetService("CoreGui")

local LocalPlayer = Players.LocalPlayer

local placeId = tostring(game.PlaceId)
local gameName = "Unknown Game ("..placeId..")"
pcall(function()
    local info = MarketplaceService:GetProductInfo(game.PlaceId)
    if info and info.Name then
        gameName = info.Name
    end
end)

local DATA_FILE_NAME = "saved_positions_"..placeId..".json"
local savedPositions = {}

local gui = Instance.new("ScreenGui")
gui.Name = "TeleportMultiGame"
gui.Parent = CoreGui
gui.ResetOnSpawn = false

local dragBtn = Instance.new("TextButton")
dragBtn.Size = UDim2.new(0, 80, 0, 30)
dragBtn.Position = UDim2.new(1, -84, 0, 60)
dragBtn.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
dragBtn.TextColor3 = Color3.new(1, 1, 1)
dragBtn.Text = "Position"
dragBtn.Font = Enum.Font.GothamBold
dragBtn.TextSize = 14
dragBtn.BorderSizePixel = 0
dragBtn.Active = true
dragBtn.Draggable = true
dragBtn.Parent = gui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 6)
corner.Parent = dragBtn

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 300, 0, 350)
mainFrame.Position = UDim2.new(0.5, -150, 0.5, -175)
mainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Visible = false
mainFrame.Parent = gui

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 30)
title.Text = "Teleport - "..gameName
title.TextColor3 = Color3.new(1, 1, 1)
title.Font = Enum.Font.GothamBold
title.TextSize = 16
title.BackgroundTransparency = 1
title.Parent = mainFrame

local scrollFrame = Instance.new("ScrollingFrame")
scrollFrame.Size = UDim2.new(1, -20, 0, 200)
scrollFrame.Position = UDim2.new(0, 10, 0, 40)
scrollFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
scrollFrame.BorderSizePixel = 0
scrollFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
scrollFrame.Parent = mainFrame

local posNameBox = Instance.new("TextBox")
posNameBox.Size = UDim2.new(0.65, -10, 0, 30)
posNameBox.Position = UDim2.new(0.05, 0, 1, -60)
posNameBox.PlaceholderText = "Position name"
posNameBox.Text = ""
posNameBox.TextColor3 = Color3.new(1, 1, 1)
posNameBox.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
posNameBox.Font = Enum.Font.Gotham
posNameBox.TextSize = 14
posNameBox.BorderSizePixel = 0
posNameBox.Parent = mainFrame

local saveBtn = Instance.new("TextButton")
saveBtn.Size = UDim2.new(0.25, 0, 0, 30)
saveBtn.Position = UDim2.new(0.7, 0, 1, -60)
saveBtn.Text = "Save (L)"
saveBtn.BackgroundColor3 = Color3.fromRGB(80, 180, 80)
saveBtn.TextColor3 = Color3.new(1, 1, 1)
saveBtn.Font = Enum.Font.GothamBold
saveBtn.TextSize = 14
saveBtn.BorderSizePixel = 0
saveBtn.Parent = mainFrame

local function saveToFile()
    local success, err = pcall(function()
        writefile(DATA_FILE_NAME, HttpService:JSONEncode(savedPositions))
    end)
    if success then
        warn("Saved positions to", DATA_FILE_NAME)
    else
        warn("Error saving:", err)
    end
end

local function loadFromFile()
    if isfile(DATA_FILE_NAME) then
        local data = readfile(DATA_FILE_NAME)
        local decoded = HttpService:JSONDecode(data)
        if typeof(decoded) == "table" then
            savedPositions = decoded
        end
    end
end

local function updateGUI()
    for _, child in ipairs(scrollFrame:GetChildren()) do
        if child:IsA("Frame") then child:Destroy() end
    end

    local y = 5
    for i, pos in ipairs(savedPositions) do
        local entry = Instance.new("Frame")
        entry.Size = UDim2.new(1, -10, 0, 30)
        entry.Position = UDim2.new(0, 5, 0, y)
        entry.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
        entry.Parent = scrollFrame

        local nameLabel = Instance.new("TextLabel")
        nameLabel.Size = UDim2.new(0.45, 0, 1, 0)
        nameLabel.Text = pos.name
        nameLabel.TextColor3 = Color3.new(1, 1, 1)
        nameLabel.Font = Enum.Font.Gotham
        nameLabel.TextSize = 14
        nameLabel.BackgroundTransparency = 1
        nameLabel.TextXAlignment = Enum.TextXAlignment.Left
        nameLabel.Parent = entry

        local tpBtn = Instance.new("TextButton")
        tpBtn.Size = UDim2.new(0.25, 0, 1, 0)
        tpBtn.Position = UDim2.new(0.5, 0, 0, 0)
        tpBtn.Text = "Teleport"
        tpBtn.BackgroundColor3 = Color3.fromRGB(70, 130, 200)
        tpBtn.TextColor3 = Color3.new(1, 1, 1)
        tpBtn.Font = Enum.Font.GothamBold
        tpBtn.TextSize = 14
        tpBtn.BorderSizePixel = 0
        tpBtn.Parent = entry

        tpBtn.MouseButton1Click:Connect(function()
            local char = LocalPlayer.Character
            if char and char:FindFirstChild("HumanoidRootPart") then
                char.HumanoidRootPart.CFrame = CFrame.new(Vector3.new(pos.x, pos.y, pos.z))
                warn("Teleported to:", pos.name)
            end
        end)

        local delBtn = Instance.new("TextButton")
        delBtn.Size = UDim2.new(0.25, 0, 1, 0)
        delBtn.Position = UDim2.new(0.75, 0, 0, 0)
        delBtn.Text = "Delete"
        delBtn.BackgroundColor3 = Color3.fromRGB(200, 70, 70)
        delBtn.TextColor3 = Color3.new(1, 1, 1)
        delBtn.Font = Enum.Font.GothamBold
        delBtn.TextSize = 14
        delBtn.BorderSizePixel = 0
        delBtn.Parent = entry

        delBtn.MouseButton1Click:Connect(function()
            table.remove(savedPositions, i)
            updateGUI()
            saveToFile()
        end)

        y = y + 35
    end

    scrollFrame.CanvasSize = UDim2.new(0, 0, 0, y)
end

local function savePosition()
    local char = LocalPlayer.Character
    if char and char:FindFirstChild("HumanoidRootPart") then
        local name = posNameBox.Text
        if name == "" then return end
        local pos = char.HumanoidRootPart.Position
        table.insert(savedPositions, {
            name = name,
            x = pos.X,
            y = pos.Y,
            z = pos.Z
        })
        setclipboard("Vector3.new("..pos.X..", "..pos.Y..", "..pos.Z..")")
        posNameBox.Text = ""
        updateGUI()
        saveToFile()
    end
end

dragBtn.MouseButton1Click:Connect(function()
    mainFrame.Visible = not mainFrame.Visible
end)

saveBtn.MouseButton1Click:Connect(savePosition)

UserInputService.InputBegan:Connect(function(input, processed)
    if processed then return end
    if input.KeyCode == Enum.KeyCode.L then savePosition() end
    if input.KeyCode == Enum.KeyCode.H then mainFrame.Visible = not mainFrame.Visible end
end)

loadFromFile()
updateGUI()
