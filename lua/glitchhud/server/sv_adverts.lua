local advertIncrement = 1
local advertMessages = {
	"Want to donate? Use !donate to view our store.",
	"Vote for our server and earn rewards by using !servervote.",
	"Complete !battlepass challenges and earn rewards!",
	"Have a cool idea for the server? You can make suggestions in our Discord.",
	"Make yourself look cool with cosmetics from !tokenstore.",
	"You can apply for staff by typing !apply in chat.",
	"You can visit our website by using !website.",
	"Join our Discord and speak to other players by using !discord.",
	"Join our Steam Group for server alerts and more, !steamgroup.",
	"Try your luck by unboxing crates with !unbox."
}

timer.Create("GlitchHUDAdvert", 300, 0, function()
	advertIncrement = advertIncrement + 1
	if advertIncrement > #advertMessages then
		advertIncrement = 1
	end

	net.Start("GlitchHUDAdvert")
		net.WriteString(advertMessages[advertIncrement])
	net.Broadcast()
end)

util.AddNetworkString("GlitchHUDAdvert")

--Add a hook for when a player enters a vehicle.
hook.Add("PlayerEnteredVehicle","GFHUDPlayerEnteredVehicle",function( ply, veh)

	--MAke sure the vehicle and player are valid.
	if !IsValid(ply) or !IsValid(veh) then return end

	local isDriver = false

	if veh:GetClass() == "prop_vehicle_jeep" then
		isDriver = true
	end

	--Update the player.
	net.Start("GFHUDDriverInfo")
		net.WriteBool(isDriver)
	net.Send(ply)

end)

--Add a hook for when a player exits a vehicle.
hook.Add("PlayerLeaveVehicle","GFHUDPlayerLeaveVehicle",function( ply )

	--Make sure the ply is valid.
	if !IsValid(ply) then return end

	--Update the player.
	net.Start("GFHUDDriverInfo")
		net.WriteBool(false)
	net.Send(ply)

end)

util.AddNetworkString("GFHUDDriverInfo")