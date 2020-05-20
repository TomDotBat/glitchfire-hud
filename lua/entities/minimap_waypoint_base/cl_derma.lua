///////////
// Vars 
///////////

minimapderma = {
	blur = Material( "pp/blurscreen" ),
	
	defaultFont = "Default",
	
	cornerRadius = 6,
	backGroundColor = Color(20, 20, 20, 200),
	panelColor = Color(30, 30, 30, 200),
	buttonTextColor = Color(255, 255, 255, 255),
	buttonColor = Color(100, 100, 100, 255),
	buttonColorHovered = Color(120, 120, 120, 255),
	buttonSuccessSound = "buttons/button3.wav",
	transitionDuration = 0.5,
};

/////////////
// Accessor methods 
/////////////

function minimapderma:SetCornerRadius(radius)
	self.cornerRadius = radius;
end

function minimapderma:SetBackgroundColor(color)
	self.backGroundColor = color;
end 

function minimapderma:SetButtonTextColor(color)
	self.buttonTextColor = color;
end 

function minimapderma:SetButtonColor(color)
	self.buttonColor = color;
end 

function minimapderma:SetColorHovered(color)
	self.buttonColorHovered = color;
end 

function minimapderma:SetSuccessSound(path)
	self.buttonSuccessSound = path;
end 

function minimapderma:SetTransitionDuration(duration)
	self.transitionDuration = duration;
end

function minimapderma:SetDefaultFont(font)
	self.defaultFont = font;
end

function minimapderma:SetPanelColor(color)
	self.panelColor = color;
end

////////////
// Methods 
////////////

/*
	GenerateFont 
	Parameters: string
	Returns: void 
	Description: Calls surface.createfont method
*/
function minimapderma:GenerateFont(name, font, size, weight)

	weight = weight || 500;

	surface.CreateFont(name, {
		font = font,
		extended = false,
		size = size,
		weight = weight,
		blursize = 0,
		scanlines = 0,
		antialias = true,
		underline = false,
		italic = false,
		strikeout = false,
		symbol = false,
		rotary = false,
		shadow = false,
		additive = false,
		outline = false,
	});
	
	if (self.defaultFont == "Default") then 
		self.defaultFont = name;
	end 
end

/*
	Blur 
	Parameters: panel, integer, integer, integer 
	Returns: void 
	Description: Draws a nice blur effect 
*/

function minimapderma:Blur(panel, layers, density, alpha)
	local x, y = panel:LocalToScreen(0, 0);

	surface.SetDrawColor(255, 255, 255, alpha);
	surface.SetMaterial(self.blur);

	for i = 1, 3 do
		self.blur:SetFloat("$blur", ( i / layers ) * density);
		self.blur:Recompute();
		render.UpdateScreenEffectTexture();
		surface.DrawTexturedRect(-x, -y, ScrW(), ScrH());
	end
end

/*
	Slide 
	Parameters: panel, integer, integer
	Returns: void 
	Description: Slides a panel to an absolute position over time (seconds)
*/
function minimapderma:Slide(p, x, y)

	// Calculate differences 
	local pX, pY = p:GetPos();
	local diffX = x - pX;
	local diffY = y - pY;
	
	local startTime = CurTime();
	
	// Hook the think method to run our animation
	local oldThink = p.Think || function(_p) end;
	
	p.Think = function(_p)
		oldThink(p);
		
		local timeElapsed = CurTime() - startTime;
		local progress = (timeElapsed/self.transitionDuration);
		
		p:SetPos(pX + (diffX*progress), pY + (diffY*progress));
		
		if (progress >= 1) then // Unhook the think method
			p.Think = oldThink;
			p:SetPos(x, y);
		end
	end 
end 

/*
	Frame 
	Parameters: integer, integer, integer (optional), integer (optional), string (optional)
	Returns: panel
	Description: Generates a custom derma frame 
*/
function minimapderma:Frame(x, y, width, height, title, closeButton)

	x = x || ScrW()/2-width/2;
	y = y || ScrH()/2-height/2;
	title = title || "";
	if (closeButton == nil) then 
		closeButton = true;
	end

	local frame = vgui.Create("DFrame");
	frame:SetSize(width, height);
	frame:SetPos(x, y);
	frame:ShowCloseButton(false);
	frame:SetDraggable(false);
	frame:SetTitle(title);
	frame._x = x;
	frame._y = y;
	frame.Paint = function(p)
		self:Blur(frame, 1, 2, 255);
		draw.RoundedBox(self.cornerRadius, 0, 0, p:GetWide(), p:GetTall(), self.backGroundColor);
	end
	
	if (closeButton) then 
		frame.close = vgui.Create("DImageButton");
		frame.close:SetParent(frame);
		frame.close:SetIcon("icon16/cancel.png");
		frame.close:SetPos(frame:GetWide() - 21, 5);
		frame.close:SetSize(16, 16);
		frame.close.DoClick = function(p)
			
			surface.PlaySound(self.buttonSuccessSound);
			frame.Dismiss();
		end
	end
	
	frame.Request = function()
		frame:SetPos(x, -frame:GetTall());
		self:Slide(frame, x, y);
	end
	
	frame.Dismiss = function(x2, y2)
		x2 = x2 || x;
		y2 = y2 || ScrH();
		
		self:Slide(frame, x2, y2);
		timer.Simple(self.transitionDuration, function()
			if (IsValid(frame)) then 
				frame:Close();
			end
		end);
	end
	
	return frame;
