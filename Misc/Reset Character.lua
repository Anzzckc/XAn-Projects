--[[
    Script: Reset Button (Smart, Safe, Fancy)
    Author: An
    Created on: June 12, 2025
    License: Free for personal use. No resale or redistribution without credit.
]]

local Players = game:GetService("Players")
local player = Players.LocalPlayer
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

-- GUI setup
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "ResetGui"
screenGui.ResetOnSpawn = false
screenGui.Parent = player:WaitForChild("PlayerGui")

-- Reset button
local resetButton = Instance.new("ImageButton")
resetButton.Name = "ResetButton"
resetButton.Size = UDim2.new(0, 40, 0, 40)
resetButton.Position = UDim2.new(0, 20, 0, 20)
resetButton.BackgroundColor3 = Color3.new(0, 0, 0)
resetButton.Image = "rbxassetid://6031091002" -- skull icon
resetButton.ImageColor3 = Color3.new(1, 1, 1)
resetButton.Active = true
resetButton.Draggable = true
resetButton.AutoButtonColor = true
resetButton.Parent = screenGui

-- Sound
local clickSound = Instance.new("Sound", resetButton)
clickSound.SoundId = "rbxassetid://12221967"
clickSound.Volume = 0.5

-- Hold-to-drag hint
local hint = Instance.new("TextLabel")
hint.Size = UDim2.new(0, 120, 0, 25)
hint.Position = UDim2.new(0, 45, 0, 0)
hint.BackgroundTransparency = 0.5
hint.BackgroundColor3 = Color3.new(0, 0, 0)
hint.Text = "Hold to drag"
hint.Font = Enum.Font.SourceSans
hint.TextScaled = true
hint.TextColor3 = Color3.new(1, 1, 1)
hint.Parent = resetButton
hint.Visible = true

task.delay(4, function()
	if hint then hint:Destroy() end
end)

-- Fade message
local notice = Instance.new("TextLabel")
notice.Parent = screenGui
notice.Text = "Script created on June 12"
notice.Size = UDim2.new(0.6, 0, 0.1, 0)
notice.Position = UDim2.new(0.2, 0, 0.45, 0)
notice.BackgroundColor3 = Color3.new(0, 0, 0)
notice.BackgroundTransparency = 0.3
notice.TextColor3 = Color3.new(1, 1, 1)
notice.Font = Enum.Font.SourceSansBold
notice.TextScaled = true

TweenService:Create(notice, TweenInfo.new(0.5, Enum.EasingStyle.Sine), {
	TextTransparency = 1, BackgroundTransparency = 1
}):Play()
task.delay(3, function()
	if notice then notice:Destroy() end
end)

-- Dark mode at night
local hour = tonumber(os.date("*t").hour)
if hour >= 18 or hour < 6 then
	resetButton.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
	resetButton.ImageColor3 = Color3.fromRGB(180, 0, 0)
end

-- Light hover effect
resetButton.MouseEnter:Connect(function()
	TweenService:Create(resetButton, TweenInfo.new(0.2), {
		ImageColor3 = Color3.fromRGB(255, 60, 60)
	}):Play()
end)
resetButton.MouseLeave:Connect(function()
	TweenService:Create(resetButton, TweenInfo.new(0.2), {
		ImageColor3 = (hour >= 18 or hour < 6) and Color3.fromRGB(180, 0, 0) or Color3.new(1, 1, 1)
	}):Play()
end)

-- Click vs drag + cooldown
local isDragging = false
local lastReset = 0

resetButton.MouseButton1Down:Connect(function()
	isDragging = false
end)

resetButton.MouseMoved:Connect(function()
	isDragging = true
end)

resetButton.MouseButton1Up:Connect(function()
	if not isDragging and tick() - lastReset > 2 then
		lastReset = tick()
		clickSound:Play()
		if player.Character then
			player.Character:BreakJoints()
		end
	end
end)

-- Save position between deaths (in attribute)
local function savePos()
	player:SetAttribute("ResetBtnPosX", resetButton.Position.X.Offset)
	player:SetAttribute("ResetBtnPosY", resetButton.Position.Y.Offset)
end

local function loadPos()
	local x = player:GetAttribute("ResetBtnPosX")
	local y = player:GetAttribute("ResetBtnPosY")
	if x and y then
		resetButton.Position = UDim2.new(0, x, 0, y)
	end
end

resetButton:GetPropertyChangedSignal("Position"):Connect(savePos)
loadPos()
