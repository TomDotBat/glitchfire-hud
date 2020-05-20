AddCSLuaFile("cl_init.lua");
AddCSLuaFile("shared.lua");
 
include('shared.lua')

// Pooled strings 
util.AddNetworkString("edit_waypoint");
util.AddNetworkString("edit_waypoint_menu");

// Utility 
local function IsStaff(ply)
	if (ply.GetUserGroup != nil) then 
		--if (glitchhhud_config.staffUsergroups[ply:GetUserGroup()] == nil) then return false end 
		--if (!ply:IsUserGroup("owner")) then return false end 
		if (!ply:IsSuperAdmin()) then return false end 
	else 
		if (!ply:IsAdmin()) then return false end 
	end 
	return true;
end
// Entity 
function ENT:PostInit()
	
	self:SetUseType(SIMPLE_USE);
	self:SetWaypointMaterial("Pin");
	self:SetWaypointColor(Vector(255,255,255));
end 

function ENT:Use(ply)

	if (!IsStaff(ply)) then return end 
	
	net.Start("edit_waypoint_menu");
		net.WriteEntity(self);
	net.Send(ply);
end

// Networking 
local function ReceiveEditWaypoint(len, ply)
	
	// Check for permissions 
	if (!IsStaff(ply)) then return end
	
	// Read the uploaded data 
	local data = net.ReadTable();
	if (!IsValid(data.ent)) then return end 
	if (data.material == nil) then return end 
	if (data.color == nil) then return end 
	if (data.shouldRender == nil) then return end
	
	data.ent:SetWaypointMaterial(data.material);
	data.ent:SetWaypointColor(data.color);
	data.ent:SetShouldRender(data.shouldRender);
end 
net.Receive("edit_waypoint", ReceiveEditWaypoint);