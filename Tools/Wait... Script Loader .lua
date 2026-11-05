local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "MovingWaitNotice"
screenGui.IgnoreGuiInset = true 
screenGui.Parent = playerGui

local textLabel = Instance.new("TextLabel")
textLabel.AnchorPoint = Vector2.new(0.5, 0.5)
textLabel.Position = UDim2.new(-0.5, 0, 0.5, 0)
textLabel.Size = UDim2.new(1, 0, 1, 0) 
textLabel.BackgroundTransparency = 1 
textLabel.TextColor3 = Color3.new(1, 1, 1)
textLabel.TextSize = 120 
textLabel.Font = Enum.Font.FredokaOne
textLabel.Text = "Wait"
textLabel.Parent = screenGui

local uiStroke = Instance.new("UIStroke")
uiStroke.Thickness = 1000 
uiStroke.Color = Color3.new(0, 0, 0) 
uiStroke.Transparency = 0
uiStroke.Parent = textLabel

task.spawn(function()
    local dots = 0
    while textLabel and textLabel.Parent do
        dots = (dots + 1) % 4
        textLabel.Text = "Wait" .. string.rep(".", dots)
        task.wait(0.4)
    end
end)

local function runAnimation()
    local moveInInfo = TweenInfo.new(1.5, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
    local moveInTween = TweenService:Create(textLabel, moveInInfo, {Position = UDim2.new(0.5, 0, 0.5, 0)})
    
    moveInTween:Play()
    moveInTween.Completed:Wait()
    
    task.wait(5)
    
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

runAnimation()
