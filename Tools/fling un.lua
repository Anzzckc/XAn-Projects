-- Unanti Fling Script
-- Disconnect the anti-fling connection

local connection = getgenv()._antiflingConnection

if connection then
    connection:Disconnect()
    getgenv()._antiflingConnection = nil
end
