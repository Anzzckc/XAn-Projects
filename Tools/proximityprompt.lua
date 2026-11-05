local function removeHold(prompt)
    if prompt:IsA("ProximityPrompt") then
        prompt.HoldDuration = 0
    end
end

for _, descendant in ipairs(game:GetDescendants()) do
    removeHold(descendant)
end

game.DescendantAdded:Connect(removeHold)
