local OrionLib = loadstring(game:HttpGet(('https://raw.githubusercontent.com/shlexware/Orion/main/source')))()

local H_G_DRGH_EHT_HDF_G_ERHY_ETRH_SDR_GFH_HD_FGH_DRETH_ETDRHDR_G_DTR_HJFTD_GH_DSR_GHRT_JHT = math.abs;

local NumBypass = (H_G_DRGH_EHT_HDF_G_ERHY_ETRH_SDR_GFH_HD_FGH_DRETH_ETDRHDR_G_DTR_HJFTD_GH_DSR_GHRT_JHT(0.5+0.2+0.3-(((((H_G_DRGH_EHT_HDF_G_ERHY_ETRH_SDR_GFH_HD_FGH_DRETH_ETDRHDR_G_DTR_HJFTD_GH_DSR_GHRT_JHT((((((-2.79999726635+0.3)*2)*10)/987654)*987654)/2)*2)/3456789876567483567824567)*3456789876567483567824567)/game.PlaceId)*game.PlaceId+1-0.5-0.2-0.3)-1)*2)/2

local Client = {
    DEV_MODE = true,
    Movement = {
        B = true,
        FS = 25,
        WS = 50,
        JP = 25,
        JPU = 25,
        LS = 25,
        FB = NumBypass,
        BHOPHELD = false,
        BHOPJUMP = true,
        FLYHELD = false
    },
    Combat = {
        AIMBOT = false,
        AIMBOT_SETTINGS = {
            Aimbot = true,
            Aiming = false,
            Aimbot_AimPart = "Head",
            Aimbot_TeamCheck = true,
            Aimbot_Draw_FOV = true,
            Aimbot_FOV_Radius = 100,
            Aimbot_FOV_Color = Color3.fromRGB(255,255,255),
            Aimbot_offSet = 0,
            WallCheck = true,
        },
        FIRERATE = false,
        WALLBANG = false,
        AUTOFARM = false,
        USED_RE = false,
        FORCEBACK = false,
        INFAMMO = false,
        LOOKSENS = 0.0166666667
    },
    Render = {
        LINEESP = false,
        ESP = false,
        BOXESP = false,
        CIRCESP = false,
        NOTIFY = false,
        ESPTEAMCHECK = true,
        ESPCOLOR = Color3.fromRGB(0, 255, 42),
        TEAMESPCOLOR = Color3.fromRGB(0, 204, 255)
    }
}


local dwWorkspace = game:GetService("Workspace")
local dwCamera = dwWorkspace.CurrentCamera
local dwRunService = game:GetService("RunService")
local dwUIS = game:GetService("UserInputService")
local dwEntities = game:GetService("Players")
local dwLocalPlayer = dwEntities.LocalPlayer
local dwMouse = dwLocalPlayer:GetMouse()
local get_pivot = workspace.GetPivot;
local dwAlive = dwLocalPlayer:WaitForChild("Status", 1337):WaitForChild("Alive").Value;


local Request = function(type)
    if type == "mode" then
        return Client.DEV_MODE
    end
    if type == "ping" then
        return dwLocalPlayer:FindFirstChild("Ping").Value
    end
    if type == "fps" then
        return math.round(1 / dwRunService.RenderStepped:wait())
    end
end

local MainMenu = dwLocalPlayer.PlayerGui:WaitForChild("Menew", 1337);
local PlayButton = MainMenu:WaitForChild("Main", 1337).Play;
local MainHUD = dwLocalPlayer.PlayerGui:WaitForChild("GUI", 1337);
local TeamSelection = MainHUD:WaitForChild("TeamSelection", 1337);

local buttonColors = {"Blu", "Rd", "Ylw", "Grn"};

local function AutoSpawn()
	if MainMenu.Enabled then
		-- Fire play button
		firesignal(PlayButton.MouseButton1Down);

		-- Wait for GUI to change
		repeat task.wait(0.5) until TeamSelection.Visible;

		-- Buttons check and auto team select
		if TeamSelection:FindFirstChild("Buttons").Visible then -- normal
			for i, teamButton in pairs(TeamSelection:FindFirstChild("Buttons"):GetChildren()) do
				if table.find(buttonColors, teamButton.Name) and not teamButton.lock.Visible then
					firesignal(teamButton.MouseButton1Down);
					break;
				end
			end
		elseif TeamSelection:FindFirstChild("ButtonsFFA").Visible then -- FFA
			firesignal(TeamSelection:FindFirstChild("ButtonsFFA").FFA.MouseButton1Down);
		end
	end
