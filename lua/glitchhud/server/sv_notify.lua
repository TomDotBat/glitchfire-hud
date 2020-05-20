function glitchHUDNotify(title, subtitle, color, recipients, sendType)
    if (!sendType) then
        if (istable(recipients)) then
            sendType = "send"
        elseif (isvector(recipients)) then
            sendType = "pvs"
        elseif (recipients:IsPlayer()) then
            sendType = "send"
        elseif (recipients == "") then
            sendType = "broadcast"
        end
    end

    net.Start("GlitchHUDNotify")
    net.WriteString(title)
    net.WriteString(subtitle)
    net.WriteColor(color)

    if (sendType == "send") then
        net.Send(recipients)
    elseif (sendType == "sendomit") then
        net.SendOmit(recipients)
    elseif (sendType == "pas") then
        net.SendPAS(recipients)
    elseif (sendType == "pvs") then
        net.SendPVS(recipients)
    elseif (sendType == "broadcast") then
        net.Broadcast()
    else
        net.Send(recipients)
    end
end

hook.Add("playerWanted", "GlitchHUDNotifyWanted", function(ply, actor, reason)
    local actorNick = IsValid(actor) and actor:Nick() or DarkRP.getPhrase("disconnected_player")

    glitchHUDNotify("WANTED",
        "You have been made wanted by " .. actorNick .. "!",
        glitchhhud_config.wantedTextCol,
        ply,
        "send"
    )

    glitchHUDNotify("WANTED",
        ply:Nick() .. " has been made wanted by " .. actorNick .. "!",
        glitchhhud_config.wantedTextCol,
        ply,
        "sendomit"
    )

    return true 
end)

hook.Add("playerUnWanted", "GlitchHUDNotifyUnWanted", function(ply, actor)
    glitchHUDNotify("UNWANTED",
        "You are no longer wanted!",
        glitchhhud_config.unwantedTextCol,
        ply,
        "send"
    )

    glitchHUDNotify("UNWANTED",
        ply:Nick() .. " is no longer wanted!",
        glitchhhud_config.unwantedTextCol,
        ply,
        "sendomit"
    )

    return true 
end)

hook.Add("playerWarranted", "GlitchHUDNotifyWarranted", function(ply, actor, reason)
    glitchHUDNotify("WARRANT",
        "The warrant on you was approved!",
        glitchhhud_config.wantedTextCol,
        ply,
        "send"
    )

    glitchHUDNotify("WARRANT",
        "The warrant on " .. ply:Nick() .. " was approved!",
        glitchhhud_config.wantedTextCol,
        ply,
        "sendomit"
    )

    return true 
end)

hook.Add("playerUnWarranted", "GlitchHUDNotifyUnWarranted", function(ply, actor, reason)
    glitchHUDNotify("WARRANT EXPIRED",
        "The warrant on you has expired!",
        glitchhhud_config.unwantedTextCol,
        ply,
        "send"
    )

    glitchHUDNotify("WARRANT EXPIRED",
        "The warrant on " .. ply:Nick() .. " has expired!",
        glitchhhud_config.unwantedTextCol,
        ply,
        "sendomit"
    )

    return true 
end)

local isLockdown = false

hook.Add("Tick", "GlitchHUDLockdownCheck", function()
    if isLockdown != GetGlobalBool("DarkRP_LockDown") then
        isLockdown = !isLockdown

        if isLockdown then
            glitchHUDNotify("LOCKDOWN",
                "The mayor started a lockdown, stay off the streets!",
                glitchhhud_config.wantedTextCol,
                nil,
                "broadcast"
            )
        else
            glitchHUDNotify("LOCKDOWN ENDED",
                "The mayor ended the lockdown!",
                glitchhhud_config.unwantedTextCol,
                nil,
                "broadcast"
            )
        end
    end
end)

util.AddNetworkString("GlitchHUDNotify")