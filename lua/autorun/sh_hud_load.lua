
local folder = "glitchhud"

AddCSLuaFile(folder .. "/config.lua")
include(folder .. "/config.lua")

if SERVER then
	for k, v in pairs(file.Find(folder .. "/client/*.lua", "LUA")) do
		AddCSLuaFile(folder .. "/client/" .. v)
	end

	for k, v in pairs(file.Find(folder .. "/shared/*.lua", "LUA")) do
		AddCSLuaFile(folder .. "/shared/" .. v)
		include(folder .. "/shared/" .. v)
	end

	for k, v in pairs(file.Find(folder .. "/server/*.lua", "LUA")) do
		include(folder .. "/server/" .. v)
	end
else
	for k, v in pairs(file.Find(folder .. "/shared/*.lua", "LUA")) do
		include(folder .. "/shared/" .. v)
	end

	for k, v in pairs(file.Find(folder .. "/client/*.lua", "LUA")) do
		include(folder .. "/client/" .. v)
	end
end