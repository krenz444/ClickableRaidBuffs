-- ====================================
-- \Data\Pets_Table.lua
-- ====================================

FurphyBuffData = FurphyBuffData or {}

local playerClassID = furphyBuffCache.playerInfo.playerClassId or getPlayerClass()

-- =========================
-- Hunter
-- =========================
if playerClassID == 3 then
  FurphyBuffData["PETS"] = FurphyBuffData["PETS"] or {
    [883] = { name = "Call Pet 1", spellID = 883, topLbl = "", btmLbl = "", gates = { "evenRested", "no_pet", "not_mounted" } },
	[83242] = { name = "Call Pet 2", spellID = 83242, topLbl = "", btmLbl = "", gates = { "evenRested", "no_pet", "not_mounted" } },
	[83243] = { name = "Call Pet 3", spellID = 83243, topLbl = "", btmLbl = "", gates = { "evenRested", "no_pet", "not_mounted" } },
	[83244] = { name = "Call Pet 4", spellID = 83244, topLbl = "", btmLbl = "", gates = { "evenRested", "no_pet", "not_mounted" } },
	[83245] = { name = "Call Pet 5", spellID = 83245, topLbl = "", btmLbl = "", gates = { "evenRested", "no_pet", "not_mounted" } },
    [982] = { name = "Revive Pet", spellID = 982, topLbl = "Revive", btmLbl = "", gates = { "evenRested", "no_pet", "not_mounted" } },
  }
end

-- =========================
-- Death Knight
-- =========================
if playerClassID == 6 then
  FurphyBuffData["PETS"] = FurphyBuffData["PETS"] or {
    [46584] = { name = "Raise Dead", spellID = 46584, topLbl = "", btmLbl = "", gates = { "evenRested", "no_pet", "not_mounted"  } },
  }
end

-- =========================
-- Warlock
-- =========================
if playerClassID == 9 then
  FurphyBuffData["PETS"] = FurphyBuffData["PETS"] or {
  [688] = { name = "Summon Imp", spellID = 688, topLbl = "", btmLbl = "", gates = { "wl_no_sacrifice", "no_pet", "not_mounted", "evenRested" } },
	[697] = { name = "Summon Voidwalker", spellID = 697, topLbl = "", btmLbl = "", gates = { "wl_no_sacrifice", "no_pet", "not_mounted", "evenRested" } },
	[691] = { name = "Summon Felhunter", spellID = 691, topLbl = "", btmLbl = "", gates = { "wl_no_sacrifice", "no_pet", "not_mounted", "evenRested" } },
	[366222] = { name = "Summon Sayaad", spellID = 366222, topLbl = "", btmLbl = "", gates = { "wl_no_sacrifice", "no_pet", "not_mounted", "evenRested" } },
	[30146] = { name = "Summon Felguard", spellID = 30146, topLbl = "", btmLbl = "", gates = { "wl_no_sacrifice", "no_pet", "not_mounted", "evenRested" } },
  }
end






