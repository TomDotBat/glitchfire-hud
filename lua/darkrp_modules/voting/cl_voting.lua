
surface.CreateFont("GlitchHUDVoteTitle", {
    font = "Roboto",
    size = 30,
    weight = 500,
})

surface.CreateFont("GlitchHUDVoteQuestion", {
    font = "Roboto",
    size = 18,
    weight = 350,
})

surface.CreateFont("GlitchHUDVoteButton", {
    font = "Roboto",
    size = 15,
    weight = 500,
})

local QuestionVGUI = {}
local PanelNum = 0
local VoteVGUI = {}
local function MsgDoVote(msg)
    local _, chatY = chat.GetChatBoxPos()

    local question = msg:ReadString()
    local voteid = msg:ReadShort()
    local timeleft = msg:ReadFloat()
    if timeleft == 0 then
        timeleft = 100
    end
    local OldTime = CurTime()
    if not IsValid(LocalPlayer()) then return end -- Sent right before player initialisation

    LocalPlayer():EmitSound("Town.d1_town_02_elevbell1", 100, 100)
    local panel = vgui.Create("DFrame")
    panel:SetPos(30 + PanelNum, ScrH()*0.3)
    panel:SetTitle(DarkRP.getPhrase("vote"))
    panel:SetSize(190, 190)
    panel:SetSizable(false)
    panel.btnClose:SetVisible(false)
    panel.btnMaxim:SetVisible(false)
    panel.btnMinim:SetVisible(false)
    panel:SetDraggable(false)
    panel:SetKeyboardInputEnabled(false)
    panel:SetMouseInputEnabled(true)
    panel:SetVisible(true)
    panel:SetTitle("")

    function panel:Close()
        PanelNum = PanelNum - 200
        VoteVGUI[voteid .. "vote"] = nil

        local num = 0
        for _, v in SortedPairs(VoteVGUI) do
            v:SetPos(30 + num, ScrH()*0.3)
            num = num + 140
        end

        for _, v in SortedPairs(QuestionVGUI) do
            v:SetPos(30 + num, ScrH()*0.3)
            num = num + 300
        end
        self:Remove()
    end

    function panel:Think()
        if timeleft - (CurTime() - OldTime) <= 0 then
            panel:Close()
        end
    end

    local explosivedog = string.Explode("\n", question)
    for k,v in ipairs(explosivedog) do
        if (k == 1) then
            question = v .. "\n"
        else
            question = question .. " " .. v
        end
    end

    panel.question = DarkRP.deLocalise(question)

    function panel:Paint(w, h)
        draw.RoundedBox( 0, 0, 0, w, h, glitchhhud_config.backgroundCol )
        draw.SimpleText( "Vote", "GlitchHUDVoteTitle", w*0.5, h*0.05, color_white, TEXT_ALIGN_CENTER )
        draw.DrawText(self.question, "GlitchHUDVoteQuestion", w*0.5, h*0.25, color_white, TEXT_ALIGN_CENTER)
        draw.DrawText("This vote expires in\n" .. math.Round(OldTime + timeleft - CurTime())  .. " seconds",  "GlitchHUDVoteQuestion", w*0.5, h*0.52, color_white, TEXT_ALIGN_CENTER)
    end

    local ybutton = vgui.Create("Button")
    ybutton:SetParent(panel)
    ybutton:SetPos(10, 157)
    ybutton:SetSize(80, 23)
    ybutton:SetTextColor(color_white)
    ybutton:SetFont("GlitchHUDVoteButton")
    ybutton:SetCommand("!")
    ybutton:SetText(DarkRP.getPhrase("yes"))
    ybutton:SetVisible(true)

    function ybutton:DoClick()
        LocalPlayer():ConCommand("vote " .. voteid .. " yea\n")
        panel:Close()
    end

    function ybutton:Paint(w, h)
        draw.RoundedBox( 0, 0, 0, w, h, glitchhhud_config.voteYesCol )
    end

    local nbutton = vgui.Create("Button")
    nbutton:SetParent(panel)
    nbutton:SetPos(100, 157)
    nbutton:SetSize(80, 23)
    nbutton:SetTextColor(color_white)
    nbutton:SetFont("GlitchHUDVoteButton")
    nbutton:SetCommand("!")
    nbutton:SetText(DarkRP.getPhrase("no"))
    nbutton:SetVisible(true)

    function nbutton:DoClick()
        LocalPlayer():ConCommand("vote " .. voteid .. " nay\n")
        panel:Close()
    end

    function nbutton:Paint(w, h)
        draw.RoundedBox( 0, 0, 0, w, h, glitchhhud_config.voteNoCol )
    end

    PanelNum = PanelNum + 200
    VoteVGUI[voteid .. "vote"] = panel
end
usermessage.Hook("DoVote", MsgDoVote)

local function KillVoteVGUI(msg)
    local id = msg:ReadShort()

    if VoteVGUI[id .. "vote"] and VoteVGUI[id .. "vote"]:IsValid() then
        VoteVGUI[id .. "vote"]:Close()
    end
