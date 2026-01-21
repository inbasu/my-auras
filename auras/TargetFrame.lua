local TargetFrame = {}
local formatUtils = WeakAurasPrecompiled.FormatUtils



local X = 0
local Y = -207

local function GetClassColor()
    local className = UnitClass("target"):upper()
    if className and RAID_CLASS_COLORS[className] then
        local color = RAID_CLASS_COLORS[className]
        return string.format("%02x%02x%02x", color.r * 255, color.g * 255, color.b * 255)
    end
    return "FFFFFF"
end


local function Update(frame, text)
    local targetName = UnitName("target")
    if not targetName or targetName == "" then
        text:SetText("")
        return -- Выходим из функции
    end
    local targetHP = UnitHealth("target")
    local maxHP = UnitHealthMax("target")
    local color = GetClassColor()
    local fmtHP = formatUtils:FormatLargeNumber(targetHP)
    local percent = maxHP > 0 and math.floor((targetHP / maxHP) * 100) or 0

    local displayText = string.format("%s  %d%%  |cff%s%s|r", fmtHP, percent, color, targetName)
    text:SetText(displayText)
    frame:SetAttribute("unit", "target")
end


local function OnEvent(self, event, unit)
    if event == "PLAYER_TARGET_CHANGED" or
        (event == "UNIT_HEALTH" and unit == "target") then
        Update(self, self.text)
    end
end

function TargetFrame:Create()
    -- Создаем фрейм

    local frame = CreateFrame("Button", "WeakAurasPrecompiled_TargetButton", UIParent, "SecureUnitButtonTemplate")
    frame:SetSize(150, 20)
    frame:SetPoint("CENTER", X, Y)

    frame:SetAttribute("type2", "togglemenu") -- ПКМ: меню
    frame:SetAttribute("unit", "target")
    frame:RegisterForClicks("RightButtonUp")


    -- Инициализируем шрифт
    local font = CreateFont("WeakAurasPrecompiled_ManaFont")
    font:SetFont(WeakAurasPrecompiled_FontPath, 17, "OUTLINE")

    -- Создаем текст
    local text = frame:CreateFontString(nil, "OVERLAY")
    text:SetFontObject(font)
    text:SetPoint("CENTER", 0, 0)
    text:SetIgnoreParentAlpha(true)

    frame.text = text

    frame:SetScript("OnEvent", OnEvent)
    frame:RegisterEvent("PLAYER_TARGET_CHANGED")
    frame:RegisterEvent("UNIT_HEALTH")
    frame:RegisterEvent("UNIT_MAXHEALTH")


    Update(frame, text)
end

WeakAurasPrecompiled = WeakAurasPrecompiled or {}
WeakAurasPrecompiled.TargetFrame = TargetFrame
