AddCSLuaFile("cl_derma.lua");
AddCSLuaFile("cl_init.lua");
AddCSLuaFile("shared.lua");
 
include('shared.lua')

// Entity 
function ENT:Initialize()
	
	self:SetShouldRender(true);
	self:SetWaypointMaterial("Pin");
	self:SetWaypointColor(Vector(255, 255, 255));
	self:SetModel("models/hunter/blocks/cube025x025x025.mdl");
	self:PhysicsInit(SOLID_VPHYSICS);      
	self:SetMoveType(MOVETYPE_NONE);  
	self:SetSolid(SOLID_VPHYSICS);
	self:SetCollisionGroup(COLLISION_GROUP_WORLD);
	self:SetUseType(SIMPLE_USE);
	self:AddEFlags(EFL_FORCE_CHECK_TRANSMIT);
 
    local phys = self:GetPhysicsObject()
	if (phys:IsValid()) then
		phys:Wake();
	end
	
	self:PostInit();
end

function ENT:PostInit()

end

function ENT:UpdateTransmitState()
	return TRANSMIT_ALWAYS;
end