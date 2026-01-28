-- ====================================
-- \Core\PlayerInfo.lua
-- ====================================

local addonName, ns = ...

function getPlayerLevel()
    if InCombatLockdown() then return end
    clickableRaidBuffCache.playerInfo.playerLevel = UnitLevel("player")
end

function getPlayerClass()
    if InCombatLockdown() then return clickableRaidBuffCache.playerInfo.playerClassId end
    local _, _, classId = UnitClass("player")
    clickableRaidBuffCache.playerInfo.playerClassId = classId
    return classId
end

function restedXPGate()
    if InCombatLockdown() then return end
    clickableRaidBuffCache.playerInfo.restedXPArea = IsResting()
end

function instanceGate()
    if InCombatLockdown() then return end
    local inInstance = IsInInstance()
    clickableRaidBuffCache.playerInfo.inInstance = inInstance
end

local function getEquippedWeaponTypes()
    local types = { mainhand = nil, offhand = nil }
    for slot, label in pairs({ [16] = "mainhand", [17] = "offhand" }) do
        local itemID = GetInventoryItemID("player", slot)
        if itemID then
            local _, _, _, _, _, classID, subClassID = C_Item.GetItemInfoInstant(itemID)
            if classID == Enum.ItemClass.Weapon then
                if subClassID == Enum.ItemWeaponSubclass.Axe1H
                or subClassID == Enum.ItemWeaponSubclass.Axe2H
                or subClassID == Enum.ItemWeaponSubclass.Sword1H
                or subClassID == Enum.ItemWeaponSubclass.Sword2H
                or subClassID == Enum.ItemWeaponSubclass.Dagger
                or subClassID == Enum.ItemWeaponSubclass.Warglaive
                or subClassID == Enum.ItemWeaponSubclass.Polearm then
                    types[label] = "BLADED"
                elseif subClassID == Enum.ItemWeaponSubclass.Mace1H
                or subClassID == Enum.ItemWeaponSubclass.Mace2H
                or subClassID == Enum.ItemWeaponSubclass.Staff
                or subClassID == Enum.ItemWeaponSubclass.Unarmed then
                    types[label] = "BLUNT"
                else
                    types[label] = "OTHER"
                end
            end
        end
    end
    return types
end

function updateWeaponTypes()
    if InCombatLockdown() then return end
    local weapTypes = getEquippedWeaponTypes()
    clickableRaidBuffCache.playerInfo.mainHand = weapTypes.mainhand or nil
    clickableRaidBuffCache.playerInfo.offHand  = weapTypes.offhand or nil
end

function updateWeaponEnchants()
    if InCombatLockdown() then return end
    local mh, mhTime, _, _, oh, ohTime = GetWeaponEnchantInfo()
    clickableRaidBuffCache.playerInfo.weaponEnchants = {
        mainhand = mh and (GetTime() + (mhTime/1000)) or nil,
        offhand  = oh and (GetTime() + (ohTime/1000)) or nil,
    }
end
