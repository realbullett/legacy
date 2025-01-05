











local DefaultHeadSize = 2
local IsHitboxExpanded = false 
local IsColorDisabled = true 
local IsTeamCheckEnabled = false
local Players = game:GetService('Players')
local RunService = game:GetService('RunService')
local UserInputService = game:GetService('UserInputService')

local function toggleColorVisibility()
    IsColorDisabled = not IsColorDisabled
end

local function toggleHitboxSize()
    IsHitboxExpanded = not IsHitboxExpanded
end

UserInputService.InputBegan:Connect(function(input, gameProcessedEvent)
    if not gameProcessedEvent then
        if input.KeyCode == Enum.KeyCode.V then
            toggleColorVisibility()
        elseif input.KeyCode == Enum.KeyCode.E and UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then
            toggleHitboxSize()
        end
    end
end)

RunService.RenderStepped:Connect(function()
    local localPlayer = Players.LocalPlayer
    if not localPlayer then return end

    local localPlayerTeam = localPlayer.Team
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= localPlayer and (not IsTeamCheckEnabled or player.Team ~= localPlayerTeam) then
            local humanoidRootPart = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
            if humanoidRootPart then
                humanoidRootPart.Size = Vector3.new(IsHitboxExpanded and HeadSize or DefaultHeadSize, IsHitboxExpanded and HeadSize or DefaultHeadSize, IsHitboxExpanded and HeadSize or DefaultHeadSize)
                humanoidRootPart.CanCollide = false

                if IsColorDisabled then
                    humanoidRootPart.Transparency = 0.7
                    humanoidRootPart.BrickColor = BrickColor.new("Medium stone grey")
                    humanoidRootPart.Material = Enum.Material.Neon
                else
                    humanoidRootPart.Transparency = 1
                    humanoidRootPart.BrickColor = BrickColor.new("Institutional white")
                    humanoidRootPart.Material = Enum.Material.Plastic
                end
            end
        end
    end
end)
