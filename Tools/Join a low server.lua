local Players = game:GetService("Players")
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")
local LocalPlayer = Players.LocalPlayer
local PlaceId = game.PlaceId
local JobId = game.JobId

local minPlayers = 1
local maxPlayers = 5

function getServers()
    local servers = {}
    local url = "https://games.roblox.com/v1/games/" .. PlaceId .. "/servers/Public?sortOrder=Asc&limit=100&excludeFullGames=true"

    local success, result = pcall(function()
        return game:HttpGet(url)
    end)

    if not success then
        warn("Failed to get server list")
        return servers
    end

    local data = HttpService:JSONDecode(result)

    if data and data.data then
        for _, server in pairs(data.data) do
            local playing = server.playing
            local maxPlayers = server.maxPlayers

            if playing and maxPlayers and playing >= minPlayers and playing <= maxPlayers and playing < maxPlayers and server.id ~= JobId then
                table.insert(servers, {
                    id = server.id,
                    playing = playing,
                    maxPlayers = maxPlayers
                })
            end
        end
    end

    return servers
end

function tryTeleport()
    local servers = getServers()

    if #servers == 0 then
        warn("No low player server found")
        return false
    end

    table.sort(servers, function(a, b)
        return a.playing < b.playing
    end)

    local lowest = servers[1].playing
    local lowestServers = {}

    for _, server in pairs(servers) do
        if server.playing == lowest then
            table.insert(lowestServers, server)
        end
    end

    local target = lowestServers[math.random(1, #lowestServers)]
    warn("Found server: " .. target.playing .. "/" .. target.maxPlayers)

    local ok, err = pcall(function()
        TeleportService:TeleportToPlaceInstance(PlaceId, target.id, LocalPlayer)
    end)

    if ok then
        return true
    else
        warn("Teleport failed: " .. tostring(err))
        return false
    end
end

if not tryTeleport() then
    warn("Retrying...")
    tryTeleport()
end
