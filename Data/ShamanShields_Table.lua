-- ====================================
-- \Data\ShamanShields_Table.lua
-- ====================================

FurphyBuffData = FurphyBuffData or {}

FurphyBuffData["SHAMAN_SHIELDS"] = {
  [192106] = {
    name    = "Lightning Shield",
    spellID = 192106,
    buffID  = { 192106 },
    check   = "player",
    target  = "player",
    topLbl  = "",
    btmLbl  = "",
  },

  [52127] = {
    name    = "Water Shield",
    spellID = 52127,
    buffID  = { 52127 },
    check   = "player",
    target  = "player",
    topLbl  = "",
    btmLbl  = "",
  },

  [974] = {
    name        = "Earth Shield",
    spellID     = 974,
    buffOnOthers= 974,
    buffOnSelf  = 383648,
    check       = "raid",
    target      = "target",
    topLbl      = "",
    btmLbl      = STATUS_TEXT_TARGET,
    gates       = "mineOnly",
  },
}