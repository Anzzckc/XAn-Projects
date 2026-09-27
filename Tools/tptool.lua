-- Original source from IY
local player = game.Players.LocalPlayer

local function getRoot(char)
    if char and char:FindFirstChildOfClass("Humanoid") then
        return char:FindFirstChildOfClass("Humanoid").RootPart
    end
    return nil
end

local function breakVelocity()
    local char = player.Character
    if not char then return end
    for _, v in pairs(char:GetDescendants()) do
        if v:IsA("BasePart") then
            v.Velocity = Vector3.new(0, 0, 0)
            v.RotVelocity = Vector3.new(0, 0, 0)
        end
    end
end

local function createTpTool()
    local backpack = player:FindFirstChildOfClass("Backpack")
    if not backpack then return end
    
    for _, v in pairs(backpack:GetChildren()) do
        if v.Name == "Teleport Tool" then
            v:Destroy()
        end
    end
    
    local tool = Instance.new("Tool")
    tool.Name = "Teleport Tool"
    tool.RequiresHandle = false
    tool.Parent = backpack
    
    tool.Activated:Connect(function()
        local root = getRoot(player.Character)
        local mouse = player:GetMouse()
        local hit = mouse.Hit
        
        if root and hit then
            root.CFrame = CFrame.new(hit.X, hit.Y + 3, hit.Z, select(4, root.CFrame:components()))
            breakVelocity()
        end
    end)
end

createTpTool()
