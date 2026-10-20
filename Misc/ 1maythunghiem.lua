local Players = game:GetService("Players")

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "PlayerListGUI"
screenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")

local scrollingFrame = Instance.new("ScrollingFrame")
scrollingFrame.Name = "PlayerList"
scrollingFrame.Parent = screenGui
scrollingFrame.Size = UDim2.new(0, 200, 0, 300)
scrollingFrame.Position = UDim2.new(0.5, -100, 0.5, -150)
scrollingFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
scrollingFrame.ScrollBarThickness = 10
scrollingFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
scrollingFrame.Visible = false
scrollingFrame.ClipsDescendants = true

local contentFrame = Instance.new("Frame")
contentFrame.Parent = scrollingFrame
contentFrame.Size = UDim2.new(1, 0, 0, 0)
contentFrame.BackgroundTransparency = 1

local listLayout = Instance.new("UIListLayout")
listLayout.Parent = contentFrame
listLayout.FillDirection = Enum.FillDirection.Vertical
listLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
listLayout.VerticalAlignment = Enum.VerticalAlignment.Top
listLayout.Padding = UDim.new(0, 5)

local toggleButton = Instance.new("TextButton")
toggleButton.Name = "TogglePlayerList"
toggleButton.Parent = screenGui
toggleButton.Size = UDim2.new(0, 100, 0, 30)
toggleButton.Position = UDim2.new(0.5, -50, 0.9, -15)
toggleButton.Text = "Bật danh sách"
toggleButton.Draggable = true -- Cho phép kéo thả

-- Ô văn bản để sao chép dễ dàng trên điện thoại
local copyBox = Instance.new("TextBox")
copyBox.Parent = screenGui
copyBox.Size = UDim2.new(0, 200, 0, 40)
copyBox.Position = UDim2.new(0.5, -100, 0.45, -20)
copyBox.BackgroundColor3 = Color3.fromRGB(220, 220, 220)
copyBox.TextColor3 = Color3.fromRGB(0, 0, 0)
copyBox.TextScaled = true
copyBox.Text = "Nhấn vào tên để sao chép"
copyBox.Visible = false
copyBox.ClearTextOnFocus = false

local playerButtons = {}
local isListVisible = false

local function teleportToPlayer(player)
    if player then
        game.Players.LocalPlayer.Character:MoveTo(player.Character.HumanoidRootPart.Position)
    end
end

local function updatePlayerList()
    for _, button in ipairs(playerButtons) do
        button:Destroy()
    end
    playerButtons = {}

    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= game.Players.LocalPlayer then
            local playerFrame = Instance.new("Frame")
            playerFrame.Parent = contentFrame
            playerFrame.Size = UDim2.new(1, 0, 0, 40)
            playerFrame.BackgroundColor3 = Color3.new(0.8, 0.8, 0.8)

            local playerImage = Instance.new("ImageLabel")
            playerImage.Parent = playerFrame
            playerImage.Size = UDim2.new(0, 30, 0, 30)
            playerImage.Position = UDim2.new(0, 5, 0, 5)
            playerImage.Image = Players:GetUserThumbnailAsync(player.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size48x48)

            local textButton = Instance.new("TextButton")
            textButton.Name = player.Name
            textButton.Parent = playerFrame
            textButton.Size = UDim2.new(1, -40, 1, 0)
            textButton.Position = UDim2.new(0, 35, 0, 0)
            textButton.BackgroundColor3 = Color3.new(1, 1, 1)
            textButton.BackgroundTransparency = 1
            textButton.Text = player.DisplayName .. " (" .. player.Name .. ")" -- Hiển thị cả biệt danh và tên
            textButton.TextColor3 = Color3.new(0, 0, 0)
            textButton.TextXAlignment = Enum.TextXAlignment.Left

            textButton.MouseButton1Click:Connect(function()
                copyBox.Text = player.Name .. " (ID: " .. player.UserId .. ")"
                copyBox.Visible = true

                local confirmGui = Instance.new("ScreenGui")
                confirmGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")

                local confirmFrame = Instance.new("Frame")
                confirmFrame.Parent = confirmGui
                confirmFrame.Size = UDim2.new(0, 200, 0, 100)
                confirmFrame.Position = UDim2.new(0.5, -100, 0.5, -50)
                confirmFrame.BackgroundColor3 = Color3.new(0.8, 0.8, 0.8)

                local confirmLabel = Instance.new("TextLabel")
                confirmLabel.Parent = confirmFrame
                confirmLabel.Size = UDim2.new(1, 0, 0.5, 0)
                confirmLabel.Text = "Dịch chuyển đến " .. player.DisplayName .. "?" -- Hiển thị biệt danh trong hộp thoại xác nhận
                confirmLabel.BackgroundTransparency = 1

                local yesButton = Instance.new("TextButton")
                yesButton.Parent = confirmFrame
                yesButton.Size = UDim2.new(0.5, 0, 0.5, 0)
                yesButton.Position = UDim2.new(0, 0, 0.5, 0)
                yesButton.Text = "Có"
                yesButton.MouseButton1Click:Connect(function()
                    teleportToPlayer(player)
                    confirmGui:Destroy()
                end)

                local noButton = Instance.new("TextButton")
                noButton.Parent = confirmFrame
                noButton.Size = UDim2.new(0.5, 0, 0.5, 0)
                noButton.Position = UDim2.new(0.5, 0, 0.5, 0)
                noButton.Text = "Không"
                noButton.MouseButton1Click:Connect(function()
                    confirmGui:Destroy()
                end)
            end)

            table.insert(playerButtons, playerFrame)
        end
    end

    contentFrame.Size = UDim2.new(1, 0, 0, #playerButtons * 45)
    scrollingFrame.CanvasSize = UDim2.new(0, 0, 0, contentFrame.Size.Y.Offset)
end

toggleButton.MouseButton1Click:Connect(function()
    isListVisible = not isListVisible
    scrollingFrame.Visible = isListVisible
    if isListVisible then
        toggleButton.Text = "Tắt danh sách"
        updatePlayerList()
    else
        toggleButton.Text = "Bật danh sách"
        copyBox.Visible = false
    end
end)

Players.PlayerAdded:Connect(updatePlayerList)
Players.PlayerRemoving:Connect(updatePlayerList)

-- Thông báo khi script được thực thi
local createdByLabel = Instance.new("TextLabel")
createdByLabel.Parent = screenGui
createdByLabel.Size = UDim2.new(0, 200, 0, 30)
createdByLabel.Position = UDim2.new(0.5, -100, 0, 10)
createdByLabel.BackgroundColor3 = Color3.new(0, 0, 0)
createdByLabel.BackgroundTransparency = 0.5
createdByLabel.TextColor3 = Color3.new(1, 1, 1)
createdByLabel.Text = "Script được tạo bởi Andz"
createdByLabel.TextScaled = true

wait(5)
createdByLabel:Destroy()
