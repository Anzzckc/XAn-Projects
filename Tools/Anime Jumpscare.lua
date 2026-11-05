-- shit.
-- by Larkinian/yoolz
-- if u gonna use, at least give me the credits tho
-- Archived by Xuan An

local player = game.Players.LocalPlayer
local RunService = game:GetService("RunService")


local gui = Instance.new("ScreenGui")
gui.Name = "WhiteFullScreen"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true
gui.ZIndexBehavior = Enum.ZIndexBehavior.Global
gui.Parent = player:WaitForChild("PlayerGui")

-- wihte bagckroundz 
local whiteBackground = Instance.new("Frame")
whiteBackground.Size = UDim2.fromScale(1, 1)
whiteBackground.Position = UDim2.fromScale(0, 0)
whiteBackground.BackgroundColor3 = Color3.new(1, 1, 1)
whiteBackground.BorderSizePixel = 0
whiteBackground.ZIndex = 999999
whiteBackground.Parent = gui

-- blocker
local blocker = Instance.new("TextButton")
blocker.Size = UDim2.fromScale(1, 1)
blocker.BackgroundTransparency = 1
blocker.Text = ""
blocker.AutoButtonColor = false
blocker.Modal = true
blocker.ZIndex = whiteBackground.ZIndex + 1
blocker.Parent = whiteBackground

-- vtuber girl(idk her name)
local image = Instance.new("ImageLabel")
image.AnchorPoint = Vector2.new(0.5, 0.5)
image.Position = UDim2.fromScale(0.5, 0.5)
image.Size = UDim2.fromScale(1, 1)
image.BackgroundTransparency = 1
image.Image = "rbxassetid://84838094344701"
image.ZIndex = blocker.ZIndex + 1
image.Parent = gui

-- laugh
local sound1 = Instance.new("Sound")
sound1.SoundId = "rbxassetid://82719020266339"
sound1.Volume = 1
sound1.Parent = gui

-- forsaken ahh music
local sound2 = Instance.new("Sound")
sound2.SoundId = "rbxassetid://85848331097801"
sound2.Volume = 1
sound2.Looped = true
sound2.Parent = workspace

-- distortion/bassboosted thingy
local distortion = Instance.new("DistortionSoundEffect")
distortion.Level = 0.2
distortion.Parent = sound2


local eq = Instance.new("EqualizerSoundEffect")

eq.LowGain = 3
eq.MidGain = -2
eq.HighGain = 1

eq.Parent = sound2

-- astolfo(feemmmboyyyyzzz)
task.delay(2.8, function()
	if image.Parent then
		image.Image = "rbxassetid://95558068230459"
	end
end)


local time = 0
local connection

connection = RunService.RenderStepped:Connect(function(dt)
	if not image.Parent then
		connection:Disconnect()
		return
	end

	time += dt * 5

	local shakeX = math.sin(time * 7) * 0.02
	local shakeY = math.cos(time * 8) * 0.02
	local scale = 1 + math.sin(time * 8) * 0.1
	local rotation = math.sin(time * 10) * 9

	image.Position = UDim2.fromScale(0.5 + shakeX, 0.5 + shakeY)
	image.Size = UDim2.fromScale(scale, scale)
	image.Rotation = rotation
end)


sound1.Ended:Connect(function()
	if gui then
		gui:Destroy()
	end

	sound2:Play()
end)

sound1:Play()

-- anime aura farming skybox
local Lighting = game:GetService("Lighting")

local oldSky = Lighting:FindFirstChildOfClass("Sky")
if oldSky then
	oldSky:Destroy()
end

local sky = Instance.new("Sky")
sky.Name = "AwesomeSkybox"
sky.Parent = Lighting

local frames = {
	21076888,
	21076945,
	21077007,
	21077125,
	21077227,
	21077345,
	21077227,
	21077125,
	21077007,
	21076945
}

local function setSky(id)
	local asset = "rbxassetid://" .. id
	sky.SkyboxBk = asset
	sky.SkyboxDn = asset
	sky.SkyboxFt = asset
	sky.SkyboxLf = asset
	sky.SkyboxRt = asset
	sky.SkyboxUp = asset
end

while true do
	for _, id in ipairs(frames) do
		setSky(id)
		task.wait(0.1)
	end
end
