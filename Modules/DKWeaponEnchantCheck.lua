-- ====================================
-- \Modules\DKWeaponEnchantCheck.lua
-- ====================================

local addonName, ns = ...

clickableRaidBuffCache = clickableRaidBuffCache or {}
clickableRaidBuffCache.displayable = clickableRaidBuffCache.displayable or {}

local CAT = "DK_WEAPON_ENCHANTS"
local DEATH_GATE_SPELL = 50977

local function DB() return (ns.GetDB and ns.GetDB()) or ClickableRaidBuffsDB or {} end
local function InCombat() return InCombatLockdown() end
local function IsDeadOrGhost() return UnitIsDeadOrGhost("player") end

local function ensureCat()
  clickableRaidBuffCache.displayable[CAT] = clickableRaidBuffCache.displayable[CAT] or {}
  return clickableRaidBuffCache.displayable[CAT]
end

local function clearCat()
  if clickableRaidBuffCache.displayable[CAT] then wipe(clickableRaidBuffCache.displayable[CAT]) end
end

local function isDK()
  if InCombat() then return clickableRaidBuffCache.playerInfo and clickableRaidBuffCache.playerInfo.playerClassId == 6 end
  local cid = (clickableRaidBuffCache.playerInfo and clickableRaidBuffCache.playerInfo.playerClassId)
              or (type(getPlayerClass) == "function" and getPlayerClass())
  return cid == 6
end

local function knowSpell(id)
  return (C_SpellBook and C_SpellBook.IsSpellKnown and C_SpellBook.IsSpellKnown(id))
         or (IsPlayerSpell and IsPlayerSpell(id)) or false
end

local function enchantIdFromLink(link)
  if not link or link == "" then return 0 end
  local ench = link:match("item:%d+:(-?%d+):")
  local n = tonumber(ench)
  return (n and n > 0) and n or 0
end

local function slotHasEnchant(slotId)
  local link = GetInventoryItemLink("player", slotId)
  if not link then return false, false end  -- no item, no enchant
  local enchID = enchantIdFromLink(link)
  return true, enchID ~= 0
end

local function Build()
  if InCombat() or IsDeadOrGhost() then
    clearCat()
    if ns.RenderAll and not InCombat() then ns.RenderAll() end
    return
  end

  if not isDK() or not knowSpell(DEATH_GATE_SPELL) then
    clearCat()
    if ns.RenderAll and not InCombat() then ns.RenderAll() end
    return
  end

  local out = ensureCat()
  wipe(out)

  local mhEquipped, mhEnch = slotHasEnchant(16)
  local ohEquipped, ohEnch = slotHasEnchant(17)
  local need = (mhEquipped and not mhEnch) or (ohEquipped and not ohEnch)

  if need then
    local info = C_Spell.GetSpellInfo(DEATH_GATE_SPELL)
    local e = {
      id        = -9103, 
      isItem    = false,
      category  = CAT,
      name      = (info and info.name) or "Death Gate",
      icon      = (info and info.iconID) or 136210,
      macro     = "/use " .. ((info and info.name) or "Death Gate"),
      topLbl    = "",
      btmLbl    = "",
      orderHint = 10,
      glow      = "special",
    }
    out["dk:deathgate"] = e
  end

  if ns.RenderAll and not InCombat() then ns.RenderAll() end
end

function ns.DKWeaponEnchantCheck_Rebuild()
  Build()
end