end

local rad = math.rad;
local tan = math.tan;
local floor = math.floor;

function notBehindWall(target)
    local ray = Ray.new(dwLocalPlayer.Character.Head.Position, (target.Position - dwLocalPlayer.Character.Head.Position).Unit * 300)
    local part, position = game:GetService("Workspace"):FindPartOnRayWithIgnoreList(ray, {dwLocalPlayer.Character}, false, true)
    if part then
        local humanoid = part.Parent:FindFirstChildOfClass("Humanoid")
        if not humanoid then
            humanoid = part.Parent.Parent:FindFirstChildOfClass("Humanoid")
        end
        if humanoid and target and humanoid.Parent == target.Parent then
            local pos, visible = dwCamera:WorldToScreenPoint(target.Position)
            if visible then
                return true
            end
        end
    end
end

function getPlayerClosestToMouse()
    local target = nil
    local maxDist = math.huge
    for _,v in pairs(dwEntities:GetPlayers()) do
        if v.Character then
            if v.Character:FindFirstChild("Humanoid") and v.Character.Humanoid.Health ~= 0 and v.Character:FindFirstChild("HumanoidRootPart") and v.Team ~= dwLocalPlayer.Team then
                if v.Character:FindFirstChild("HumanoidRootPart").Position.Y > -300 then
                local pos, vis = dwCamera:WorldToViewportPoint(v.Character.HumanoidRootPart.Position)
                local dist = (Vector2.new(dwMouse.X, dwMouse.Y) - Vector2.new(pos.X, pos.Y)).magnitude
                if dist < maxDist and vis then
                    local headPos = dwCamera:WorldToViewportPoint(v.Character.Head.Position)
                    local headDist = (Vector2.new(dwMouse.X, dwMouse.Y) - Vector2.new(headPos.X, headPos.Y)).magnitude
                    if headDist < Client.Combat.AIMBOT_SETTINGS.Aimbot_FOV_Radius then
                        if notBehindWall(v.Character[Client.Combat.AIMBOT_SETTINGS.Aimbot_AimPart]) or not Client.Combat.AIMBOT_SETTINGS.WallCheck then
                            target = v.Character[Client.Combat.AIMBOT_SETTINGS.Aimbot_AimPart]
                        end
                    else
                    end
                    maxDist = dist
                end
            end
            end
        end
    end
    return target
end


local mt = getrawmetatable(game)
local namecallold = mt.__namecall
local index = mt.__index
setreadonly(mt, false)
mt.__namecall = newcclosure(function(self, ...)
    local Args = {...}
    NamecallMethod = getnamecallmethod()
    if tostring(NamecallMethod) == "FindPartOnRayWithIgnoreList" and Client.Combat.WALLBANG then
        table.insert(Args[2], workspace.Map)
    end
    return namecallold(self, ...)
end)

mt.__index=newcclosure(function(a,b)
    if tostring(a)=="HumanoidRootPart"and tostring(b)=="CFrame"then
        if Client.Combat.FORCEBACK then
            if a~=game.Players.LocalPlayer.Character.HumanoidRootPart then
                return CFrame.new(a.Position,game.Players.LocalPlayer.Character.HumanoidRootPart.Position)*CFrame.Angles(0,math.rad(180),0)
           end
        end
    end
    return index(a,b)
end)

setreadonly(mt, true)

local hackers = {}

