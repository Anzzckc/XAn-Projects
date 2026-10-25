-- [Open Source]
-- Monday, June 8, 2026
task.wait(3)

repeat task.wait() until game:IsLoaded()

game:GetService("StarterGui"):SetCore("SendNotification", {
    Title = "Auto Reconnect";
    Text = "Made By XAn.";
    Duration = 5;
})

local TeleportService = game:GetService('TeleportService')
local HttpService = game:GetService('HttpService')
local ReplicatedStorage = game:GetService('ReplicatedStorage')
local Players = game:GetService('Players')
local LocalPlayer = Players.LocalPlayer
local CoreGui = game:GetService('CoreGui')
local TweenService = game:GetService('TweenService')

local placeId = game.PlaceId
local AllIDs = {}
local foundAnything = ""
local actualHour = os.date("!*t").hour
local isBloxFruits = ReplicatedStorage:FindFirstChild("__ServerBrowser") ~= nil
local backupServerId = nil
local isKicked = false

local File = pcall(function()
    AllIDs = HttpService:JSONDecode(readfile("server-hop-temp.json"))
end)
if not File then
    table.insert(AllIDs, actualHour)
    pcall(function()
        writefile("server-hop-temp.json", HttpService:JSONEncode(AllIDs))
    end)
end

local function findAvailableServer()
    local Site
    if foundAnything == "" then
        Site = HttpService:JSONDecode(game:HttpGet('https://games.roblox.com/v1/games/' .. placeId .. '/servers/Public?sortOrder=Asc&limit=100'))
    else
        Site = HttpService:JSONDecode(game:HttpGet('https://games.roblox.com/v1/games/' .. placeId .. '/servers/Public?sortOrder=Asc&limit=100&cursor=' .. foundAnything))
    end
    
    if Site.nextPageCursor and Site.nextPageCursor ~= "null" and Site.nextPageCursor ~= nil then
        foundAnything = Site.nextPageCursor
    end
    
    local num = 0
    for i, v in pairs(Site.data) do
        local Possible = true
        local ID = tostring(v.id)
        
        if tonumber(v.maxPlayers) > tonumber(v.playing) then
            if ID == game.JobId and isBloxFruits then
                Possible = false
            end
            
            for _, Existing in pairs(AllIDs) do
                if num ~= 0 then
                    if ID == tostring(Existing) then
                        Possible = false
                    end
                else
                    if tonumber(actualHour) ~= tonumber(Existing) then
                        pcall(function()
                            delfile("server-hop-temp.json")
                            AllIDs = {}
                            table.insert(AllIDs, actualHour)
                        end)
                    end
                end
                num = num + 1
            end
            
            if Possible == true then
                return ID
            end
        end
    end
    
    return nil
end

local function updateBackupServer()
    local success, serverId = pcall(findAvailableServer)
    if success and serverId then
        backupServerId = serverId
        return true
    else
        foundAnything = ""
        local success2, serverId2 = pcall(findAvailableServer)
        if success2 and serverId2 then
            backupServerId = serverId2
            return true
        end
    end
    backupServerId = nil
    return false
end

local function showNotice(text, duration)
    local playerGui = LocalPlayer:WaitForChild("PlayerGui")
    
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "HopNotice"
    screenGui.IgnoreGuiInset = true
    screenGui.Parent = playerGui
    
    local textLabel = Instance.new("TextLabel")
    textLabel.AnchorPoint = Vector2.new(0.5, 0.5)
    textLabel.Position = UDim2.new(-0.5, 0, 0.5, 0)
    textLabel.Size = UDim2.new(1, 0, 1, 0)
    textLabel.BackgroundTransparency = 1
    textLabel.TextColor3 = Color3.new(1, 1, 1)
    textLabel.TextSize = 80
    textLabel.Font = Enum.Font.FredokaOne
    textLabel.Text = text
    textLabel.Parent = screenGui
    
    local uiStroke = Instance.new("UIStroke")
    uiStroke.Thickness = 1000
    uiStroke.Color = Color3.new(0, 0, 0)
    uiStroke.Transparency = 0
    uiStroke.Parent = textLabel
    
    local moveInInfo = TweenInfo.new(1.5, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
    local moveInTween = TweenService:Create(textLabel, moveInInfo, {Position = UDim2.new(0.5, 0, 0.5, 0)})
    moveInTween:Play()
    moveInTween.Completed:Wait()
    
    task.wait(duration)
    
    local moveOutInfo = TweenInfo.new(1.5, Enum.EasingStyle.Quart, Enum.EasingDirection.In)
    local moveOutTween = TweenService:Create(textLabel, moveOutInfo, {Position = UDim2.new(1.5, 0, 0.5, 0)})
    local fadeOutTween = TweenService:Create(uiStroke, moveOutInfo, {Transparency = 1})
    local textFadeTween = TweenService:Create(textLabel, moveOutInfo, {TextTransparency = 1})
    
    moveOutTween:Play()
    fadeOutTween:Play()
    textFadeTween:Play()
    
    moveOutTween.Completed:Connect(function()
        screenGui:Destroy()
    end)
end

local function teleportToBackup()
    if isKicked then return end
    isKicked = true
    
    if not backupServerId then
        showNotice("No servers available!!", 10)
        return
    end
    
    table.insert(AllIDs, backupServerId)
    pcall(function()
        writefile("server-hop-temp.json", HttpService:JSONEncode(AllIDs))
    end)
    
    if isBloxFruits then
        local sb = ReplicatedStorage:FindFirstChild("__ServerBrowser")
        if sb then
            sb:InvokeServer("teleport", backupServerId)
        end
    else
        TeleportService:TeleportToPlaceInstance(placeId, backupServerId, LocalPlayer)
    end
end

updateBackupServer()

task.spawn(function()
    while not isKicked do
        local success = updateBackupServer()
        
        if not success and not backupServerId then
            showNotice("No servers available!!", 10)
            while not backupServerId and not isKicked do
                task.wait(1)
                updateBackupServer()
            end
            if backupServerId and not isKicked then
                showNotice("Server found!!", 3)
            end
        else
            task.wait(3)
        end
    end
end)

repeat task.wait() until CoreGui:FindFirstChild('RobloxPromptGui')
local promptOverlay = CoreGui.RobloxPromptGui.promptOverlay

promptOverlay.ChildAdded:Connect(function(Child)
    if Child.Name == 'ErrorPrompt' and not isKicked then
        teleportToBackup()
    end
end)

task.spawn(function()
    while not isKicked do
        if not LocalPlayer:IsDescendantOf(game) then
            teleportToBackup()
            break
        end
        task.wait(1)
    end
end)
