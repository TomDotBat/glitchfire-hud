--------------------
//     Fonts
--------------------

surface.CreateFont("OH_Name_Font", {
	font = "Roboto Black",
	size = 35,
	weight = 500,
})

surface.CreateFont("OH_Name_Font_Typing", {
	font = "Roboto Black Italic",
	size = 35,
	weight = 500,
})

surface.CreateFont("OH_Chat_Font", {
	font = "Roboto Black",
	size = 40,
	weight = 500,
})

surface.CreateFont("OH_License_Font", {
	font = "Roboto",
	size = 25,
	weight = 500,
})

surface.CreateFont("OH_Wanted_Font", {
	font = "Roboto",
	size = 22,
	weight = 800,
})

--------------------
//   Outside Vars
--------------------

	--{ Smoothers }--

		local HealthSmoother = 0
		local ArmorSmoother = 0
		local MoneySmoother = 0

	--{ Wanted }--

		local IsOn = false
		timer.Create("WantedTextTimer", 1, 0, function()
			IsOn = !IsOn
		end)

	--{ Chat }--

		local isTyping = false

--------------------
//    HUD Paint
--------------------

hook.Add("HUDPaint", "GlitchHUDOverheads", function()

    --{ Inside Vars }--

		-- Player Vars
        local ply = LocalPlayer()

		-- HUD Vars
		local nameonly = false
	    local trace = ply:GetEyeTraceNoCursor()
	    if ( !trace.Hit ) then
			return
		end
        if ( !trace.HitNonWorld ) then
			return
		end
        if trace.Entity:IsPlayer() and ply:GetPos():Distance(trace.Entity:GetPos()) > 250 then
            nameonly=true
            if ply:GetPos():Distance(trace.Entity:GetPos()) > 600 then
            	return
            end
        end
		if ( !trace.Entity:IsPlayer() ) then
		    return
	    end

    --{ Overhead }--

		-- Name
	    local text = "ERROR"
	    local font = "OH_Name_Font"

	    if ( trace.Entity:IsPlayer() ) then
		    text = string.Replace(trace.Entity:Nick(), "#", "# ")
	    else
		    return
        end

	    surface.SetFont( font )
	    local w, h = surface.GetTextSize( text )
        local pEyePos = trace.Entity:EyePos()
        pEyePos.z = pEyePos.z+12
        cam.Start3D()
        pEyePos = pEyePos:ToScreen()
        cam.End3D()
	    local x = pEyePos.x
        local y = pEyePos.y
        local voiceease = 0
        local namecol = Color(255, 255, 255, 255)
        local namefont = "OH_Name_Font"
        local voicevol = math.Truncate(trace.Entity:VoiceVolume(), 4)
		draw.SimpleText( text, "OH_Name_Font", x+1, y-34, color_black, TEXT_ALIGN_CENTER )

		-- Typing
		if trace.Entity:IsTyping() then
			namefont = "OH_Name_Font_Typing"
			local dotoffset1 = math.abs(math.sin(CurTime() * 3)) * 7
			local dotoffset2 = math.abs(math.sin((CurTime()+3) * 3)) * 7
			local dotoffset3 = math.abs(math.sin((CurTime()+6) * 3)) * 7
			draw.SimpleText( ".", "OH_Chat_Font", x-10, y-67-dotoffset1, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER )
			draw.SimpleText( ".", "OH_Chat_Font", x+1, y-67-dotoffset2, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER )
			draw.SimpleText( ".", "OH_Chat_Font", x+12, y-67-dotoffset3, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER )
		end

		-- Name Draw
		draw.SimpleText( text, "OH_Name_Font", x, y-35, namecol, TEXT_ALIGN_CENTER )
		if nameonly == true then
			surface.SetDrawColor(55, 255, 55, 255)
        	draw.NoTexture()
        	surface.DrawTexturedRectRotated(x, y-4, voicevol*w, 2, 0)
		else
			surface.SetDrawColor(glitchhhud_config.salaryCol)
        	draw.NoTexture()

			-- License
			if trace.Entity:getDarkRPVar("HasGunlicense") then
				local tw, th = surface.GetTextSize("Licensed")
				draw.SimpleText( "Licensed", "OH_License_Font", x-40, y+0, Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT )
				surface.DrawTexturedRectRotated(x, y+33, math.floor(voicevol*160), 10, 0)
			else
				surface.DrawTexturedRectRotated(x, y+5, math.floor(voicevol*160), 10, 0)
			end

			if trace.Entity:getDarkRPVar("wanted") then
				if trace.Entity:IsTyping() then
					surface.SetFont("OH_Wanted_Font")
					local tw, th = surface.GetTextSize("WANTED")
				    surface.SetDrawColor(glitchhhud_config.wantedCol)
				    surface.DrawRect(x-39, y-93, tw+10, th+10)

					draw.SimpleText( "WANTED", "OH_Wanted_Font", x-1, y-89, color_white, TEXT_ALIGN_CENTER )

				else
					surface.SetFont("OH_Wanted_Font")
					local tw, th = surface.GetTextSize("WANTED")
				    surface.SetDrawColor(glitchhhud_config.wantedCol)
				    surface.DrawRect(x-43, y-73, tw+10, th+10)

					draw.SimpleText( "WANTED", "OH_Wanted_Font", x-1, y-69, color_white, TEXT_ALIGN_CENTER )
				end
			end
		end
end)

--------------------
//    Disabling
--------------------

hook.Add("HUDShouldDraw", "DarkRP_HideJobsEntityDisplay", function(hudName)
    if hudName ~= "DarkRP_EntityDisplay" then
		return
	end
    local playersToDraw = {}
    for _,ply in pairs(player.GetAll()) do
        if !LocalPlayer():Alive() then
			table.insert(playersToDraw, ply)
		end
    end
    return true, playersToDraw
end)

hook.Add("Initialize", "GlitchHUD_DiasbleDefaultTypingIndicator",function()
	hook.Remove("StartChat", "StartChatIndicator") -- old versions of darkrp
	hook.Remove("FinishChat", "EndChatIndicator")
	hook.Remove("PostPlayerDraw", "DarkRP_ChatIndicator") -- new versions of darkrp
	hook.Remove("CreateClientsideRagdoll", "DarkRP_ChatIndicator")
end)