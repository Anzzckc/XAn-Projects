-- Anti Fling Module
-- RunService.Stepped to disable collision for other players' parts

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

local antiflingConnection = nil

if antiflingConnection then
    antiflingConnection:Disconnect()
    antiflingConnection = nil
end

antiflingConnection = RunService.Stepped:Connect(function()
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            for _, v in pairs(player.Character:GetDescendants()) do
                if v:IsA("BasePart") then
                    v.CanCollide = false
                end
            end
        end
    end
end)

-- Store connection for UnantiFling to access
getgenv()._antiflingConnection = antiflingConnection
