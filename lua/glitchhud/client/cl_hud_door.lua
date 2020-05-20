
surface.CreateFont("Door_Skin_Large", {
    font = "Roboto",
    size = 150,
    weight = 700,
    antialias = true,
})

surface.CreateFont("Door_Skin_Medium", {
    font = "Roboto",
    size = 90,
    weight = 500,
    antialias = true,
})

surface.CreateFont("Door_Skin_Small", {
    font = "Roboto",
    size = 50,
    weight = 500,
    antialias = true,
})

--[[-------------------------------------------------------------------------
Door Display
---------------------------------------------------------------------------]]

--Create a table for cached doorData.
local doorCache = {}

--Create a function to draw the door.
local function draw3D2DDoor( door )
	local ply = LocalPlayer()
	--[[-------------------------------------------------------------------------
	Door Display - DisplayData
	---------------------------------------------------------------------------]]

	--Create a table for the displayData.
	local displayData = {}

	--Get the doorangles.
	local doorAngles = door:GetAngles()

	--Check if the door data is cached.
	if doorCache[door] then

		displayData = doorCache[door]

	else

		--Get some vars.
		local OBBMaxs = door:OBBMaxs()
		local OBBMins = door:OBBMins()
		local OBBCenter = door:OBBCenter()

		--Get the size of the door.
		local size = OBBMins - OBBMaxs
		size = Vector(math.abs(size.x),math.abs(size.y),math.abs(size.z))

		--Get OBBCenter local to world.
		local obbCenterToWorld = door:LocalToWorld(OBBCenter)

		--Set the settings for the trace.
		local traceTbl = {
			endpos = obbCenterToWorld,
			filter = function( ent )
				return !(ent:IsPlayer() or ent:IsWorld())
			end
		}

		--Create a variable that holds the door angles. (Bigger scope)
		local offset
		local DrawAngles
		local CanvasPos1
		local CanvasPos2

		--Check what rotation the door has.
		if size.x > size.y then

			--Set the drawangles of the door.
			DrawAngles = Angle(0,0,90)

			--Set the start position of the trace.
			traceTbl.start = obbCenterToWorld + door:GetRight() * (size.y / 2)

			--Calculate the thickness of the door.
			local thickness = util.TraceLine(traceTbl).Fraction * (size.y / 2) + 0.85

			--Set the offset.
			offset = Vector(size.x / 2,thickness,0)

		else

			--Set the drawangles of the door.
			DrawAngles = Angle(0,90,90)

			--Set the start position of the trace.
			traceTbl.start = obbCenterToWorld + door:GetForward() * (size.x / 2)

			--Calculate the thickness of the door.
			local thickness = (1 - util.TraceLine(traceTbl).Fraction) * (size.x / 2) + 0.85

			--Set the offset.
			offset = Vector(-thickness,size.y / 2,0)

		end

		--Decide the heightOffset.
		local heightOffset = Vector(0,0,20)

		--Calculate the positions for the 3D2D.
		CanvasPos1 = OBBCenter - offset + heightOffset
		CanvasPos2 = OBBCenter + offset + heightOffset

		--Create a var for the 3D2D-Scale.
		local scale = 0.04

		local canvasWidth

		if size.x > size.y then
			canvasWidth = size.x / scale
		else
			canvasWidth = size.y / scale
		end

		--Create the displaydata.
		displayData = {
			DrawAngles = DrawAngles,
			CanvasPos1 = CanvasPos1,
			CanvasPos2 = CanvasPos2,
			scale = scale,
			canvasWidth = canvasWidth,
			start = traceTbl.start
		}

		--Cache the data.
		doorCache[door] = displayData

	end

	--[[-------------------------------------------------------------------------
	Door Display - Drawing
	---------------------------------------------------------------------------]]

	--Get the doorData.
	local doorData = door:getDoorData()

	--Create variables for the text.
	local doorHeader = ""
	local doorSubHeader = ""
	local extraText = {}

	--Check if the door is owned.
	if table.Count( doorData ) > 0 then

		--Who the owner is.
		if doorData.groupOwn then

			doorHeader = doorData.groupOwn

			--Set the header.
			--doorHeader = doorData.title or "Group Door"

			--Set the subHeader.
			--doorSubHeader = string.Replace("Access: %G", "%G", doorData.groupOwn)

		elseif doorData.nonOwnable then

			doorHeader = doorData.title or ""

		elseif doorData.teamOwn then
			
			for k,_ in pairs(doorData.teamOwn) do
				doorHeader = team.GetName(k) .. " only"
			end

			--Set the header.
			--doorHeader = doorData.title or "Team Door"

			----Set the subHeader.
			--doorSubHeader = string.Replace("Access: %J job(s)", "%J", table.Count(doorData.teamOwn))

			----Add the job titles.
			--for k,_ in pairs(doorData.teamOwn) do
			--	table.insert(extraText, team.GetName(k))
			--end

		elseif doorData.owner then

			--Set the header.
			doorHeader = doorData.title or "Owned"

			--Get the doorOwner.
			local doorOwner = Player(doorData.owner)

			--Make sure the owner is valid.
			if IsValid(doorOwner) then

				--Set the subHeader.
				doorSubHeader = doorOwner:Name()

			else

				doorSubHeader = "Unknown Owner"

			end

			--Check if there are any allowed co-owners.
			if doorData.allowedToOwn then

				--Check players.
				for k,v in pairs(doorData.allowedToOwn) do

					--Get the player.
					doorData.allowedToOwn[k] = Player(k)

					--Make sure that the player is valid.
					if !IsValid(doorData.allowedToOwn[k]) then

						--Remove the player.
						doorData.allowedToOwn[k] = nil

					end

				end

				--Check so we have any players left.
				if table.Count(doorData.allowedToOwn) > 0 then

					--Insert a title
					table.insert(extraText, "Allowed Co-Owners:")

					--Add the owners.
					for k,v in pairs(doorData.allowedToOwn) do

						--Insert the player into the extraText table.
						table.insert(extraText,v:Name())

					end

					--Insert an empty line.
					table.insert(extraText,"")

				end

			end

			--Check if there are any co-owners.
			if doorData.extraOwners then

				--Filter out any invalid players.
				for k,v in pairs(doorData.extraOwners) do

					doorData.extraOwners[k] = Player(k)

					if !IsValid(doorData.extraOwners[k]) then
						doorData.extraOwners[k] = nil
					end

				end

				--Check if we have any extraowners left.
				if table.Count(doorData.extraOwners) > 0 then

					--Insert a title
					table.insert(extraText, "Co-Owners:")

					--Add the owners.
					for k,v in pairs(doorData.extraOwners) do
						table.insert(extraText,v:Name())
					end

				end

			end

		end

		if doorData.org then
			if (ply.org) then
	           	if (ply.org.id == doorData.org.id) then
		            --Set the header.
					doorHeader =  "Organisation Door"

					--Set the subHeader.
					doorSubHeader = doorData.org.name
		        end
	        end
		end

	else

		--Set the texts.
		doorHeader = "For Sale"
		doorSubHeader = "Press F2 to own"

	end

	--Enforce string length limits.
	doorHeader = string.Left(doorHeader,25)
	doorSubHeader = string.Left(doorSubHeader,35)

	--Create the draw function.
	local function drawDoor( )

		--Draw the header text.
		draw.SimpleText(doorHeader,"Door_Skin_Large",displayData.canvasWidth / 2,0,Color(255,255,255,255), TEXT_ALIGN_CENTER)

		--Draw the sub-header.
		draw.SimpleText(doorSubHeader,"Door_Skin_Medium",displayData.canvasWidth / 2,130,Color(255,255,255,255), TEXT_ALIGN_CENTER)

		--Loop through the other text.
		for i = 1,#extraText do

			--Get the text.
			local text = extraText[i]

			--Draw the sub-header.
			draw.SimpleText(text,"Door_Skin_Small",displayData.canvasWidth / 2,170 + i * 58,Color(255,255,255,255), TEXT_ALIGN_CENTER)

		end

	end

	--Start 3D env.
	cam.Start3D()

		--Draw the first side of the door.
		cam.Start3D2D(door:LocalToWorld(displayData.CanvasPos1),displayData.DrawAngles + doorAngles,displayData.scale)
			drawDoor()
		cam.End3D2D()

		--Draw the other side of the door.
		cam.Start3D2D(door:LocalToWorld(displayData.CanvasPos2),displayData.DrawAngles + doorAngles + Angle(0,180,0),displayData.scale)
			drawDoor()
		cam.End3D2D()

	cam.End3D()

end

hook.Add("RenderScreenspaceEffects","GFDoorsHUD",function(  )
	local ply = LocalPlayer()

	--Find entities within sphere.
	local entities = ents.FindInSphere(ply:EyePos(),250)

	--Loop through all entities.
	for i = 1,#entities do

		--Make a var for the current entity.
		local curEnt = entities[i]

		--Check so it's a door.
		if curEnt:isDoor() and curEnt:GetClass() != "prop_dynamic" and !curEnt:GetNoDraw() then
			draw3D2DDoor( curEnt )
		end


	end

end)