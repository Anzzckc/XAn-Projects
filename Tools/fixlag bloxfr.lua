game:GetService("Lighting").GlobalShadows = false
game:GetService("Lighting").Brightness = 0
game:GetService("Lighting").ClockTime = 0
game:GetService("Lighting").FogEnd = 0
game:GetService("Lighting").FogStart = 0
game:GetService("Lighting").OutdoorAmbient = Color3.new(0,0,0)
game:GetService("Lighting").Ambient = Color3.new(0,0,0)
game:GetService("Lighting").Technology = Enum.Technology.Legacy
game:GetService("Workspace").Terrain:Clear()

for _, v in pairs(game:GetService("Lighting"):GetChildren()) do
    if v:IsA("BlurEffect") or v:IsA("SunRaysEffect") or v:IsA("BloomEffect") or v:IsA("ColorCorrectionEffect") or v:IsA("DepthOfFieldEffect") then
        v.Enabled = false
    end
end

for _, obj in pairs(game:GetService("Workspace"):GetDescendants()) do
    if obj:IsA("ParticleEmitter") or obj:IsA("Fire") or obj:IsA("Smoke") or obj:IsA("Sparkles") or obj:IsA("Trail") then
        obj.Enabled = false
    elseif obj:IsA("Decal") or obj:IsA("Texture") then
        obj.Transparency = 1
    elseif obj:IsA("BasePart") then
        obj.Material = Enum.Material.Plastic
        obj.Reflectance = 0
        obj.Transparency = 0
    elseif obj:IsA("MeshPart") then
        obj.Material = Enum.Material.Plastic
        obj.Reflectance = 0
    end
end

settings().Rendering.QualityLevel = 1
collectgarbage("collect")