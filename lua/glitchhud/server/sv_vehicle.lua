
hook.Add("PlayerEnteredVehicle","GFHUDPlayerEnteredVehicle",function(ply, veh)
	if !IsValid(ply) or !IsValid(veh) then return end

	net.Start("GFHUDDriverUpdate")
		if veh:GetClass() == "prop_vehicle_jeep" then
			net.WriteBool(true)
		else
			net.WriteBool(false)
		end
	net.Send(ply)
end)

hook.Add("PlayerLeaveVehicle","GFHUDPlayerLeaveVehicle",function(ply)
	if !IsValid(ply) then return end

	net.Start("GFHUDDriverUpdate")
		net.WriteBool(false)
	net.Send(ply)
end)

util.AddNetworkString("GFHUDDriverUpdate")