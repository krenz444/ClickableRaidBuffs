-- ====================================
-- \Modules\FixedTarget.lua
-- ====================================

local addonName, ns = ...

local function DB()
    local d = (ns.GetDB and ns.GetDB()) or _G.ClickableRaidBuffsDB
    if type(d) ~= "table" then
        _G.ClickableRaidBuffsDB = _G.ClickableRaidBuffsDB or {}
        d = _G.ClickableRaidBuffsDB
    end
    d.fixedTargets = d.fixedTargets or {}
    return d
end

local function MigrateLegacyCache()
    if type(_G.clickableRaidBuffCache) == "table"
       and type(_G.clickableRaidBuffCache.fixedTargets) == "table" then
        local dst = DB().fixedTargets
        local src = _G.clickableRaidBuffCache.fixedTargets
        for k, v in pairs(src) do
            if dst[k] == nil and type(k) == "number" and type(v) == "string" and v ~= "" then
                dst[k] = v
            end
        end
        _G.clickableRaidBuffCache.fixedTargets = nil
    end
end

local TRUNCATE_N = 6

local function ShortNameFromUnit(unit)
    local name = UnitName(unit)
    if not name or name == "" then return nil end
    return name
end

local function TruncatedShort(name)
    if not name then return nil end
    if TRUNCATE_N and TRUNCATE_N > 0 then
        return name:sub(1, TRUNCATE_N)
    end
    return name
end

local function BuildTrackedSpellList()
    if InCombatLockdown() then return {} end
    local classID = _G.clickableRaidBuffCache
        and _G.clickableRaidBuffCache.playerInfo
        and _G.clickableRaidBuffCache.playerInfo.playerClassId
    if not classID and type(ns.getPlayerClass) == "function" then
        classID = ns.getPlayerClass()
    end
    local tbl = classID and _G.ClickableRaidData and _G.ClickableRaidData[classID]
    local out = {}
    if not tbl then return out end
    for spellID, data in pairs(tbl) do
        if type(spellID) == "number" and type(data) == "table" and data.count then
            out[spellID] = data
        end
    end
    return out
end

local function UnitHasMyAuraForRow(unit, row)
    if not unit or not row then return false end
    local wantByName, idLookup
    if row.nameMode then
        local info = C_Spell.GetSpellInfo(row.buffID and row.buffID[1])
        wantByName = info and info.name
        if not wantByName then return false end
    else
        idLookup = {}
        if row.buffID then
            for _, id in ipairs(row.buffID) do idLookup[id] = true end
        end
    end
    local i = 1
    while true do
        local aura = C_UnitAuras.GetAuraDataByIndex(unit, i, "HELPFUL")
        if not aura then break end
        if aura.sourceUnit and UnitIsUnit(aura.sourceUnit, "player") then
            if wantByName then
                if aura.name == wantByName then return true end
            else
                if aura.spellId and idLookup[aura.spellId] then return true end
            end
        end
        i = i + 1
    end
    return false
end

local function IterateGroupUnits()
    local units = {}
    if IsInRaid() then
        for i = 1, GetNumGroupMembers() do units[#units+1] = "raid"..i end
    elseif IsInGroup() then
        for i = 1, GetNumSubgroupMembers() do units[#units+1] = "party"..i end
        units[#units+1] = "player"
    else
        units[#units+1] = "player"
    end
    return units
end

local function CleanCacheForRoster()
    local present = {}
    for _, unit in ipairs(IterateGroupUnits()) do
        local short = ShortNameFromUnit(unit)
        if short then present[short] = true end
    end
    local ft = DB().fixedTargets
    local changed = false
    for spellID, short in pairs(ft) do
        if short and not present[short] then
            ft[spellID] = nil
            changed = true
        end
    end
    return changed
end

local function RebuildFixedTargetCacheFromAuras()
    local tracked = BuildTrackedSpellList()
    if not next(tracked) then return false end
    local units = IterateGroupUnits()
    local ft = DB().fixedTargets
    local changed = false
    for spellID, row in pairs(tracked) do
        local remembered = ft[spellID]
        local foundShort
        for _, unit in ipairs(units) do
            if UnitHasMyAuraForRow(unit, row) then
                foundShort = ShortNameFromUnit(unit)
                break
            end
        end
        if foundShort and foundShort ~= remembered then
            ft[spellID] = foundShort
            changed = true
        end
    end
    return changed
end

function ns.FixedTarget_InjectIcons()
    if InCombatLockdown() then return end
    local display = _G.clickableRaidBuffCache and _G.clickableRaidBuffCache.displayable
    if not display then return end
    local rb = display.RAID_BUFFS
    if not rb then return end
    local tracked = BuildTrackedSpellList()
    if not next(tracked) then
        for spellID in pairs(DB().fixedTargets) do
            rb["fixed:"..spellID] = nil
        end
        return
    end
    for spellID, base in pairs(rb) do
        if tracked[spellID] then
            local short = DB().fixedTargets[spellID]
            if short and short ~= "" then
                local e = ns.copyItemData(base)
                e.isFixed = true
                local spellName = (C_Spell.GetSpellInfo(spellID) or {}).name or ""
                e.macro   = "/use [@" .. short .. "] " .. spellName
                e.btmLbl  = TruncatedShort(short)
                e.texture = base.icon
                e.expireTime = base.expireTime
                e.showAt     = base.showAt
                rb["fixed:"..spellID] = e
            else
                rb["fixed:"..spellID] = nil
            end
        end
    end
end

local function EnsureRenderHook()
    if ns._fixedTargetWrapped then return end
    if type(ns.RenderAll) == "function" then
        local orig = ns.RenderAll
        ns.RenderAll = function(...)
            if ns.FixedTarget_InjectIcons then ns.FixedTarget_InjectIcons() end
            return orig(...)
        end
        ns._fixedTargetWrapped = true
    end
end

function ns.FixedTarget_Init()
    if InCombatLockdown() then return false end
    MigrateLegacyCache()
    EnsureRenderHook()
    local c1 = RebuildFixedTargetCacheFromAuras()
    local c2 = CleanCacheForRoster()
    ns.FixedTarget_InjectIcons()
    return (c1 or c2) and true or false
end

function ns.FixedTarget_OnRosterChanged()
    if InCombatLockdown() then return false end
    EnsureRenderHook()
    local c1 = CleanCacheForRoster()
    local c2 = RebuildFixedTargetCacheFromAuras()
    ns.FixedTarget_InjectIcons()
    return (c1 or c2) and true or false
end

function ns.FixedTarget_OnUnitAura(unit, updateInfo)
    if InCombatLockdown() then return false end
    if not unit or (unit ~= "player" and not unit:match("^party%d") and not unit:match("^raid%d")) then
        return false
    end
    local tracked = BuildTrackedSpellList()
    if not next(tracked) then return false end
    local ft = DB().fixedTargets
    local changed = false
    for spellID, row in pairs(tracked) do
        if UnitHasMyAuraForRow(unit, row) then
            local who = ShortNameFromUnit(unit)
            if who and who ~= ft[spellID] then
                ft[spellID] = who
                changed = true
            end
        end
    end
    if changed then
        ns.FixedTarget_InjectIcons()
    end
    return changed
end
