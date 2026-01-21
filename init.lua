WeakAurasPrecompiled = WeakAurasPrecompiled or {}


function WeakAurasPrecompiled:OnInitialize()
    if self.ManaTracker then
        self.ManaTracker:Create()
    end

    if self.ExperienceTracker then
        self.ExperienceTracker:Create()
    end


    if self.TargetFrame then
        self.TargetFrame:Create()
    end
end

-- Запуск при входе в мир
local frame = CreateFrame("Frame")
frame:RegisterEvent("PLAYER_ENTERING_WORLD")
frame:SetScript("OnEvent", function(self, event)
    if event == "PLAYER_ENTERING_WORLD" then
        WeakAurasPrecompiled:OnInitialize()
        self:UnregisterEvent("PLAYER_ENTERING_WORLD")
    end
end)
