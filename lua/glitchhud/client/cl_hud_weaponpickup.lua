
surface.CreateFont("GFItemPickup", {
    font = "Roboto",
    size = 18,
    weight = 500
})

local screenHeight = ScrH()
local screenWidth = ScrW()

local itemPickupWidth = math.floor(screenWidth * 0.1)
local itemPickupHeight = math.floor(screenHeight * 0.35)

--Create a table for all items.
local items = {}

--Create a function to add new items to the list.
local function addNewItem( text )

	local item = {}
	item.text = text
	item.curTime = CurTime() + 5

	table.insert(items, item)

end

hook.Add("InitPostEntity", "gfWeaponPickupCreator", function()
	local itemPickupFrame = vgui.Create("DPanel")
	itemPickupFrame:SetSize(itemPickupWidth, itemPickupHeight)
	itemPickupFrame:SetPos(screenWidth - 30 - itemPickupFrame:GetWide(), screenHeight * 0.35)

	local itemHeight = math.floor(itemPickupHeight * 0.08)
	local itemMargin = math.floor(itemPickupHeight * 0.03)

	itemPickupFrame.Paint = function()
		for k,v in pairs(items) do
			--Update v.destination
			v.destination = (itemHeight + itemMargin) * k

			--Create data.
			if !v.lerpedYPos then
				v.lerpedYPos = v.destination
				v.lerpedXPos = itemPickupWidth
				v.alpha = 1
			end

			--Fade away the box.
			if v.curTime < CurTime() then
				v.alpha = Lerp(FrameTime() * 6.5, v.alpha, 0)
			end

			--Remove the box.
			if v.alpha < 0.05 then
				items[k] = nil
				items = table.ClearKeys(items)
				continue
			end

			--Lerp data.
			v.lerpedYPos = Lerp(FrameTime() * 8, v.lerpedYPos, v.destination)
			v.lerpedXPos = Lerp(FrameTime() * 12, v.lerpedXPos, 0)

			--Draw the background.
			surface.SetDrawColor(ColorAlpha(glitchhhud_config.backgroundCol, v.alpha * glitchhhud_config.backgroundCol.a))
			surface.DrawRect(math.Round(v.lerpedXPos),math.Round(v.lerpedYPos),itemPickupWidth,itemHeight)

			draw.SimpleText( v.text, "GFItemPickup", math.Round(v.lerpedXPos) + itemPickupWidth / 2, math.Round(v.lerpedYPos) + itemHeight / 2, ColorAlpha(color_white, v.alpha * color_white.a), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		end
	end
end)

--Hook into HUDItemPickedUp.
hook.Add("HUDItemPickedUp","GFItemPickedUp", function( itemName )

	local ply = LocalPlayer()

	if !IsValid(ply) or !ply:Alive() then return end

	addNewItem(language.GetPhrase("#" .. itemName))

end)

--Hook into HUDWeaponPickedUp
hook.Add("HUDWeaponPickedUp","GFWeaponPickedUp", function( wep )

	local ply = LocalPlayer()

	if !IsValid(ply) or !ply:Alive() then return end
	if !IsValid(wep) then return end
	if !isfunction(wep.GetPrintName) then return end

	addNewItem(wep:GetPrintName())

end)

--Hook into HUDAmmoPickedUp
hook.Add("HUDAmmoPickedUp","GFWeaponPickedUp", function( itemname, amount )

	local ply = LocalPlayer()

	if !IsValid(ply) or !ply:Alive() then return end

	addNewItem(language.GetPhrase( "#" .. itemname .. "_Ammo" ) .. " +" .. amount)

end)

timer.Create("RemoveDrawPickupHistory",1,0,function(  )
	GAMEMODE.HUDDrawPickupHistory = function(  )  end
end)