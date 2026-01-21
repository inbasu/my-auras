local ExperienceTracker = {}

local X = -620
local Y = -580


local function Update(text)
    local currentXP = UnitXP("player")
    local maxXP = UnitXPMax("player")
    local restedXP = GetXPExhaustion() or 0

    local fmtCurrentXP = WeakAurasPrecompiled.FormatUtils:FormatLargeNumber(currentXP)
    local fmtMaxXP = WeakAurasPrecompiled.FormatUtils:FormatLargeNumber(maxXP)
    local percents = currentXP / maxXP
    local bars = math.floor(percents * 20)
    local exacPercentes = math.floor(percents * 100)

    local displayText = string.format("EXP: %s / %s [ %s bars | %s%% ]", fmtCurrentXP, fmtMaxXP, bars, exacPercentes)
    if restedXP > 0 then
        local fmtRestedXP = WeakAurasPrecompiled.FormatUtils:FormatLargeNumber(restedXP)

        displayText = displayText .. string.format(" + %s rested", fmtRestedXP)
    end

    text:SetText(displayText)
end



local function OnEvent(self, event)
    Update(self.text)
end

function ExperienceTracker:Create()
    self.HideBlizzardExperienceBar()

    local frame = CreateFrame("Frame", nil, UIParent)
    frame:SetSize(100, 20)
    frame:SetPoint("CENTER", X, Y)


    -- Создаем текст
    local text = frame:CreateFontString(nil, "OVERLAY")
    text:SetPoint("LEFT", frame, "LEFT", -10, 0)
    text:SetTextColor(1, 1, 1, 0.7)

    text:SetFont(WeakAurasPrecompiled_FontPath, 16, "OUTLINE")
    frame.text = text

    frame:SetScript("OnEvent", OnEvent)
    frame:RegisterEvent("PLAYER_XP_UPDATE")
    frame:RegisterEvent("UPDATE_EXHAUSTION")
    frame:RegisterEvent("PLAYER_LEVEL_UP")
    frame:RegisterEvent("PLAYER_ENTERING_WORLD")

    Update(text)
end

function ExperienceTracker:HideBlizzardExperienceBar()
    -- ОТКЛЮЧАМ ПОЛОСКУ ЭКСПЫ
    if StatusTrackingBarManager then
        StatusTrackingBarManager:Hide()
        StatusTrackingBarManager:UnregisterAllEvents()
    end

    local elements = {
        "MainMenuExpBar",
        "ReputationWatchBar",
        "MainMenuBarMaxLevelBar",
        "ExhaustionTick",
        "ExhaustionLevelFillBar",
        "MainMenuXPBarTexture0",
        "MainMenuXPBarTexture1",
        "MainMenuXPBarTexture2",
        "MainMenuXPBarTexture3"
    }

    for _, name in pairs(elements) do
        local frame = _G[name]
        if frame then
            frame:Hide()
            frame:SetAlpha(0)
            frame:UnregisterAllEvents()
        end
    end

    if MainMenuBar then
        MainMenuBar:UnregisterEvent("PLAYER_XP_UPDATE")
        MainMenuBar:UnregisterEvent("UPDATE_EXHAUSTION")
        MainMenuBar:UnregisterEvent("PLAYER_LEVEL_UP")
    end
end

WeakAurasPrecompiled = WeakAurasPrecompiled or {}
WeakAurasPrecompiled.ExperienceTracker = ExperienceTracker