local function esp(p,cr)
    local h = cr:WaitForChild("Humanoid")
    local hrp = cr:WaitForChild("HumanoidRootPart")

    local text = Drawing.new("Text")
    text.Visible = false
    text.Center = true
    text.Outline = true
    text.Font = 2
    text.Color = Client.Render.ESPCOLOR
    text.Size = 13

	local line = Drawing.new("Line")
    line.Visible = false
    line.Color = Client.Render.ESPCOLOR
    line.Thickness = 1

	local square = Drawing.new("Square")
    square.Visible = false
    square.Color = Client.Render.ESPCOLOR
    square.Thickness = 1

    local triangle = Drawing.new("Circle")
    triangle.Visible = false
    triangle.Color = Client.Render.ESPCOLOR
    triangle.Thickness = 1
	triangle.Radius = 5
	triangle.Thickness = 1
	triangle.Filled = false

    local c1
    local c2
    local c3

    local function dc()
        text.Visible = false
		line.Visible = false
        square.Visible = false
        triangle.Visible = false
        text:Remove()
		line:Remove()
        square:Remove()
        triangle:Remove()
        if c1 then
            c1:Disconnect()
            c1 = nil
        end
        if c2 then
            c2:Disconnect()
            c2 = nil
        end
        if c3 then
            c3:Disconnect()
            c3 = nil
        end
    end

    c2 = cr.AncestryChanged:Connect(function(_,parent)
        if not parent then
            dc()
        end
    end)

    c3 = h.HealthChanged:Connect(function(v)
        if (v<=0) or (h:GetState() == Enum.HumanoidStateType.Dead) then
            dc()
        end
    end)

    c1 = dwRunService.RenderStepped:Connect(function()
        if true then
            local hrp_pos,hrp_onscreen = dwCamera:WorldToViewportPoint(hrp.Position)
            local p_root_pos, p_onscreen = dwCamera:WorldToViewportPoint(dwLocalPlayer.Character:WaitForChild("HumanoidRootPart").Position)
            local cframe = get_pivot(cr);
            local position, visible = dwCamera:WorldToViewportPoint(cframe.Position);
            local headPos, visible = dwCamera:WorldToViewportPoint(cr:WaitForChild("Head").Position);
            local rightFootPos, visible = dwCamera:WorldToViewportPoint(cr:WaitForChild("RightFoot").Position);
            local leftFootPos, visible = dwCamera:WorldToViewportPoint(cr:WaitForChild("LeftFoot").Position);
            local scale_factor = 1 / (position.Z * tan(rad(dwCamera.FieldOfView * 0.5)) * 2) * 100;
            local scale_factorH = 1 / (headPos.Z * tan(rad(dwCamera.FieldOfView * 0.5)) * 2) * 100;
            
            local width, height = floor(35 * scale_factor), floor(50 * scale_factor);
            local v = floor(5 * scale_factorH)
            local x, y = floor(position.X), floor(position.Y);
            if p.Team == dwLocalPlayer.Team then
                text.Color = Client.Render.TEAMESPCOLOR
                square.Color = Client.Render.TEAMESPCOLOR
                line.Color = Client.Render.TEAMESPCOLOR
                triangle.Color = Client.Render.TEAMESPCOLOR
            else
                text.Color = Client.Render.ESPCOLOR
                square.Color = Client.Render.ESPCOLOR
                line.Color = Client.Render.ESPCOLOR
                triangle.Color = Client.Render.ESPCOLOR
            end
            
            if hrp_onscreen and hrp.Position.Y > -300 then
                line.From = Vector2.new(p_root_pos.X, p_root_pos.Y)
                line.To = Vector2.new(hrp_pos.X, floor(y - height * 0.5)+25)
                text.Position = Vector2.new(hrp_pos.X, floor(y - height * 0.5)-25)
                text.Text = p.Name.. " [ "..p:FindFirstChild("Ping").Value.. "ms ]"
                if p:FindFirstChild("Ping").Value > 10000 then
                    if not table.find(hackers, p) then
                        notify("Hacker Detected", p.Name.. "|".. tostring(p:FindFirstChild("Ping").Value))
                        table.insert(hackers, p)
                    end
                end
                square.Size = Vector2.new(width, height);
                square.Position = Vector2.new(floor(x - width * 0.5), floor(y - height * 0.5));

                triangle.Position = Vector2.new(headPos.X,headPos.Y)
                triangle.Radius = v
                if Client.Render.LINEESP then
                    line.Visible = true
                end
                if Client.Render.ESP then
                    text.Visible = true
                end
                if Client.Render.BOXESP then
                    square.Visible = true
                end
                if Client.Render.CIRCESP then
                    triangle.Visible = true
                end
            else
                text.Visible = false
                square.Visible = false
                triangle.Visible = false
            end
        end
		if not Client.Render.ESP then
			text.Visible = false
		end
		if not Client.Render.LINEESP then
			line.Visible = false
		end
		if not Client.Render.BOXESP then
			square.Visible = false
		end
        if not Client.Render.CIRCESP then
            triangle.Visible = false
        end
    end)
end

local function p_added(p)
    if p.Character then
        esp(p,p.Character)
    end
    p.CharacterAdded:Connect(function(cr)
        esp(p,cr)
    end)
end

