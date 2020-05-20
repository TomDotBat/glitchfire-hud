// Custom notification types
NOTIFY_MONEY = 10

local iconMats = {}

iconMats[NOTIFY_CLEANUP] = Material("glitchfire/hud/cleanup.png", "smooth")
iconMats[NOTIFY_ERROR] = Material("glitchfire/hud/error.png", "smooth")
iconMats[NOTIFY_GENERIC] = Material("glitchfire/hud/generic.png", "smooth")
iconMats[NOTIFY_HINT] = Material("glitchfire/hud/hint.png", "smooth")
iconMats[NOTIFY_UNDO] = Material("glitchfire/hud/undo.png", "smooth")
iconMats[NOTIFY_MONEY] = Material("glitchfire/hud/money.png", "smooth")

local iconSize = 26

surface.CreateFont("GlitchHUDNotify", {
    font = "Roboto",
    size = 22,
    weight = 500,
})

local notifications = {}

local function DrawNotification( x, y, w, h, text, type, TimeCalled, Duration, ct )
    surface.SetDrawColor(glitchhhud_config.backgroundCol)
    surface.DrawRect(x-10, y, w+10, h+h*.1)


    if iconMats[type] then
    	surface.SetDrawColor( 255, 255, 255, 255 )
		surface.SetMaterial( iconMats[type]	)
		surface.DrawTexturedRect( x+10, (y+2+(h/2))-(iconSize/2), iconSize, iconSize )
    end
    
    surface.SetFont("GlitchHUDNotify")
    local tw, th = surface.GetTextSize(text)
    surface.SetTextColor(color_white)
    surface.SetTextPos(x+20+iconSize, y+h/2-(th/2)+1)
    surface.DrawText(text)
end

function notification.AddLegacy( text, type, time )
    surface.SetFont( "GlitchHUDNotify" )

    local w, h = surface.GetTextSize( text ) + 40 + iconSize, 39
    local x, y = ScrW() - 30, ScrH() - 140
    local ct = CurTime()
    table.insert( notifications, 1, {
        w = w,
        h = h,
        x = x,
        y = y,

        text = text,
        time = ct + time,
        TimeCalled = ct,
        Duration = time,
        type = type
    } )
end

function notification.AddProgress( id, strText ) end

function notification.Kill( id )
	for k, v in ipairs( notifications ) do
		if v.id == id then v.time = 0 end
	end
end

hook.Add("HUDPaint", "GlitchHUDNotifications", function()
    local ct = CurTime()
    local ft = FrameTime()*10
    for k, v in ipairs( notifications ) do
        DrawNotification( math.floor( v.x ), math.floor( v.y ), v.w, v.h, v.text, v.type, v.TimeCalled, v.Duration, ct )
        
        v.x = Lerp(ft, v.x, v.time > CurTime() and ScrW() - v.w - 30 or ScrW() + 1 )
        v.y = Lerp(ft, v.y, ScrH() - 90 - k * ( v.h + 10 ) )
    end

    for k, v in ipairs( notifications ) do
        if v.x >= ScrW() and v.time < ct then
            table.remove( notifications, k )
        end
    end
end)