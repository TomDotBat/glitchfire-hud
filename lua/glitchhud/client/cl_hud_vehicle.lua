

surface.CreateFont("Vehicle_Skin_Large", {
    font = "Roboto",
    size = 24,
    weight = 700,
    antialias = true,
})


surface.CreateFont("Vehicle_Skin_Small", {
    font = "Roboto",
    size = 18,
    weight = 500,
    antialias = true,
})

--Create some vars.
local vehicleBoxHeight = 60
local textBottomMargin = vehicleBoxHeight * 0.13

--Get vehicles list.
local vehicleList

--Vehicle overhead display.
hook.Add("HUDPaint","GFVehicleOverhead",function()
	local ply = LocalPlayer()
	local scrw, scrh = ScrW(), ScrH()

	vehicleList = vehicleList or list.Get("Vehicles")

	if ply:InVehicle() then return end

	local eyeTrace = ply:GetEyeTrace()
	local v = eyeTrace.Entity
	if !IsValid(v) then return end
	if !v:IsVehicle() then return end

	local class = v:GetClass()
	if class == "prop_vehicle_prisoner_pod" then return end
	if ply:GetPos():DistToSqr( v:GetPos() ) > 200^2 then return end

	--Get the veheicleData.
	local vehicleData = v:getDoorData()

	--Create a var for the vehicle name and title.
	local name = ""
	local owner = ""

	--Get the vehicle classname.
	local vehicleClass = v:GetVehicleClass()

	--Set the name of the vehicle.
	if vehicleData.title then
		name = vehicleData.title
	elseif vehicleClass and vehicleList[vehicleClass] then
		name = vehicleList[vehicleClass].Name
	else
		name = "Vehicle"
	end

	--Check who is the owner of the vehicle.
	if vehicleData.groupOwn then
		owner = vehicleData.groupOwn
	elseif vehicleData.nonOwnable then
		owner = "Not ownable"
	elseif vehicleData.teamOwn then
		owner = vehicleData.teamOwn .. " only"
	elseif vehicleData.owner then
		local vehicleOwner = Player(vehicleData.owner)
		if IsValid(vehicleOwner) then
			owner = "Owned by " ..vehicleOwner:Name()
		else
			owner = "Invalid Owner"
		end
	else
		owner = "Unowned"
	end

	--Set character limits.
	name = string.Left(name,40)
	owner = string.Left(owner,35)

	--Get the text size of the name.
	surface.SetFont("Vehicle_Skin_Large")
	local nameTextWidth, _ = surface.GetTextSize(name)

	--Get the text size of the owner.
	surface.SetFont("Vehicle_Skin_Small")
	local ownerTextWidth, _ = surface.GetTextSize(owner)

	--Calculate the boxPos and boxWidth..
	local vehicleBoxWidth = math.max(nameTextWidth,ownerTextWidth) + 40

	--Draw the gray square.
	surface.SetDrawColor(glitchhhud_config.backgroundCol)
	surface.DrawRect(scrw / 2 - vehicleBoxWidth / 2,scrh/2 + 300 - vehicleBoxHeight,vehicleBoxWidth,vehicleBoxHeight)

	--Draw info.
	draw.SimpleText(name,"Vehicle_Skin_Large",scrw / 2,scrh/2 + 300 - vehicleBoxHeight + textBottomMargin, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
	draw.SimpleText(owner,"Vehicle_Skin_Small",scrw / 2,scrh/2 + 300 - textBottomMargin, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM)
end)

hook.Add("VC_CD_canRenderInfo", "GFHideCarDealerHUD", function(ent, text)
	return false
end)

hook.Add("VC_RM_canRenderInfo", "GFHideRepairHUD", function(ent, text)
	return false
end)

local speed = nil
local health = nil
local isCruising = false
local isDriver = false

net.Receive("GFHUDDriverUpdate", function(len)
	isDriver = net.ReadBool()
end)

--MPH - math.floor(veh:GetVelocity():Length() / (12 * 5280 / 3600)) .. " MPH"
--KPH - math.floor(veh:GetVelocity():Length() / (12 * 3280.84 / 3600)) .. " KPH"
hook.Add("Tick", "GlitchHUDVehicle", function()
	if isDriver then
		local ply = LocalPlayer()
		if !IsValid(ply) then return end

		local veh = ply:GetVehicle()
		if !IsValid(veh) then return end
		speed = math.Round(veh:GetVelocity():Length() / 17.6) .. " MPH"
		
		if VC and veh.VC_getHealth then
			health = math.Round(veh:VC_getHealth(true)) .. " HP"
			isCruising = veh:VC_getCruise()
		end

		return
	end

	speed = nil
	health = nil
	isCruising = false
end)

local cruiseY = 80
hook.Add("HUDPaint","GFVehicleStats", function()
	if !isDriver or !speed or !health then return end

	local sw, sh = ScrW(), ScrH()

	surface.SetFont("GlitchHUDPlayerInfo")
	local hw = surface.GetTextSize(health)

	local woff = sw - 20 - (hw + 50)

    surface.SetDrawColor(glitchhhud_config.backgroundCol)
    surface.DrawRect(woff, sh - 70, hw + 40, 40)

    woff = woff + (hw + 20)

    draw.SimpleText(health, "GlitchHUDPlayerInfo", woff - (hw / 2), sh - 51, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

	local spw = surface.GetTextSize(speed)

	woff = woff - spw - hw - 70

    surface.SetDrawColor(glitchhhud_config.backgroundCol)
    surface.DrawRect(woff, sh - 70, spw + 40, 40)

	woff = woff + (spw + 20)

    draw.SimpleText(speed, "GlitchHUDPlayerInfo", woff - (spw / 2), sh - 51, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

    if isCruising then
    	cruiseY = Lerp(FrameTime() * 10, cruiseY, 0)
	else
    	cruiseY = Lerp(FrameTime() * 10, cruiseY, 80)
    end

    local crw = surface.GetTextSize("Cruising")

	woff = woff - crw - spw - 70

    surface.SetDrawColor(glitchhhud_config.backgroundCol)
    surface.DrawRect(woff, cruiseY + sh - 70, crw + 40, 40)

	woff = woff + (crw + 20)

    draw.SimpleText("Cruising", "GlitchHUDPlayerInfo", woff - (crw / 2), cruiseY + sh - 51, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
end)

timer.Create("GFHUDRemoveVCMod",1,0,function()
	hook.Remove("HUDPaint","VC_HUDPaint")
end)