for i,p in next, dwEntities:GetPlayers() do
    if p ~= lp then
        p_added(p)
    end
end

dwEntities.PlayerAdded:Connect(p_added)

local fovcircle = Drawing.new("Circle")

local fireGun = false

dwUIS.InputBegan:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.MouseButton2 then
        Client.Combat.AIMBOT_SETTINGS.Aiming = true
    end
    if i.UserInputType == Enum.UserInputType.MouseButton1 then
        fireGun = true
    end
end)

dwUIS.InputEnded:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.MouseButton2 then
        Client.Combat.AIMBOT_SETTINGS.Aiming = false
    end
    if i.UserInputType == Enum.UserInputType.MouseButton1 then
        fireGun = false
    end
end)

dwRunService.RenderStepped:Connect(function()
    local mouseLocation = dwUIS:GetMouseLocation()
	fovcircle.Position = Vector2.new(mouseLocation.X, mouseLocation.Y)
	fovcircle.Visible = Client.Combat.AIMBOT_SETTINGS.Aimbot_Draw_FOV
	fovcircle.Radius = Client.Combat.AIMBOT_SETTINGS.Aimbot_FOV_Radius
	fovcircle.Color = Client.Combat.AIMBOT_SETTINGS.Aimbot_FOV_Color
	fovcircle.Thickness = 1
	fovcircle.Filled = false
	fovcircle.Transparency = 1

    local closest_char = getPlayerClosestToMouse()

    if Client.Combat.INFAMMO then
        getsenv(game:GetService("Players").LocalPlayer.PlayerGui.GUI.Client.Functions.Weapons).ammocount.Value = 25
        getsenv(game:GetService("Players").LocalPlayer.PlayerGui.GUI.Client.Functions.Weapons).ammocount.Value = 26
    end

    if Client.Combat.AIMBOT_SETTINGS.Aiming and Client.Movement.AIMBOT then

        if closest_char ~= nil and
        closest_char.Parent:FindFirstChild("HumanoidRootPart") and
        closest_char.Parent:FindFirstChild("Humanoid") and
        closest_char.Parent:FindFirstChild("Humanoid").Health > 0 then
            local tcamcframe = dwCamera.CFrame;
            for i = 0, 1, Client.Combat.LOOKSENS do
                dwCamera.CFrame = tcamcframe:Lerp(CFrame.new(dwCamera.CFrame.p, closest_char.Position-Vector3.new(0,Client.Combat.AIMBOT_SETTINGS.Aimbot_offSet,0)), i)
            end
        end
    end
end)

local addString = ""

if Request("mode") then
    addString = " | Dev Mode"
end

local win = OrionLib:MakeWindow({Name = "Grimware".. addString, HidePremium = not Request("mode"), SaveConfig = true, ConfigFolder = "Grimware", IntroText="Grimware".. addString})

local Main = win:MakeTab({
	Name = "Main",
	PremiumOnly = false
})


local Combat = win:MakeTab({
	Name = "Combat",
	PremiumOnly = false
})
local GunMods = win:MakeTab({
	Name = "Gun Mods",
	PremiumOnly = false
})
local Movement = win:MakeTab({
	Name = "Movement",
	PremiumOnly = false
})
local Character = win:MakeTab({
	Name = "Character",
	PremiumOnly = false
})
local Render = win:MakeTab({
	Name = "Render",
	PremiumOnly = false
})
local Stats = win:MakeTab({
	Name = "Stats",
	PremiumOnly = false
})

local MainSection = Main:AddSection({
	Name = "Version 0.5.4"
})
local CombatSection = Combat:AddSection({
	Name = "Combat"
})
local GunModsSection = GunMods:AddSection({
	Name = "Gun Mods"
})
local MovementSection = Movement:AddSection({
	Name = "Movement"
})
local CharacterSection = Character:AddSection({
	Name = "Character"
})
local RenderSection = Render:AddSection({
	Name = "Render"
})
local StatsSection = Stats:AddSection({
	Name = "Stats"
})

local m2 = MainSection:AddLabel("Added Stats Tab")
local m3 = MainSection:AddLabel("Fixed Aimbot WallCheck")
local m4 = MainSection:AddLabel("Added Gun Mods")


function notify(title,text)
    print("• "..title)
    print("• "..text)
    if not Client.Render.NOTIFY then return end
	OrionLib:MakeNotification({
        Name = title,
        Content = text,
        Time = 2.5
    })
end

