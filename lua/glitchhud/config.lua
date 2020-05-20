glitchhhud_config = {};

glitchhhud_config.backgroundCol = Color(0, 0, 0, 190);
glitchhhud_config.healthCol = Color(200, 50, 50, 255);
glitchhhud_config.armourCol = Color(50, 50, 200, 255);
glitchhhud_config.healthBgCol = Color(100, 30, 30, 255);
glitchhhud_config.armourBgCol = Color(30, 30, 100, 255);
glitchhhud_config.mapCol = Color(170, 170, 170, 255);
glitchhhud_config.mapBgCol = Color(0, 0, 0, 90);
glitchhhud_config.salaryCol = Color(46, 204, 113, 255);
glitchhhud_config.wantedCol = Color(231, 76, 60, 190);
glitchhhud_config.lockdownCol = Color(243, 156, 18, 190);
glitchhhud_config.wantedTextCol = Color(231, 76, 60, 255);
glitchhhud_config.unwantedTextCol = Color(46, 204, 113, 255);
glitchhhud_config.voteYesCol = Color(34, 217, 149, 100);
glitchhhud_config.voteNoCol = Color(231, 76, 60, 100);
glitchhhud_config.gpsPointCol = Color(255, 100, 100);

/*
	Minimap configuration
*/

glitchhhud_config.maps = {}
glitchhhud_config.maps["rp_evocity_v33x"] = {
	["texture"] = Material('aaa/evoreal.png', 'smooth'),
	["offsetx"] = 520, 
	["offsety"] = -1900,
	["scale"] = 3.8
	
}
glitchhhud_config.maps["rp_downtown_tits_v2"] = {
	["texture"] = Material('aaa/mapreal.png', 'smooth'),
	["offsetx"] = -4412, 
	["offsety"] = 1230,
	["scale"] = 4.7
}

/*
	Icons configuration
*/

glitchhhud_config.icons = {};
glitchhhud_config.icons["Player"] = Material("glitchfire/minimap/waypoint_player.png", "smooth");
glitchhhud_config.icons["Pin"] = Material("glitchfire/minimap/waypoint_pin.png", "smooth");
glitchhhud_config.icons["Police"] = Material("glitchfire/minimap/waypoint_police.png", "smooth");
glitchhhud_config.icons["Gun"] = Material("glitchfire/minimap/waypoint_gun.png", "smooth");
glitchhhud_config.icons["Money"] = Material("glitchfire/minimap/waypoint_money.png", "smooth");
glitchhhud_config.icons["Cards"] = Material("glitchfire/minimap/waypoint_cards.png", "smooth");
glitchhhud_config.icons["Car"] = Material("glitchfire/minimap/waypoint_car.png", "smooth");
glitchhhud_config.icons["Health"] = Material("glitchfire/minimap/waypoint_health.png", "smooth");
glitchhhud_config.icons["Needle"] = Material("glitchfire/minimap/waypoint_needle.png", "smooth");
glitchhhud_config.icons["Race"] = Material("glitchfire/minimap/waypoint_race.png", "smooth");
glitchhhud_config.icons["Handcuffs"] = Material("glitchfire/minimap/waypoint_cuffs.png", "smooth");
glitchhhud_config.icons["Boat"] = Material("glitchfire/minimap/waypoint_boat.png", "smooth");
glitchhhud_config.icons["Bulb"] = Material("glitchfire/minimap/waypoint_bulb.png", "smooth");
glitchhhud_config.icons["Home"] = Material("glitchfire/minimap/waypoint_home.png", "smooth");
glitchhhud_config.icons["Drugs"] = Material("glitchfire/minimap/waypoint_drugs.png", "smooth");
glitchhhud_config.icons["Other Player"] = Material("glitchfire/minimap/waypoint_otherplayer.png", "smooth");
glitchhhud_config.icons["Glitch Fire"] = Material("glitchfire/logo/logo.png", "smooth");