end

/*
	Panel 
	Parameters: int, int 
	Returns: panel 
*/
function minimapderma:Panel(w, h)

	local panel = vgui.Create("DPanel");
	panel:SetSize(w, h);
	panel.Paint = function(s)
	
		draw.RoundedBox(self.cornerRadius, 0, 0, s:GetWide(), s:GetTall(), self.panelColor);
	end
	
	return panel;
end

/*
	List 
	Parameters: panel (optional), boolean (optional)
	Returns: panel 
*/
function minimapderma:List(parent, bHorizontal)

	bHorizontal = bHorizontal || false;
	
	local dList = vgui.Create("DPanelList");
	dList:SetSpacing(2);
	dList:EnableVerticalScrollbar(true);
	dList:EnableHorizontal(bHorizontal);
	
	if (parent) then 
		dList:SetParent(parent);
		dList:SetPos(5, 25);
		dList:SetSize(parent:GetWide() - 10, parent:GetTall() - 30);
	end 
	
	return dList;
end

/*
	CollapsibleCategoryList
	Parameters: int, int
	Returns: panel 
*/
function minimapderma:CollapsibleCategoryList(w, h)

	local cat = vgui.Create("DCollapsibleCategory");
	cat:SetWide(w);
	cat.Paint = function() end
	cat.Header:SetFont(self.defaultFont);
	cat.Header.Paint = function(s)
		draw.RoundedBox(8, 0, 0, s:GetWide(), s:GetTall(), Color(0, 0, 0, 200));
		//surface.SetDrawColor(Color(200, 200, 200, 200));
		//surface.DrawOutlinedRect(0, 0, s:GetWide(), s:GetTall());
	end
	
	local internalList = self:List(nil, false);
	
	cat.internalList = internalList;
	cat:SetContents(internalList);
	
	cat.AddItem = function(s, p)
		internalList:AddItem(p);
	end
	
	return cat;
end

/*
	Button
	Parameters: string, function 
	Returns: panel
*/
function minimapderma:Button(text, func)

	local button = vgui.Create("DButton");
	button:SetText(text);
	button:SetTextColor(self.buttonTextColor);
	button.DoClick = function() 
		surface.PlaySound(self.buttonSuccessSound);
		func();
	end
	button.Paint = function(p)
		
		local color;
		if (button:IsHovered()) then 
			color = self.buttonColorHovered;
		else
			color = self.buttonColor;
		end 
		
		local highLightColor = Color(color.r + 8, 
									color.g + 8,
									color.b + 8,
									color.a);
									
		local highLightCornerRadius = self.cornerRadius - 2;
		if (highLightCornerRadius < 0) then 
			highLightCornerRadius = 0;
		end
									
		draw.RoundedBox(self.cornerRadius, 0, 0, p:GetWide(), p:GetTall(), color);
		draw.RoundedBox(highLightCornerRadius, 0, 0, p:GetWide(), p:GetTall()/2, highLightColor);
	end 

	return button;
end

/*
	Label 
	Parameters: string, string 
	Return: panel 
*/
function minimapderma:Label(text, font, color)

	color = color || Color(255,255,255,255);

	local lab = vgui.Create("DLabel");
	lab:SetFont(font);
	lab:SetText(text);
	lab:SetTextColor(color);
	lab:SizeToContents();
	
	return lab;
end

/*
	SpawnIcon
	Parameters: string 
	Return: panel, int
*/
function minimapderma:SpawnIcon(model, size)

	local spawnIcon = vgui.Create("SpawnIcon");
	spawnIcon:SetModel(model);
	spawnIcon:SetSize(size, size);
	
	/* Unneccesary?
	if (self.BuiltSpawnIcons[model] == nil) then
		spawnIcon:RebuildSpawnIcon();
		self.BuiltSpawnIcons[model] = true;
	end
	*/
	
	return spawnIcon;
end

return minimapderma;