dwLocalPlayer.CharacterAdded:connect(function(Character)
	if Client.Combat.USED_RE then
		notify("Respawn", "Respawn success!")
		Client.Combat.USED_RE = false
	end
end)

-- Combat

CombatSection:AddToggle({
	Name = "Aimbot",
	Default = false,
    Flag = "aimbot",
    Save = true,
	Callback = function(t)
		Client.Movement.AIMBOT = t
	end    
})

CombatSection:AddToggle({
	Name = "Wallbang",
	Default = false,
    Flag = "wallbang",
    Save = true,
	Callback = function(t)
		Client.Combat.WALLBANG = t
	end    
})

CombatSection:AddToggle({
	Name = "Teamcheck",
    Flag = "TCaimbot",
	Default = true,
    Save = true,
	Callback = function(t)
		Client.Combat.AIMBOT_SETTINGS.Aimbot_TeamCheck = t
	end    
})

CombatSection:AddToggle({
	Name = "WallCheck",
    Flag = "WCaimbot",
	Default = true,
    Save = true,
	Callback = function(t)
		Client.Combat.AIMBOT_SETTINGS.WallCheck = t
	end    
})

CombatSection:AddDropdown({
	Name = "Aim Part",
	Default = "Head",
	Options = {"Head", "UpperTorso", "LowerTorso"},
	Callback = function(Value)
		Client.Combat.AIMBOT_SETTINGS.Aimbot_AimPart = Value
	end
})


CombatSection:AddSlider({
	Name = "Aimbot Sens (Higher is slower)",
    Flag = "aimSens",
    Save = true,
	Min = 60,
	Max = 200,
	Default = 60,
	Color = Color3.fromRGB(9, 99, 195),
	Increment = 0.01,
	ValueName = "Offset",
	Callback = function(t)
		Client.Combat.LOOKSENS = 1/t
	end    
})

CombatSection:AddSlider({
	Name = "Aimbot OffSet",
    Flag = "aimbotOff",
    Save = true,
	Min = 0,
	Max = 2,
	Default = 0,
	Color = Color3.fromRGB(9, 99, 195),
	Increment = 0.1,
	ValueName = "Offset",
	Callback = function(t)
		Client.Combat.AIMBOT_SETTINGS.Aimbot_offSet = t
	end    
})


CombatSection:AddSlider({
	Name = "FOV",
    Flag = "aimbotFOV",
    Save = true,
	Min = 10,
	Max = 500,
	Default = 100,
	Color = Color3.fromRGB(9, 99, 195),
	Increment = 0.5,
	ValueName = "FOV",
	Callback = function(t)
		Client.Combat.AIMBOT_SETTINGS.Aimbot_FOV_Radius = t
	end    
})

-- Movement

MovementSection:AddBind({
	Name = "Fly",
    Flag = "fly",
    Save = true,
	Default = Enum.KeyCode.F,
	Hold = false,
	Callback = function()
		Client.Movement.FLYHELD = not Client.Movement.FLYHELD
        if Client.Movement.FLYHELD then
            notify("Fly", "Toggled on")
        else
            notify("Fly", "Toggled off")
            dwLocalPlayer.Character:WaitForChild("HumanoidRootPart").Velocity = Vector3.new(0,0,0)
        end
        local lastD = false
        while Client.Movement.FLYHELD do
            if (dwLocalPlayer.Character:WaitForChild("Humanoid").FloorMaterial == Enum.Material.Air) then
                dwLocalPlayer.Character:WaitForChild("HumanoidRootPart").Velocity = (dwLocalPlayer.Character:WaitForChild("Humanoid").MoveDirection*Vector3.new(Client.Movement.FS,2,Client.Movement.FS))
                local curVel = dwLocalPlayer.Character:WaitForChild("HumanoidRootPart").Velocity
                if Client.Movement.B then
                    if not lastD then

                        dwLocalPlayer.Character:WaitForChild("HumanoidRootPart").Velocity = Vector3.new(0,-NumBypass-_G.FB,0)
                    else
                        dwLocalPlayer.Character:WaitForChild("Humanoid").Jump = true
                        dwLocalPlayer.Character:WaitForChild("HumanoidRootPart").Velocity = Vector3.new(0,NumBypass+_G.FB,0)
                    end
                else
                    if not lastD then
                        dwLocalPlayer.Character:WaitForChild("HumanoidRootPart").Velocity = Vector3.new(0,0,0)
                    end
                end

                lastD = not lastD
            end
            wait()
        end
	end    
})


