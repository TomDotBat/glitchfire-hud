ENT.Type = "anim";
ENT.Base = "base_gmodentity";
 
ENT.PrintName		= "Waypoint";
ENT.Author			= "Tom.bat";
ENT.Contact			= "tom@tomdotbat.dev";
ENT.Purpose			= "Displays an icon on the minimap.";
ENT.Instructions	= "Place in a location of your choice.";

function ENT:SetupDataTables()
	
	self:NetworkVar("String", 0, "WaypointMaterial");
	self:NetworkVar("Vector", 1, "WaypointColor");
	self:NetworkVar("Bool", 2, "ShouldRender");
end