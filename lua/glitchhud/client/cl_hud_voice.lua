
surface.CreateFont("GFVoiceChat", {
	font = "Roboto",
	size = 22,
	weight = 500,
})

local PANEL = {}
local PlayerVoicePanels = {}
local voicePanels = {}

function PANEL:Init()
	self.LabelName = vgui.Create( "DLabel", self )
	self.LabelName:SetFont( "GFVoiceChat" )
	self.LabelName:Dock( FILL )
	self.LabelName:DockMargin( 8, 0, 0, 0 )
	self.LabelName:SetTextColor( color_white )

	self.Avatar = vgui.Create( "AvatarImage", self )
	self.Avatar:Dock( LEFT )
	self.Avatar:SetSize( 32, 32 )

	self.Color = color_transparent

	self:SetSize( 250, 32 + 8 )
	self:DockPadding( 4, 4, 4, 4 )
	self:DockMargin( 2, 2, 2, 2 )
	self:Dock( BOTTOM )
end

function PANEL:Setup( ply )
	self.ply = ply
	self.LabelName:SetText( ply:Nick() )
	self.Avatar:SetPlayer( ply )
	
	self.Color = team.GetColor( ply:Team() )
	
	self:InvalidateLayout()
end

function PANEL:Paint( w, h )
	if ( !IsValid( self.ply ) ) then return end
	draw.RoundedBox( 0, 0, 0, w, h, Color( 0, self.ply:VoiceVolume() * 255, 0, 190 ) )
end

function PANEL:Think()
	if ( IsValid( self.ply ) ) then
		self.LabelName:SetText( self.ply:Nick() )
	end

	if ( self.fadeAnim ) then
		self.fadeAnim:Run()
	end
end

function PANEL:FadeOut( anim, delta, data )
	if ( anim.Finished ) then
		if ( IsValid( PlayerVoicePanels[ self.ply ] ) ) then
			PlayerVoicePanels[ self.ply ]:Remove()
			PlayerVoicePanels[ self.ply ] = nil
			return
		end
	return end
	
	self:SetAlpha( 255 - ( 255 * delta ) )
end

derma.DefineControl( "VoiceNotify", "", PANEL, "DPanel" )

hook.Add("PlayerStartVoice", "GFHUDStartVoice", function(ply)
	if ( !IsValid( voicePanels ) ) then return end

	if ( IsValid( PlayerVoicePanels[ ply ] ) ) then
		if ( PlayerVoicePanels[ ply ].fadeAnim ) then
			PlayerVoicePanels[ ply ].fadeAnim:Stop()
			PlayerVoicePanels[ ply ].fadeAnim = nil
		end

		PlayerVoicePanels[ ply ]:SetAlpha( 255 )
		return
	end

	if ( !IsValid( ply ) ) then return end
	
	if ply == LocalPlayer() then return end
	
	local pnl = voicePanels:Add( "VoiceNotify" )
	pnl:Setup( ply )
	PlayerVoicePanels[ ply ] = pnl
end)

local function VoiceClean()
	for k, v in pairs( PlayerVoicePanels ) do
	
		if ( !IsValid( k ) ) then
			GAMEMODE:PlayerEndVoice( k )
		end
	
	end
end
timer.Create( "VoiceClean", 10, 0, VoiceClean )

hook.Add("PlayerEndVoice", "GFHUDEndVoice", function(ply)
	if ( IsValid( PlayerVoicePanels[ ply ] ) ) then
		if ( PlayerVoicePanels[ ply ].fadeAnim ) then return end
		PlayerVoicePanels[ ply ].fadeAnim = Derma_Anim( "FadeOut", PlayerVoicePanels[ ply ], PlayerVoicePanels[ ply ].FadeOut )
		PlayerVoicePanels[ ply ].fadeAnim:Start( 2 )
	end
end)

local function CreateVoiceVGUI()
	if IsValid(voicePanels) then
		voicePanels:Remove()
	end
	voicePanels = vgui.Create( "DPanel" )
	voicePanels:ParentToHUD()
	voicePanels:SetPos( ScrW() - 280, 100 )
	voicePanels:SetSize( 250, ScrH() - 400 )
	voicePanels:SetPaintBackground( false )
end

hook.Remove("InitPostEntity", "CreateVoiceVGUI")
hook.Add("InitPostEntity", "GFHUDCreateVoiceVGUI", CreateVoiceVGUI)