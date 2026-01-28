-- ====================================
-- \Options\Bridge.lua
-- ====================================

local addonName, ns = ...

function ns.SetIconSize(size)
    local db = ns.GetDB()
    db.iconSize = size
    if ns.RenderAll then ns.RenderAll() end
end

function ns.SetGlow(enabled, r, g, b, a)
    local db = ns.GetDB()
    db.glowEnabled = enabled
    db.glowColor = { r = r, g = g, b = b, a = a }
    if ns.RenderAll then ns.RenderAll() end
end

function ns.SetSpecialGlow(r, g, b, a)
    local db = ns.GetDB()
    db.specialGlowColor = { r = r, g = g, b = b, a = a }
    if ns.RenderAll then ns.RenderAll() end
end

function ns.SetFontName(name)
    local db = ns.GetDB()
    db.fontName = name
    if ns.RenderAll then ns.RenderAll() end
end

function ns.SetFontSizes(top, bottom, center)
    local db = ns.GetDB()
    db.topSize = top
    db.bottomSize = bottom
    db.timerSize = center
    if ns.RenderAll then ns.RenderAll() end
end

function ns.SetFontOutlines(top, bottom, center)
    local db = ns.GetDB()
    db.topOutline = top
    db.bottomOutline = bottom
    db.timerOutline = center
    if ns.RenderAll then ns.RenderAll() end
end

function ns.SetTextColor(which, r, g, b, a)
    local db = ns.GetDB()
    if which == "top" then
        db.topTextColor = { r = r, g = g, b = b, a = a }
    elseif which == "bottom" then
        db.bottomTextColor = { r = r, g = g, b = b, a = a }
    else
        db.timerTextColor = { r = r, g = g, b = b, a = a }
    end
    if ns.RenderAll then ns.RenderAll() end
end

function ns.RefreshFonts()
    if ns.RenderAll then ns.RenderAll() end
end

function ns.SetCornerFont(size, outline)
    local db = ns.GetDB()
    db.cornerSize = size
    db.cornerOutline = (outline ~= false)
    if ns.RenderAll then ns.RenderAll() end
end

function ns.SetCornerTextColor(r, g, b, a)
    local db = ns.GetDB()
    db.cornerTextColor = { r=r, g=g, b=b, a=a }
    if ns.RenderAll then ns.RenderAll() end
end

function ns.RefreshGlow()
    if ns.RenderAll then ns.RenderAll() end
end

function ns.RequestRebuild()
    if ns._inCombat or InCombatLockdown() then
        return
    end

    if type(ns.UpdateAugmentRunes) == "function" then
        ns.UpdateAugmentRunes()
    end

    if type(_G.scanRaidBuffs) == "function" then
        _G.scanRaidBuffs()
    end

    if type(_G.scanAllBags) == "function" then
        _G.scanAllBags()
    end

    if type(ns.RenderAll) == "function" then
        ns.RenderAll()
    end

    if type(ns.Timer_RecomputeSchedule) == "function" then
        ns.Timer_RecomputeSchedule()
    end
end