end
usermessage.Hook("KillVoteVGUI", KillVoteVGUI)

local function MsgDoQuestion(msg)
    if not IsValid(LocalPlayer()) then return end

    local question = msg:ReadString()
    local quesid = msg:ReadString()
    local timeleft = msg:ReadFloat()
    if timeleft == 0 then
        timeleft = 100
    end
    local OldTime = CurTime()

    LocalPlayer():EmitSound("Town.d1_town_02_elevbell1", 100, 100)

    local panel = vgui.Create("DFrame")
    panel:SetPos(30 + PanelNum, ScrH()*0.3) -- Times 140 because if the question is the second screen, the first screen is always a vote screen.
    panel:SetSize(190, 190)
    panel:SetSizable(false)
    panel:ShowCloseButton(false)
    panel:SetKeyboardInputEnabled(false)
    panel:SetMouseInputEnabled(true)
    panel:SetVisible(true)
    panel:SetTitle("")

    function panel:Close()
        PanelNum = PanelNum - 200
        QuestionVGUI[quesid .. "ques"] = nil
        local num = 0
        for _, v in SortedPairs(VoteVGUI) do
            v:SetPos(30 + num, ScrH()*0.3)
            num = num + 140
        end

        for _, v in SortedPairs(QuestionVGUI) do
            v:SetPos(30 + num, ScrH()*0.3)
            num = num + 300
        end

        self:Remove()
    end

    function panel:Think()
        if timeleft - (CurTime() - OldTime) <= 0 then
            panel:Close()
        end
    end

    panel.question = DarkRP.deLocalise(question)

    function panel:Paint(w, h)
        draw.RoundedBox( 0, 0, 0, w, h, glitchhhud_config.backgroundCol )
        draw.SimpleText( "Question", "GlitchHUDVoteTitle", w*0.5, h*0.05, color_white, TEXT_ALIGN_CENTER )
        draw.DrawText(self.question, "GlitchHUDVoteQuestion", w*0.5, h*0.25, color_white, TEXT_ALIGN_CENTER)
        draw.DrawText("This expires in\n" .. math.Round(OldTime + timeleft - CurTime())  .. " seconds",  "GlitchHUDVoteQuestion", w*0.5, h*0.55, color_white, TEXT_ALIGN_CENTER)
    end

    local ybutton = vgui.Create("DButton")
    ybutton:SetParent(panel)
    ybutton:SetPos(10, 157)
    ybutton:SetSize(80, 23)
    ybutton:SetTextColor(color_white)
    ybutton:SetFont("GlitchHUDVoteButton")
    ybutton:SetText(DarkRP.getPhrase("yes"))
    ybutton:SetVisible(true)

    function ybutton:DoClick()
        LocalPlayer():ConCommand("ans " .. quesid .. " 1\n")
        panel:Close()
    end

    function ybutton:Paint(w, h)
        draw.RoundedBox( 0, 0, 0, w, h, glitchhhud_config.voteYesCol )
    end

    local nbutton = vgui.Create("DButton")
    nbutton:SetParent(panel)
    nbutton:SetPos(100, 157)
    nbutton:SetSize(80, 23)
    nbutton:SetTextColor(color_white)
    nbutton:SetFont("GlitchHUDVoteButton")
    nbutton:SetText(DarkRP.getPhrase("no"))
    nbutton:SetVisible(true)

    function nbutton:DoClick()
        LocalPlayer():ConCommand("ans " .. quesid .. " 2\n")
        panel:Close()
    end

    function nbutton:Paint(w, h)
        draw.RoundedBox( 0, 0, 0, w, h, glitchhhud_config.voteNoCol )
    end

    PanelNum = PanelNum + 200
    QuestionVGUI[quesid .. "ques"] = panel
end
usermessage.Hook("DoQuestion", MsgDoQuestion)

local function KillQuestionVGUI(msg)
    local id = msg:ReadString()

    if QuestionVGUI[id .. "ques"] and QuestionVGUI[id .. "ques"]:IsValid() then
        QuestionVGUI[id .. "ques"]:Close()
    end
end
usermessage.Hook("KillQuestionVGUI", KillQuestionVGUI)

local function DoVoteAnswerQuestion(ply, cmd, args)
    if not args[1] then return end

    local vote = 0
    if tonumber(args[1]) == 1 or string.lower(args[1]) == "yes" or string.lower(args[1]) == "true" then vote = 1 end

    for k, v in pairs(VoteVGUI) do
        if IsValid(v) then
            local ID = string.sub(k, 1, -5)
            VoteVGUI[k]:Close()
            RunConsoleCommand("vote", ID, vote)
            return
        end
    end

    for k, v in pairs(QuestionVGUI) do
        if IsValid(v) then
            local ID = string.sub(k, 1, -5)
            QuestionVGUI[k]:Close()
            RunConsoleCommand("ans", ID, vote)
            return
        end
    end
end
concommand.Add("rp_vote", DoVoteAnswerQuestion)