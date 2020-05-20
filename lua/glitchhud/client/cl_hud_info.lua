surface.CreateFont("GlitchHUDPlayerInfo", {
    font = "Roboto",
    size = 22,
    weight = 500,
})

local name = ""
local job = ""
local money = 0
local smoothedMoney = 0
local salary = ""

local isArrested = false

local shouldDrawAmmo = false
local isLicensed = false
local clip = 0
local maxClip = 0

local function drawPlyInfo(ply)
	smoothedMoney = Lerp(FrameTime() * 10, smoothedMoney, money)

	local woff = 30

	//Draw name box and text
	local nw = surface.GetTextSize(name)
	nw = nw + 40

    surface.SetDrawColor(glitchhhud_config.backgroundCol)
    surface.DrawRect(30, 30, nw, 40)

    draw.SimpleText(name, "GlitchHUDPlayerInfo", woff + nw / 2, 50, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

	woff = woff + nw + 10

	//Draw job box and text
	local jw = surface.GetTextSize(job)
	jw = jw + 40

    surface.SetDrawColor(glitchhhud_config.backgroundCol)
    surface.DrawRect(woff, 30, jw, 40)

    draw.SimpleText(job, "GlitchHUDPlayerInfo", woff + jw / 2, 50, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

    //Draw money/salary box and text
    if isArrested then return end
    local finalisedMoney = DarkRP.formatMoney(math.Round(smoothedMoney))

	local mw = surface.GetTextSize(finalisedMoney)
	local sw = surface.GetTextSize(salary)

    surface.SetDrawColor(glitchhhud_config.backgroundCol)
    surface.DrawRect(30, 80, mw + sw + 60, 40)

    draw.SimpleText(finalisedMoney, "GlitchHUDPlayerInfo", 50 + mw / 2, 101, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

    draw.SimpleText(salary, "GlitchHUDPlayerInfo", 70 + mw + sw / 2, 101, glitchhhud_config.salaryCol, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
end

local function drawAmmo(ply, wep)

	if clip >= 0 then
		local sw, sh = ScrW(), ScrH()

		local counter = tostring(clip) .. " / " .. maxClip

		local tw = surface.GetTextSize("Ammo")
		local cw = surface.GetTextSize(counter)

		local woff = sw - 30 - (tw + cw + 50)

	    surface.SetDrawColor(glitchhhud_config.backgroundCol)
	    surface.DrawRect(woff, sh - 70, tw + cw + 50, 40)

	    woff = woff + (tw + cw + 30)

	    draw.SimpleText("Ammo", "GlitchHUDPlayerInfo", woff - cw - 10 - (tw / 2), sh - 51, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

	    draw.SimpleText(counter, "GlitchHUDPlayerInfo", woff - (cw / 2), sh - 51, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

        if isLicensed then
			local lw = surface.GetTextSize("Licensed")

        	woff = sw - lw - 80 - (tw + cw + 50)

		    surface.SetDrawColor(glitchhhud_config.backgroundCol)
		    surface.DrawRect(woff, sh - 70, lw + 40, 40)

        	woff = woff + lw + 20

		    draw.SimpleText("Licensed", "GlitchHUDPlayerInfo", woff - (lw / 2), sh - 51, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

        end
    end

end

hook.Add("Tick", "GlitchHUDInfo", function()
	local ply = LocalPlayer()

	if (!IsValid(ply)) then return end

	name = ply:GetName()
	job = ply:getDarkRPVar("job")
	money = ply:getDarkRPVar("money")
	salary = "+ " .. DarkRP.formatMoney(ply:getDarkRPVar("salary"))
	isLicensed = ply:getDarkRPVar("HasGunlicense")
	isArrested = ply:getDarkRPVar("Arrested")

	if (!smoothedMoney) then smoothedMoney = 0 end

	local curWeapon = ply:GetActiveWeapon()
	if ply:Health() > 0 and IsValid(curWeapon) then
		shouldDrawAmmo = true
		clip = curWeapon:Clip1()
		maxClip = tostring(ply:GetAmmoCount(curWeapon:GetPrimaryAmmoType()))
	end
end)

hook.Add("HUDPaint", "GlitchHUDInfo", function()
	local ply = LocalPlayer()
    if ply:Health() < 1 then return end

	surface.SetFont("GlitchHUDPlayerInfo")
	
	drawPlyInfo()

	if shouldDrawAmmo then
		drawAmmo(ply, ply:GetActiveWeapon())
	end
end)

local hiddenHUDElements = {
    CHudHealth = true,
    CHudBattery = true,
    CHudDamageIndictator = true,
    CHudZoom = true,
    CHudAmmo = true,
    CHudSecondaryAmmo = true,
    CHudDeathNotice = true
}

hook.Add("HUDShouldDraw", "GM_HideDefaultHUD", function(name)
    if (hiddenHUDElements[name]) then return false end
end)

hook.Add("HUDDrawTargetID", "GM_RemoveTarget", function()
    return false
end)

hook.Add("DrawDeathNotice", "GM_RemoveDeathFeed", function()
    if (not LocalPlayer():IsSuperAdmin()) then return false end
end)