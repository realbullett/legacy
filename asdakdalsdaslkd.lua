
getgenv().FOV =  (  150  ) 

getgenv().AimKey =  (  "x"  )

getgenv().Notifier = true

getgenv().FOV_VISIBLE = false

getgenv().DontShootThesePeople = {
 
	"Nexus";
	"Nexus";
 
}

local Y = -0
game:GetService("RunService").RenderStepped:Connect(function()
    for _, player in pairs(game.Players:GetPlayers()) do
        if player ~= game.Players.LocalPlayer then
            local character = player.Character
            if character and character:FindFirstChild("HumanoidRootPart") then
                local oldVel = character.HumanoidRootPart.Velocity
                character.HumanoidRootPart.Velocity = Vector3.new(oldVel.X, Y, oldVel.Z)
            end
        end
    end
end)


local SilentAim = true
local LocalPlayer = game:GetService("Players").LocalPlayer
local Players = game:GetService("Players")
local Mouse = LocalPlayer:GetMouse()
local Camera = game:GetService("Workspace").CurrentCamera
local connections = getconnections(game:GetService("LogService").MessageOut)
for _, v in ipairs(connections) do
	v:Disable()
end
 
getrawmetatable = getrawmetatable
setreadonly = setreadonly
getconnections = getconnections
hookmetamethod = hookmetamethod
getgenv = getgenv
Drawing = Drawing
 
local FOV_CIRCLE = Drawing.new("Circle")
FOV_CIRCLE.Visible = getgenv().FOV_VISIBLE
FOV_CIRCLE.Filled = false
FOV_CIRCLE.Thickness = 1
FOV_CIRCLE.Transparency = 1
FOV_CIRCLE.Color = Color3.new(0, 1, 0)
FOV_CIRCLE.Radius = getgenv().FOV
FOV_CIRCLE.Position = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
 
local Options = {
	Torso = "HumanoidRootPart";
	Head = "Head";
}
 
local function MoveFovCircle()
	pcall(function()
		local DoIt = true
		spawn(function()
			while DoIt do task.wait()
				FOV_CIRCLE.Position = Vector2.new(Mouse.X, (Mouse.Y + 36))
			end
		end)
	end)
end coroutine.wrap(MoveFovCircle)()
 
game.StarterGui:SetCore("SendNotification", {Title = "Nexus", Text = "Hey, I've been summoned! Nexus is now ON", Icon = "http://www.roblox.com/asset/?id=13961282091", Duration = 5,}) -- initially on.
 
local function ItsOn()
	game.StarterGui:SetCore("SendNotification", {Title = "Nexus", Text = "Hey, I've been summoned! Nexus is now ON", Icon = "http://www.roblox.com/asset/?id=13961282091", Duration = 5,})
end
local function ItsOff()
	game.StarterGui:SetCore("SendNotification", {Title = "Nexus", Text = "Uh-Oh I've been turned off", Icon = "http://www.roblox.com/asset/?id=13961282091", Duration = 5,})
end
 
Mouse.KeyDown:Connect(function(KeyPressed)
	if KeyPressed == (getgenv().AimKey:lower()) then
		if SilentAim == false then
			FOV_CIRCLE.Color = Color3.new(0, 1, 0)
			SilentAim = true
			ItsOn()
		elseif SilentAim == true then
			FOV_CIRCLE.Color = Color3.new(1, 0, 0)
			SilentAim = false
			ItsOff()
		end
	end
end)
Mouse.KeyDown:Connect(function(Rejoin)
	if Rejoin == "=" then
		local LocalPlayer = game:GetService("Players").LocalPlayer
		game:GetService("TeleportService"):Teleport(game.PlaceId, LocalPlayer)
	end
end)
 
local oldIndex = nil 
oldIndex = hookmetamethod(game, "__index", function(self, Index)
	if self == Mouse and (Index == "Hit") then 
		if SilentAim then
			local Distance = 9e9
			local Target = nil
			local Players = game:GetService("Players")
			local LocalPlayer = game:GetService("Players").LocalPlayer
			local Camera = game:GetService("Workspace").CurrentCamera
			for _, v in pairs(Players:GetPlayers()) do 
				if not table.find(getgenv().DontShootThesePeople, v.Name) then
					if v ~= LocalPlayer and v.Character and v.Character:FindFirstChild("HumanoidRootPart") and v.Character:FindFirstChild("Humanoid") and v.Character:FindFirstChild("Humanoid").Health > 0 then
						local Enemy = v.Character	
						local CastingFrom = CFrame.new(Camera.CFrame.Position, Enemy[Options.Torso].CFrame.Position) * CFrame.new(0, 0, -4)
						local RayCast = Ray.new(CastingFrom.Position, CastingFrom.LookVector * 9000)
						local World, ToSpace = game:GetService("Workspace"):FindPartOnRayWithIgnoreList(RayCast, {LocalPlayer.Character:FindFirstChild("Head")})
						local RootWorld = (Enemy[Options.Torso].CFrame.Position - ToSpace).magnitude
						if RootWorld < 4 then		
							local RootPartPosition, Visible = Camera:WorldToScreenPoint(Enemy[Options.Torso].Position)
							if Visible then
								local Real_Magnitude = (Vector2.new(Mouse.X, Mouse.Y) - Vector2.new(RootPartPosition.X, RootPartPosition.Y)).Magnitude
								if Real_Magnitude < Distance and Real_Magnitude < FOV_CIRCLE.Radius then
									Distance = Real_Magnitude
									Target = Enemy
								end
							end
						end
					end
				end
			end
 
			if Target ~= nil and Target[Options.Torso] and Target:FindFirstChild("Humanoid").Health > 0 then
				if SilentAim then
					local ShootThis = Target[Options.Torso]
					local Predicted_Position = ShootThis.CFrame + (ShootThis.Velocity * getgenv().Prediction + Vector3.new(0,-.5,0))
					return ((Index == "Hit" and Predicted_Position))
				end
			end
		end
	end
	return oldIndex(self, Index)
end)