MovementSection:AddBind({
	Name = "Bhop",
    Flag = "bhop",
    Save = true,
	Default = Enum.KeyCode.X,
	Hold = false,
	Callback = function()
		Client.Movement.BHOPHELD = not Client.Movement.BHOPHELD
        if Client.Movement.BHOPHELD then
            notify("Bhop", "Toggled on")
        else
            notify("Bhop", "Toggled off")
            dwLocalPlayer.Character:WaitForChild("HumanoidRootPart").Velocity = Vector3.new(0,0,0)
        end
        while Client.Movement.BHOPHELD do
            if (dwLocalPlayer.Character:WaitForChild("Humanoid").FloorMaterial ~= Enum.Material.Air) and Client.Movement.BHOPJUMP then
                dwLocalPlayer.Character:WaitForChild("Humanoid").Jump = true
                dwLocalPlayer.Character:WaitForChild("HumanoidRootPart").Velocity = Vector3.new(0,Client.Movement.JPU,0)
            else
                dwLocalPlayer.Character:WaitForChild("HumanoidRootPart").Velocity = (dwLocalPlayer.Character:WaitForChild("Humanoid").MoveDirection*Vector3.new(Client.Movement.WS,0,Client.Movement.WS))
                local curVel = dwLocalPlayer.Character:WaitForChild("HumanoidRootPart").Velocity
                if Client.Movement.BHOPJUMP then
                    dwLocalPlayer.Character:WaitForChild("HumanoidRootPart").Velocity = Vector3.new(curVel.X,-Client.Movement.JP,curVel.Z)
                end
            end
            wait()
        end
        dwLocalPlayer.Character:WaitForChild("HumanoidRootPart").Velocity = Vector3.new(0,0,0)
	end
})

MovementSection:AddBind({
	Name = "Launch",
	Default = Enum.KeyCode.Z,
    Flag = "launch",
    Save = true,
	Hold = false,
	Callback = function()
		if (dwLocalPlayer.Character:WaitForChild("Humanoid").FloorMaterial ~= Enum.Material.Air) then
            dwLocalPlayer.Character:WaitForChild("Humanoid").Jump = true
            dwLocalPlayer.Character:WaitForChild("HumanoidRootPart").Velocity = Vector3.new(0,NumBypass,0)
            wait(0.3)
            dwLocalPlayer.Character:WaitForChild("HumanoidRootPart").Velocity = Vector3.new(0,-NumBypass,0)
            notify("Launch", "Waiting for land...")
            repeat
                wait()
            until (dwLocalPlayer.Character:WaitForChild("Humanoid").FloorMaterial ~= Enum.Material.Air)
            dwLocalPlayer.Character:WaitForChild("Humanoid").Jump = true
            wait(0.1)
            notify("Launch", "Launching...")
            dwLocalPlayer.Character:WaitForChild("HumanoidRootPart").Velocity = (dwLocalPlayer.Character:WaitForChild("Humanoid").MoveDirection*Vector3.new(50,0,50))
            local curVel = dwLocalPlayer.Character:WaitForChild("HumanoidRootPart").Velocity
            dwLocalPlayer.Character:WaitForChild("HumanoidRootPart").Velocity = Vector3.new(curVel.X,Client.Movement.LS,curVel.Z)
        else
            notify("Launch", "Please stand on the ground before using.")
        end
	end    
})

MovementSection:AddToggle({
	Name = "Fly Bounce",
    Flag = "flyBounce",
    Save = true,
	Default = true,
	Callback = function(t)
		Client.Movement.B = t
	end   
})

MovementSection:AddSlider({
	Name = "Fly Speed",
    Flag = "flySpeed",
    Save = true,
	Min = 1,
	Max = 100,
	Default = 25,
	Color = Color3.fromRGB(9, 99, 195),
	Increment = 0.5,
	ValueName = "Speed",
	Callback = function(t)
		Client.Movement.FS = t
	end    
})

MovementSection:AddSlider({
	Name = "Fly Bounce",
    Flag = "flyBounce",
    Save = true,
	Min = 0,
	Max = 100,
	Default = 25,
	Color = Color3.fromRGB(9, 99, 195),
	Increment = 0.5,
	ValueName = "Bounce",
	Callback = function(t)
		_G.FB = t
	end    
})

