include('shared.lua')
include('cl_derma.lua')
// Entity
function ENT:Initialize()

end

function ENT:Draw()
	
	self:DestroyShadow();
	
	if (!self:GetShouldRender()) then return end
	
	local pos = self:GetPos();
	
	if (pos:Distance(LocalPlayer():GetPos()) > 2000) then return end

	local ang = LocalPlayer():EyeAngles();
	ang.p = ang.p + 180;
	ang.r = 180;
	
	ang:RotateAroundAxis(ang:Right(), -90);
	ang:RotateAroundAxis(ang:Up(), 90);
	
	cam.Start3D2D(pos, ang, 0.4);
		
		surface.SetDrawColor(Color(0, 0, 0, 200));
		surface.DrawRect(-5, -5, 42, 42);
		
		local color = self:GetWaypointColor();
		surface.SetDrawColor(Color(color.x, color.y, color.z, 255));
		surface.SetMaterial(glitchhhud_config.icons[self:GetWaypointMaterial()]);
		surface.DrawTexturedRect(0, 0, 32, 32);
	cam.End3D2D();
end