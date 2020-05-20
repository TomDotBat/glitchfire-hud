
surface.CreateFont("GlitchHUDWaypointConfig", {
    font = "Roboto",
    size = 24,
    weight = 500
})

include("shared.lua");

minimapderma:SetTransitionDuration(0.3);

// Client -> Server Net

local function PerformEdit(ent, material, color, shouldRender)

	local data = {
		ent = ent,
		material = material,
		color = color,
		shouldRender = shouldRender,
	};
	
	net.Start("edit_waypoint");
		net.WriteTable(data);
	net.SendToServer();
end 

// Derma 
local function Menu(ent)

	if (!IsValid(ent)) then return end 
	
	local frame = minimapderma:Frame(nil, nil, 500, 430, "Waypoint Editor", true);
	frame.Request();
	frame:MakePopup();
	
	local iList = minimapderma:List(frame, false);
	
	iList:AddItem(minimapderma:Label("Material", "GlitchHUDWaypointConfig"));
	
	local materialCombo = vgui.Create("DComboBox");
	materialCombo.selection = ent:GetWaypointMaterial();
	materialCombo.OnSelect = function(s, index, value)
		s.selection = value;
	end 
	for k,v in next, glitchhhud_config.icons do
		materialCombo:AddChoice(k);
	end 
	iList:AddItem(materialCombo);
	
	materialCombo:SetText(ent:GetWaypointMaterial());
	
	iList:AddItem(minimapderma:Label("Color", "GlitchHUDWaypointConfig"));
	
	local colorPalette = vgui.Create("DColorMixer");
	colorPalette:SetPalette(true);
	colorPalette:SetWangs(true);
	colorPalette:SetAlphaBar(false);
	colorPalette.selection = ent:GetWaypointColor();
	colorPalette.ValueChanged = function(s, col)
		s.selection = Vector(col.r, col.g, col.b);
	end
	colorPalette:SetColor(Color(colorPalette.selection.r, colorPalette.selection.g, colorPalette.selection.b, 255));
	iList:AddItem(colorPalette);
	
	iList:AddItem(minimapderma:Label("Rendering", "GlitchHUDWaypointConfig"));
	
	local renderCheck = vgui.Create("DCheckBoxLabel");
	renderCheck:SetChecked(ent:GetShouldRender());
	renderCheck:SetText("Render");
	iList:AddItem(renderCheck);
	
	iList:AddItem(minimapderma:Label("Finish", "GlitchHUDWaypointConfig"));
	
	iList:AddItem(minimapderma:Button("Submit", function()
		
		PerformEdit(ent, materialCombo.selection, colorPalette.selection, renderCheck:GetChecked());
		frame.Dismiss();
	end));
end

// Server -> Client Net 
local function ReceiveOpenMenu(len)
	Menu(net.ReadEntity());
end 
net.Receive("edit_waypoint_menu", ReceiveOpenMenu);