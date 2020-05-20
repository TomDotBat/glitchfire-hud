surface.CreateFont("GlitchHUDAd", {
    font = "Roboto",
    size = 24,
    weight = 500
})

surface.CreateFont("GlitchHUDNLR", {
    font = "Roboto",
    size = 24,
    weight = 500
})

surface.CreateFont("GlitchHUDJailed", {
    font = "Roboto",
    size = 24,
    weight = 500
})

local adText = ""
local showAd = false
local adY = 0

local nlrY = 0
local isNLR = false

local jailY = 0
local isJailed = false
local jailStart = 0
local jailUntil = 0
local jailTimeLeft = 0

hook.Add("Tick", "GlitchHUDCheckJail", function()
    local ply = LocalPlayer()
    if !IsValid(ply) then return end
    
    isJailed = ply:getDarkRPVar("Arrested") or false
    jailTimeLeft = math.max(math.ceil(jailUntil - (CurTime() - jailStart)), 0)

    --if jailTimeLeft < 1 then
    --    isJailed = false
    --end
end)

hook.Add("HUDPaint", "GlitchHUDAdverts", function()
    if LocalPlayer():Health() < 1 then return end

	local sw,sh = ScrW(), ScrH()
    --Ad shit
	surface.SetFont("GlitchHUDAd")
    local aw, ah = surface.GetTextSize(adText)

    surface.SetDrawColor(glitchhhud_config.backgroundCol)
    surface.DrawRect((sw*.5) - (aw/2)-20, sh - adY -10, aw+40, ah+20)

    draw.DrawText(adText, "GlitchHUDAd", sw*.5, sh - adY, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM)

    if (showAd) then
		adY = Lerp(FrameTime() * 4, adY, 64)
	else
		adY = Lerp(FrameTime() * 4, adY, -30)
	end

    local ply = LocalPlayer()

    --Jailed shit
    if (isJailed) then
        if (isNLR) then
            if showAd then
                jailY = Lerp(FrameTime() * 4, jailY, 164)
            else
                jailY = Lerp(FrameTime() * 4, jailY, 114)
            end
        else
            if showAd then
                jailY = Lerp(FrameTime() * 4, jailY, 114)
            else
                jailY = Lerp(FrameTime() * 4, jailY, 64)
            end
        end
    else
        jailY = Lerp(FrameTime() * 4, jailY, -30)
    end

    surface.SetFont("GlitchHUDJailed")
    local jw, jh = surface.GetTextSize("You are jailed for " .. jailTimeLeft .." seconds!")

    surface.SetDrawColor(glitchhhud_config.backgroundCol)
    surface.DrawRect((sw*.5) - (jw/2)-20, sh - jailY -10, jw+40, jh+20)

    draw.DrawText("You are jailed for " .. jailTimeLeft .." seconds!", "GlitchHUDJailed", sw*.5, sh - jailY, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM)

    --NLR Shit
    if (!ply.endNLR) then return end

    surface.SetFont("GlitchHUDNLR")
    local aw, ah = surface.GetTextSize("NLR: Don't return to where you died for " .. ply.endNLR .. " seconds.")

    surface.SetDrawColor(glitchhhud_config.backgroundCol)
    surface.DrawRect((sw*.5) - (aw/2)-20, sh - nlrY -10, aw+40, ah+20)

    draw.DrawText("NLR: Don't return to where you died for " .. ply.endNLR .. " seconds.", "GlitchHUDAd", sw*.5, sh - nlrY, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM)

    if (ply.endNLR >= 1) then
    	if (showAd) then
	        nlrY = Lerp(FrameTime() * 4, nlrY, 114)
	    else
	        nlrY = Lerp(FrameTime() * 4, nlrY, 64)
    	end
        isNLR = true
    else
        nlrY = Lerp(FrameTime() * 4, nlrY, -30)
        isNLR = false
    end
end)

local shouldShow = CreateClientConVar("gf_showads", "0", true, false, "Should adverts appear at the bottom of the screen?", 0, 1)

function showAdvert(ad)
    if (table.HasValue({"bronze", "silver", "gold", "diamond"}, LocalPlayer():GetSecondaryUserGroup()) and !LocalPlayer():IsSuperAdmin()) and !shouldShow:GetBool() then return end

    adText = ad
    showAd = true

    if (timer.Exists("GlitchHUDAdvert")) then
        timer.Remove("GlitchHUDAdvert")
    end

    timer.Create("GlitchHUDAdvert", 10, 0, function()
        showAd = false
    end)
end

net.Receive("GlitchHUDAdvert", function()
	showAdvert(net.ReadString())
end)

usermessage.Hook("GotArrested", function(msg)
    jailStart = CurTime()
    jailUntil = msg:ReadFloat()
end)