MovementSection:AddToggle({
	Name = "Bhop Jump",
    Flag = "bhopJump",
    Save = true,
	Default = true,
	Callback = function(t)
		Client.Movement.BHOPJUMP = t
	end
})

MovementSection:AddSlider({
	Name = "Bhop Speed",
    Flag = "bhopSpeed",
    Save = true,
	Min = 1,
	Max = 100,
	Default = 50,
	Color = Color3.fromRGB(9, 99, 195),
	Increment = 0.5,
	ValueName = "Speed",
	Callback = function(t)
		Client.Movement.WS = t
	end    
})

MovementSection:AddSlider({
	Name = "Bhop Fall Speed",
    Flag = "bhopFallSpeed",
    Save = true,
	Min = 10,
	Max = 75,
	Default = 25,
	Color = Color3.fromRGB(9, 99, 195),
	Increment = 0.5,
	ValueName = "Fall Speed",
	Callback = function(t)
		_G.JP = t
	end    
})

MovementSection:AddSlider({
	Name = "Bhop Jump Velocity",
    Flag = "bhopJumpVel",
    Save = true,
	Min = 10,
	Max = 75,
	Default = 50,
	Color = Color3.fromRGB(9, 99, 195),
	Increment = 0.5,
	ValueName = "Jump Velocity",
	Callback = function(t)
		Client.Movement.JPU = t
	end    
})

MovementSection:AddSlider({
	Name = "Launch Speed",
    Flag = "bhopJumpVel",
    Save = true,
	Min = 50,
	Max = 250,
	Default = 25,
	Color = Color3.fromRGB(9, 99, 195),
	Increment = 0.5,
	ValueName = "Velocity",
	Callback = function(t)
		Client.Movement.LS = t
	end
})

-- Gun Mods

GunModsSection:AddToggle({
	Name = "Firerate",
	Default = false,
    Flag = "firerate",
    Save = true,
	Callback = function(t)
        Client.Combat.FIRERATE = t
        getsenv(game.Players.LocalPlayer.PlayerGui.GUI.Client).givetools()
        require(game.Players.LocalPlayer.PlayerGui.GUI.Client.Functions.Weapons).usethatgun()
	end    
})

GunModsSection:AddToggle({
	Name = "Backstab Only",
	Default = false,
    Flag = "bstab",
    Save = true,
	Callback = function(t)
        Client.Combat.FORCEBACK = t
	end    
})


GunModsSection:AddToggle({
	Name = "Inf Kniferange",
	Default = false,
    Flag = "Kniferange",
    Save = true,
	Callback = function(t)
        for _,v in pairs(game.ReplicatedStorage.Weapons:GetChildren())do
            if v:FindFirstChild("Range")and v:FindFirstChild("Melee")and v:FindFirstChild("Backstab")then
                v.Range.Value=100000
            end
        end
        getsenv(game.Players.LocalPlayer.PlayerGui.GUI.Client).givetools()
        require(game.Players.LocalPlayer.PlayerGui.GUI.Client.Functions.Weapons).usethatgun()
	end    
})

GunModsSection:AddToggle({
	Name = "Instant Reload",
	Default = false,
    Flag = "Kniferange",
    Save = true,
	Callback = function(t)
        for _,v in pairs(game.ReplicatedStorage.Weapons:GetChildren())do
            if t then
                if v:FindFirstChild("ReloadTime")then
                    v.ArsoniaReloadTime.Value=0
                end
                if v:FindFirstChild("EReloadTime")then
                    v.ArsoniaEReloadTime.Value=0
                end
                if v:FindFirstChild("PumpAction")then
                    v.PumpAction.Name="NotPumpAction"
                end
            end
        end
        getsenv(game.Players.LocalPlayer.PlayerGui.GUI.Client).givetools()
        require(game.Players.LocalPlayer.PlayerGui.GUI.Client.Functions.Weapons).usethatgun()
	end    
})

GunModsSection:AddToggle({
	Name = "Infinite Ammo",
	Default = false,
    Flag = "infammo",
    Save = true,
	Callback = function(t)
		Client.Combat.INFAMMO = t
	end    
})

-- Character


