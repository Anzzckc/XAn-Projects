-- ShiftLock Module - Refactored by Xuan An
-- TikTok:@x.an3929
-- [Open Source]

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local ContextActionService = game:GetService("ContextActionService")
local LocalPlayer = Players.LocalPlayer

local ShiftLockScreenGui = Instance.new("ScreenGui")
local ShiftLockButton = Instance.new("ImageButton")
local ShiftlockCursor = Instance.new("ImageLabel")

local States = {
    Off = "rbxasset://textures/ui/mouseLock_off@2x.png",
    On = "rbxasset://textures/ui/mouseLock_on@2x.png",
    Lock = "rbxasset://textures/MouseLockedCursor.png",
}

local MaxLength = 900000
local EnabledOffset = CFrame.new(1.7, 0, 0)
local DisabledOffset = CFrame.new(-1.7, 0, 0)
local Active = nil
local isShiftLockEnabled = false

ShiftLockScreenGui.Name = "Shiftlock (CoreGui)"
ShiftLockScreenGui.Parent = CoreGui
ShiftLockScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ShiftLockScreenGui.ResetOnSpawn = false

ShiftLockButton.Parent = ShiftLockScreenGui
ShiftLockButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
ShiftLockButton.BackgroundTransparency = 1
ShiftLockButton.Position = UDim2.new(0.80, 0, 0.85, 0)
ShiftLockButton.Size = UDim2.new(0.04, 0, 0.04, 0)
ShiftLockButton.SizeConstraint = Enum.SizeConstraint.RelativeXX
ShiftLockButton.Image = States.Off

ShiftlockCursor.Name = "Shiftlock Cursor"
ShiftlockCursor.Parent = ShiftLockScreenGui
ShiftlockCursor.Image = States.Lock
ShiftlockCursor.Size = UDim2.new(0.015, 0, 0.015, 0)
ShiftlockCursor.Position = UDim2.new(0.5, 0, 0.5, 0)
ShiftlockCursor.AnchorPoint = Vector2.new(0.5, 0.5)
ShiftlockCursor.SizeConstraint = Enum.SizeConstraint.RelativeXX
ShiftlockCursor.BackgroundTransparency = 1
ShiftlockCursor.Visible = false

local function ToggleShiftLock()
    if not isShiftLockEnabled then
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
            LocalPlayer.Character.Humanoid.AutoRotate = false
        end
        isShiftLockEnabled = true
        ShiftLockButton.Image = States.On
        ShiftlockCursor.Visible = true
        Active = RunService.RenderStepped:Connect(function()
            if not isShiftLockEnabled then return end
            if not LocalPlayer.Character or not LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then return end
            if not workspace.CurrentCamera then return end
            local humanoidRootPart = LocalPlayer.Character.HumanoidRootPart
            local camera = workspace.CurrentCamera
            humanoidRootPart.CFrame = CFrame.new(
                humanoidRootPart.Position,
                Vector3.new(
                    camera.CFrame.LookVector.X * MaxLength,
                    humanoidRootPart.Position.Y,
                    camera.CFrame.LookVector.Z * MaxLength
                )
            )
            camera.CFrame = camera.CFrame * EnabledOffset
            camera.Focus = CFrame.fromMatrix(
                camera.Focus.Position,
                camera.CFrame.RightVector,
                camera.CFrame.UpVector
            ) * EnabledOffset
        end)
    else
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
            LocalPlayer.Character.Humanoid.AutoRotate = true
        end
        isShiftLockEnabled = false
        ShiftLockButton.Image = States.Off
        ShiftlockCursor.Visible = false
        if workspace.CurrentCamera then
            workspace.CurrentCamera.CFrame = workspace.CurrentCamera.CFrame * DisabledOffset
        end
        if Active then
            Active:Disconnect()
            Active = nil
        end
    end
end

local function HandleShiftLockAction(actionName, inputState, inputObject)
    if inputState == Enum.UserInputState.Begin then
        ToggleShiftLock()
    end
end

ShiftLockButton.MouseButton1Click:Connect(ToggleShiftLock)
ContextActionService:BindAction("ShiftLock", HandleShiftLockAction, false, Enum.KeyCode.LeftShift)

LocalPlayer.CharacterAdded:Connect(function(character)
    if isShiftLockEnabled then
        task.wait(0.5)
        local humanoid = character:FindFirstChild("Humanoid")
        if humanoid then humanoid.AutoRotate = false end
    end
end)
