local wx, wy = -132, 0
local lx, ly = -152, 0
local ay = 0

local isWanted = false
local isLockdown = false

local showAlert = false
local title = ""
local subtitle = ""
local titlecolor = color_white

surface.CreateFont("GlitchHUDWantedAlert", {
    font = "Roboto",
    size = 48,
    weight = 500,
})

surface.CreateFont("GlitchHUDWantedAlertSub", {
    font = "Roboto",
    size = 32,
    weight = 500,
})

surface.CreateFont("GlitchHUDArrested", {
	font = "Roboto",
	size = 24,
	weight = 500,
})


hook.Add("Tick", "GlitchHUDDarkRPInfo", function()
	local ply = LocalPlayer()

	if (!IsValid(ply)) then return end
	
	isWanted = ply:getDarkRPVar("wanted")
	isLockdown = GetGlobalBool("DarkRP_LockDown")
end)

hook.Add("HUDPaint", "GlitchHUDDarkRPInfo", function()
	local ply = LocalPlayer()
    if ply:Health() < 1 then return end

	if (isWanted) then
		wx = Lerp(FrameTime() * 4, wx, 0)
		ly = Lerp(FrameTime() * 4, ly, 50)
	else
		wx = Lerp(FrameTime() * 4, wx, -132)
		ly = Lerp(FrameTime() * 4, ly, 0)
	end

	if (isLockdown) then
		lx = Lerp(FrameTime() * 4, lx, 0)
	else
		lx = Lerp(FrameTime() * 4, lx, -154)
	end

	local sw = ScrW()

	surface.SetFont("GlitchHUDPlayerInfo")

	//Draw wanted text and box
	local ww = surface.GetTextSize("Wanted")

	local woff = sw - (ww + 50 + wx)

    surface.SetDrawColor(glitchhhud_config.wantedCol)
    surface.DrawRect(woff - 20, 30, ww + 40, 40)

    draw.SimpleText("Wanted", "GlitchHUDPlayerInfo", woff + ww / 2, 50 + wy, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

	//Draw lockdown text and box
    local lw = surface.GetTextSize("Lockdown")

	woff = sw - (lw + 50 + lx)

    surface.SetDrawColor(glitchhhud_config.lockdownCol)
    surface.DrawRect(woff - 20, 30 + ly, lw + 40, 40)

    draw.SimpleText("Lockdown", "GlitchHUDPlayerInfo", woff + lw / 2, 50 + ly, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

    //Draw wanted alert
	surface.SetFont("GlitchHUDWantedAlert")
    local waw, wah = surface.GetTextSize(title)

	surface.SetFont("GlitchHUDWantedAlertSub")
    local ww,wh = surface.GetTextSize(subtitle)

    local bw,bh = math.max(ww, waw) + 120, wah+wh+40

    woff = sw*.5

    surface.SetDrawColor(glitchhhud_config.backgroundCol)
    surface.DrawRect(woff - (bw/2), 30 + ay, bw, bh)

    draw.SimpleText(title, "GlitchHUDWantedAlert", woff, 40 + ay, titlecolor, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)

    draw.DrawText(subtitle, "GlitchHUDWantedAlertSub", woff, bh + 20 + ay - wh, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM)

    if (showAlert) then
		ay = Lerp(FrameTime() * 4, ay, 0)
	else
		ay = Lerp(FrameTime() * 4, ay, -(155 + bh))
	end
end)

net.Receive("GlitchHUDNotify", function(len)
	title = net.ReadString()
	subtitle = net.ReadString()
	titlecolor = net.ReadColor()

	showAlert = true

	if (timer.Exists("GlitchHUDNotify")) then
		timer.Remove("GlitchHUDNotify")
	end

	timer.Create("GlitchHUDNotify", 5, 0, function()
		showAlert = false
	end)
end)