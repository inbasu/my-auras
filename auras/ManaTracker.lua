local ManaTracker = {}
local formatUtils = WeakAurasPrecompiled.FormatUtils

local X = -270
local Y = -230

local function Update(text)
    -- Функция для обновления текста вынесена для производительности
    local currentMana = UnitPower("player", 0)
    local formated = formatUtils:FormatLargeNumber(currentMana)
    text:SetText(formated)
end


local function OnEvent(self, event, unit, powerType)
    if (unit == "player" and (powerType == "MANA" or not powerType)) or event == "PLAYER_ENTERING_WORLD" then
        Update(self.text)
    end
end

function ManaTracker:Create()
    -- Создаем фрейм
    local frame = CreateFrame("Frame", nil, UIParent)
    frame:SetSize(100, 20)
    frame:SetPoint("CENTER", X, Y)

    -- Создаем текст
    local text = frame:CreateFontString(nil, "OVERLAY")
    text:SetPoint("RIGHT", frame, "RIGHT", -10, 0)
    text:SetTextColor(0.12, 0.56, 1.0)
    text:SetFont(WeakAurasPrecompiled_FontPath, 20, "OUTLINE")
    frame.text = text

    -- Подписываемся на эвенты
    frame:SetScript("OnEvent", OnEvent)
    frame:RegisterEvent("UNIT_POWER_UPDATE")
    frame:RegisterEvent("UNIT_MAXPOWER")
    frame:RegisterEvent("PLAYER_ENTERING_WORLD")


    Update(text)
end

WeakAurasPrecompiled = WeakAurasPrecompiled or {}
WeakAurasPrecompiled.ManaTracker = ManaTracker
