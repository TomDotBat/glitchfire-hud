
local mapSettings = glitchhhud_config.maps["rp_evocity_v33x"]--glitchhhud_config.maps[game.GetMap()]

local pad = 5
local marginLeft = 35
local marginBottom = 50
local w, h = 0, 0
local x, y = 0, 0
local rot = 0
local lerpedRot = Angle()
local curVelocityScale = 0

gfMapTextures = {}
gfMapTextures[1] = mapSettings.texture --Material('aaa/mapreal.png', 'smooth');
gfMapTextures[2] = Material('glitchfire/minimap/underground1.png', 'smooth');
gfMapTextures[3] = Material('glitchfire/minimap/underground2.png', 'smooth');

local scaleCvar = CreateClientConVar("gf_minimap_scale", 20, true, false, "The scale of the ingame minimap.");

function gfGetAreaNum(pos)
    if pos:WithinAABox(Vector(-5023.21875, 629.4375, -323.0625), Vector(-4069.625, 1047.46875, -36.03125)) or pos:WithinAABox(Vector(2545.875, 4337.78125, -140.34375), Vector(3550.78125, 4988, -323.625)) then
        return 1
    elseif pos:WithinAABox(Vector(-4619.15625, 7952.5625, -220.59375), Vector(3220.4375, -2124.09375, -1147.59375)) or pos:WithinAABox(Vector(3204.25, 441.34375, -220.59375), Vector(4962.09375, 4769.375, -1470.46875)) then
    	if pos.z < -438 then
	        return 3
	    else
	        return 2
	    end
    end

    return 1
end

local function DrawTexturedRectRotatedPoint(x, y, w, h, rot, x0, y0)
    local c = math.cos(math.rad(rot))
    local s = math.sin(math.rad(rot))

    local newx = y0 * s - x0 * c
    local newy = y0 * c + x0 * s

    surface.DrawTexturedRectRotated(x + newx, y + newy, w, h, rot)
end

local function DrawFilledBar(x, y, w, h, fill, color1, color2)
    surface.SetDrawColor(color1);
    surface.DrawRect(x, y, w, h);
    surface.SetDrawColor(color2);
    surface.DrawRect(x, y, w*fill, h);
end

local offsetx, offsety = mapSettings.offsetx, mapSettings.offsety
local function WorldToMap(pos, scale)
	pos.x = pos.x + offsetx
	pos.y = pos.y + offsety

	local mapScale = (scale / 1024)*mapSettings.scale
	local x,y = pos.x * mapScale, pos.y * mapScale

	return x,y
end

local function GetWaypointPos(pos, plypos, scale, clamp)
	pos.x = pos.x + offsetx
	pos.y = pos.y + offsety
	local mapScale = (scale / 1024)*mapSettings.scale

    local magnitude = (pos - plypos) * mapScale
    local magnitude2D = magnitude:Length2D()
    local ang = Angle(0, -rot, 0) - magnitude:Angle()
    
    local wx = math.cos(math.rad(ang.y)) * magnitude2D
    local wy = math.sin(math.rad(ang.y)) * magnitude2D

    if (clamp) then 
        wx = math.Clamp(wx, -w/2 + pad, w/2 - pad);
        wy = math.Clamp(wy, -h/2 + pad, h/2 - pad);
    end

    return wx, wy
end

local lerp = Lerp
local lerpang = LerpAngle
local ft = FrameTime

hook.Add("HUDPaint", "GlitchMinimap", function()
	--mapSettings = glitchhhud_config.maps[game.GetMap()]
	--offsetx, offsety = mapSettings.offsetx, mapSettings.offsety
	local scrw, scrh = ScrW(), ScrH()
	local ftime = ft()

	w, h = scrw*0.152, scrw*0.095
	x, y = marginLeft, scrh - h - marginBottom

	local cx, cy = x + w*.5, y + h*.5

	local ply = LocalPlayer()

	--[[-------------------------------------------------------------------------
	Draw Background
	---------------------------------------------------------------------------]]
	local vx, vy = x - pad, y - pad
	local vw, vh = w + pad * 2, h + pad * 3 + 10

	surface.SetDrawColor(glitchhhud_config.backgroundCol)
    surface.DrawRect(vx, vy, vw, vh)

    --[[-------------------------------------------------------------------------
	Draw Vitals
	---------------------------------------------------------------------------]]
    local hp = math.Clamp(ply:Health() / 100, 0, 1)
    DrawFilledBar(vx + pad, vy + vh - pad*3, vw*0.6, pad*2, hp, glitchhhud_config.healthBgCol, glitchhhud_config.healthCol)
    local ar = math.Clamp(ply:Armor() / 255, 0, 1)
    DrawFilledBar(vx + pad + vw*0.6, vy + vh - pad*3, vw*0.4 - pad*2, pad*2, ar, glitchhhud_config.armourBgCol, glitchhhud_config.armourCol)

    --[[-------------------------------------------------------------------------
    Draw Minimap
    ---------------------------------------------------------------------------]]
    surface.SetDrawColor(glitchhhud_config.mapBgCol)
    surface.DrawRect(x, y, w, h)

	local veh = ply:InVehicle() and ply:GetVehicle()
	rot = veh and -(veh:GetAngles().y) or -(ply:EyeAngles().y - 90)

	lerpedRot = lerpang(20 * ftime, lerpedRot, Angle(0, rot, 0));

	local velocityScale = veh and math.Clamp((veh:GetVelocity():Length2D() / 1024) + 1, 1, 2) or math.Clamp((ply:GetVelocity():Length2D() / 1000) + 1, 1, 2)
    curVelocityScale = lerp(5 * ftime, curVelocityScale, velocityScale)
    local scale = scaleCvar:GetInt() * 1/curVelocityScale

    local eyepos = ply:EyePos()
	local plyArea = gfGetAreaNum(eyepos)
	local mapposx, mapposy = WorldToMap(eyepos, scale)

	surface.SetDrawColor(color_white);
    surface.SetMaterial(gfMapTextures[plyArea])

    render.SetScissorRect(marginLeft, y + h, marginLeft + w, y, true)
        DrawTexturedRectRotatedPoint(cx, cy, (1024 * scale)*.1, (1024 * scale)*.1, rot, mapposx, mapposy)
    render.SetScissorRect(0, 0, 0, 0, false)	


    --[[-------------------------------------------------------------------------
    Draw Localplayer
    ---------------------------------------------------------------------------]]
	local icoSize = scrw*0.011

	surface.SetDrawColor(color_white);
    surface.SetMaterial(glitchhhud_config.icons["Player"]);
    surface.DrawTexturedRectRotated(cx, cy, icoSize, icoSize, rot - lerpedRot.y);

    --[[-------------------------------------------------------------------------
    Draw Waypoints
    ---------------------------------------------------------------------------]]
    icoSize = scrw*0.013

    for k,v in next, ents.FindByClass("minimap_waypoint_*") do 
    	local worldPos = v:GetPos()
    	if gfGetAreaNum(worldPos) != plyArea then continue end

        local wx, wy = GetWaypointPos(worldPos, eyepos, scale, true)
       
        local color = v:GetWaypointColor()

        surface.SetDrawColor(Color(color.x, color.y, color.b, 255))
        surface.SetMaterial(glitchhhud_config.icons[v:GetWaypointMaterial()])
        surface.DrawTexturedRect(cx + wx - icoSize*.5, cy + wy - icoSize*.5, icoSize, icoSize)
    end
end)