
function ulx.advert( calling_ply, message )
	net.Start("GlitchHUDAdvert")
		net.WriteString(message)
	net.Broadcast()
	--ulx.fancyLogAdmin( calling_ply, "#A showed an advert.")
end
local advert = ulx.command("Chat", "ulx advert", ulx.advert, "!advert")

advert:defaultAccess(ULib.ACCESS_SUPERADMIN)
advert:addParam{ type=ULib.cmds.StringArg, hint="Message" }
advert:help("Makes a customised advert display.")

