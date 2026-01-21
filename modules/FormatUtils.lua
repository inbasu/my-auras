local FormatUtils = {}



function FormatUtils:FormatLargeNumber(value)
    if not value then return 0 end
    if value >= 1000 then
        return string.format("%.3f", value / 1000)
    else
        return string.format("%d", value)
    end
end

WeakAurasPrecompiled = WeakAurasPrecompiled or {}
WeakAurasPrecompiled.FormatUtils = FormatUtils
