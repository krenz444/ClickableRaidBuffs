-- ====================================
-- \Data\CastableWeaponEnchants_Table.lua
-- ====================================

FurphyBuffData = FurphyBuffData or {}

local CAT = "CASTABLE_WEAPON_ENCHANTS"
FurphyBuffData[CAT] = FurphyBuffData[CAT] or {}

local t = FurphyBuffData[CAT]

t[318038] = {
  name      = "Flametongue Weapon",
  icon      = 135814,
  spellID   = 318038,
  wepEnchID = { 5400 },
  check     = "player",
  slotid    = nil,
  topLbl    = "",
  btmLbl    = "",
  gates     = { "rested" },
}

t[33757] = {
  name      = "Windfury Weapon",
  icon      = 462329,
  spellID   = 33757,
  wepEnchID = { 5401 },
  check     = "player",
  slotid    = 16,
  topLbl    = "",
  btmLbl    = "",
  gates     = { "rested" },
}

t[382021] = {
  name      = "Earthliving Weapon",
  icon      = 237578,
  spellID   = 382021,
  wepEnchID = { 6498 },
  check     = "player",
  slotid    = 16,
  topLbl    = "",
  btmLbl    = "",
  gates     = { "rested" },
}

t[462757] = {
  name      = "Thunderstrike Ward",
  icon      = 5975854,
  spellID   = 462757,
  wepEnchID = { 7587 },
  check     = "player",
  slotid    = 17,
  wepType   = "shield",
  topLbl    = "",
  btmLbl    = "",
  gates     = { "rested" },
}

t[433568] = {
  name      = "Rite of Sanctification",
  icon      = 237172,
  spellID   = 433568,
  wepEnchID = { 7143 },
  check     = "player",
  slotid    = 16,
  topLbl    = "",
  btmLbl    = "",
  gates     = { "rested" },
}

t[433583] = {
  name      = "Rite of Adjuration",
  icon      = 237051,
  spellID   = 433583,
  wepEnchID = { 7144 },
  check     = "player",
  slotid    = 16,
  topLbl    = "",
  btmLbl    = "",
  gates     = { "rested" },
}