CharacterSection:AddToggle({
	Name = "AutoFarm",
    Flag = "aFarm",
	Default = false,
    Save = true,
	Callback = function(t)
		Client.Combat.AUTOFARM = t
        while Client.Combat.AUTOFARM do
            for _,v in pairs(dwEntities:GetChildren()) do
                pcall(function()
                    if not v.Character and not v.Character:FindFirstChild("Humanoid") and v.Character.Humanoid.Health == 0 and not v.Character:FindFirstChild("HumanoidRootPart") or v == dwLocalPlayer or v.Team == dwLocalPlayer.Team then
                        return
                    end
                    local c = v.Character
                    repeat
                        dwLocalPlayer.Character.HumanoidRootPart.Velocity = Vector3(0, NumBypass, 0)
                        dwLocalPlayer.Character.HumanoidRootPart.Velocity = Vector3(0, -NumBypass, 0)
                        local player_cframe =  v.Character:FindFirstChild("HumanoidRootPart").CFrame * CFrame.fromEulerAnglesXYZ(math.rad(0), 0, 0) * CFrame.new(0, 0, 6)
                    
                        dwLocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(player_cframe.Position + Vector3.new(0,math.random(-4,4),0),c[Client.Combat.AIMBOT_SETTINGS.Aimbot_AimPart].Position)
                        wait()
                        dwCamera.CFrame = CFrame.new(dwCamera.CFrame.Position, c[Client.Combat.AIMBOT_SETTINGS.Aimbot_AimPart].Position)
                        require(game.Players.LocalPlayer.PlayerGui.GUI.Client.Functions.Weapons).firebullet()
                        wait()
                        
                    until v.Character:FindFirstChild("HumanoidRootPart").Position.Y < -300 or not Client.Combat.AUTOFARM or v.Team == dwLocalPlayer.Team
                end)
                
            end
            wait()
        end
	end    
})

-- Render

RenderSection:AddColorpicker({
	Name = "Team ESP Color",
    Flag = "TeamespColor",
    Save = true,
	Default = Color3.fromRGB(0, 204, 255),
	Callback = function(Value)
		Client.Render.TEAMESPCOLOR = Value
	end	  
})

RenderSection:AddColorpicker({
	Name = "ESP Color",
    Flag = "espColor",
    Save = true,
	Default = Color3.fromRGB(255, 0, 38),
	Callback = function(Value)
		Client.Render.ESPCOLOR = Value
	end	  
})

RenderSection:AddToggle({
	Name = "FOV Circle",
    Flag = "fovCircle",
    Save = true,
	Default = true,
	Callback = function(t)
		Client.Combat.AIMBOT_SETTINGS.Aimbot_Draw_FOV = t
	end   
})

RenderSection:AddToggle({
	Name = "NameTag ESP",
    Save = true,
    Flag = "nametagESP",
	Default = false,
	Callback = function(t)
		Client.Render.ESP = t
	end    
})

RenderSection:AddToggle({
	Name = "Box ESP",
    Flag = "boxESP",
    Save = true,
	Default = false,
	Callback = function(t)
		Client.Render.BOXESP = t
	end    
})

RenderSection:AddToggle({
	Name = "Circle ESP",
    Flag = "circlesESP",
    Save = true,
	Default = false,
	Callback = function(t)
		Client.Render.CIRCESP = t
	end    
})

RenderSection:AddToggle({
	Name = "Tracers",
    Flag = "tracersESP",
    Save = true,
	Default = false,
	Callback = function(t)
		Client.Render.LINEESP = t
	end    
})

RenderSection:AddToggle({
	Name = "Notifications",
    Flag = "notify",
    Save = true,
	Default = true,
	Callback = function(t)
		Client.Render.NOTIFY = t
	end   
})


local dev = StatsSection:AddLabel("Dev Mode: OFF")
local ping = StatsSection:AddLabel("Ping: INF")
local fps = StatsSection:AddLabel("FPS: 0")

spawn(function()
    while wait() do
        dwAlive = dwLocalPlayer:WaitForChild("Status", 1337):WaitForChild("Alive").Value;
        if Client.Combat.AUTOFARM and not dwAlive then
            AutoSpawn()
        end
        pcall(function()
            dev:Set("Dev Mode: ".. tostring(Request("mode")))
            ping:Set("Ping: ".. tostring(Request("ping")))
            fps:Set("FPS: ".. tostring(Request("fps")))
        end)
    end
end)

spawn(function()
    while wait(0.03) do
        if fireGun and Client.Combat.FIRERATE then
            require(game.Players.LocalPlayer.PlayerGui.GUI.Client.Functions.Weapons).firebullet()
        end
    end
end)