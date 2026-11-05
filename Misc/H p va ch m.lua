local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local StarterGui = game:GetService("StarterGui")

local LocalPlayer = Players.LocalPlayer
local character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()

-- Xử lý tự xoá script khi chết
character:WaitForChild("Humanoid").Died:Connect(function()
	script:Destroy()
end)

-- Tạo GUI chính
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "HitboxGUI"
screenGui.ResetOnSpawn = false
screenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

-- Label giữa màn hình
local welcomeLabel = Instance.new("TextLabel")
welcomeLabel.Size = UDim2.new(0.4, 0, 0.1, 0)
welcomeLabel.Position = UDim2.new(0.3, 0, 0.45, 0)
welcomeLabel.BackgroundTransparency = 1
welcomeLabel.TextScaled = true
welcomeLabel.Font = Enum.Font.SourceSansBold
welcomeLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
welcomeLabel.TextStrokeTransparency = 0
welcomeLabel.Text = ""
welcomeLabel.Parent = screenGui

task.delay(5, function()
	welcomeLabel:Destroy()
end)

-- Main Frame
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 240, 0, 50)
mainFrame.Position = UDim2.new(0, 100, 0, 100)
mainFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
mainFrame.BorderSizePixel = 1
mainFrame.Parent = screenGui

-- Toggle button
local toggleButton = Instance.new("TextButton")
toggleButton.Size = UDim2.new(0, 120, 0, 40)
toggleButton.Position = UDim2.new(0, 10, 0, 5)
toggleButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
toggleButton.TextColor3 = Color3.new(1, 1, 1)
toggleButton.Font = Enum.Font.SourceSansBold
toggleButton.TextSize = 18
toggleButton.Text = "Bật Hitbox"
toggleButton.Parent = mainFrame

-- Size textbox
local sizeBox = Instance.new("TextBox")
sizeBox.Size = UDim2.new(0, 80, 0, 40)
sizeBox.Position = UDim2.new(0, 140, 0, 5)
sizeBox.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
sizeBox.TextColor3 = Color3.new(1, 1, 1)
sizeBox.Font = Enum.Font.SourceSansBold
sizeBox.TextSize = 18
sizeBox.Text = "5"
sizeBox.Parent = mainFrame

-- Nút nhỏ ẩn/hiện GUI
local toggleGuiButton = Instance.new("TextButton")
toggleGuiButton.Size = UDim2.new(0, 30, 0, 30)
toggleGuiButton.Position = UDim2.new(0, 10, 0, 10)
toggleGuiButton.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
toggleGuiButton.Text = ""
toggleGuiButton.Draggable = true
toggleGuiButton.Active = true
toggleGuiButton.Parent = screenGui

local guiVisible = true
toggleGuiButton.MouseButton1Click:Connect(function()
	guiVisible = not guiVisible
	mainFrame.Visible = guiVisible
end)

-- Hitbox xử lý
local hitboxEnabled = false
local hitboxSize = Vector3.new(5, 5, 5)
local hitboxColor = Color3.fromRGB(230, 230, 230)
local transparency = 0.7

local function createHitbox(character)
	local root = character:FindFirstChild("HumanoidRootPart")
	if not root then return end

	local adornment = root:FindFirstChild("HitboxAdornment")
	if adornment then adornment:Destroy() end

	local box = Instance.new("BoxHandleAdornment")
	box.Name = "HitboxAdornment"
	box.Adornee = root
	box.Size = hitboxSize
	box.Color3 = hitboxColor
	box.Transparency = transparency
	box.ZIndex = 5
	box.AlwaysOnTop = true
	box.Parent = root
end

local function removeHitbox(character)
	local root = character:FindFirstChild("HumanoidRootPart")
	if not root then return end
	local adornment = root:FindFirstChild("HitboxAdornment")
	if adornment then adornment:Destroy() end
end

local function updateHitboxes()
	for _, player in pairs(Players:GetPlayers()) do
		if player ~= LocalPlayer then
			local char = player.Character
			if char and char:FindFirstChild("Humanoid") and char.Humanoid.Health > 0 then
				if hitboxEnabled then
					createHitbox(char)
				else
					removeHitbox(char)
				end
			end
		end
	end
end

toggleButton.MouseButton1Click:Connect(function()
	hitboxEnabled = not hitboxEnabled
	toggleButton.Text = hitboxEnabled and "Tắt Hitbox" or "Bật Hitbox"
	updateHitboxes()
end)

sizeBox.FocusLost:Connect(function(enter)
	if enter then
		local size = tonumber(sizeBox.Text)
		if size and size > 0 then
			hitboxSize = Vector3.new(size, size, size)
			if hitboxEnabled then updateHitboxes() end
		else
			sizeBox.Text = tostring(hitboxSize.X)
		end
	end
end)

Players.PlayerAdded:Connect(function(player)
	player.CharacterAdded:Connect(function(char)
		if hitboxEnabled then
			createHitbox(char)
		end
	end)
end)
