--IY's original code
local Players = game:GetService("Players")
local TeleportService = game:GetService("TeleportService")
local LocalPlayer = Players.LocalPlayer
local PlaceId = game.PlaceId
local JobId = game.JobId

if #Players:GetPlayers() <= 1 then
    LocalPlayer:Kick("\nRejoining...")
    task.wait()
    TeleportService:Teleport(PlaceId, LocalPlayer)
else
    TeleportService:TeleportToPlaceInstance(PlaceId, JobId, LocalPlayer)
end
