-- ====================================
-- \Data\Trinkets_Table.lua
-- ====================================

ClickableRaidData  = ClickableRaidData  or {}

local TRINKETS = {
  [190958] = { name="So'Leah's Secret Technique", itemID=190958, buffID={368512}, targetBuffID=386510, check="player", target="", topLbl=INVTYPE_TRINKET, btmLbl=STATUS_TEXT_TARGET, count=1, type="trinket", gates={"group","rested"}, mineOnly=true },
  [178742] = { name="Bottled Flayedwing Toxin",   itemID=178742, buffID={345546}, check="player", target="player", topLbl=INVTYPE_TRINKET, btmLbl="", mineOnly=true, type="trinket", gates={"group","rested"} },
}

ClickableRaidData.TRINKETS = ClickableRaidData.TRINKETS or {}
for id, e in pairs(TRINKETS) do
  ClickableRaidData.TRINKETS[id] = e
end

ClickableRaidData.ALL_TRINKETS = ClickableRaidData.ALL_TRINKETS or {}
for id, e in pairs(TRINKETS) do
  ClickableRaidData.ALL_TRINKETS[id] = e
end

if ns and ns.Trinkets_RebuildWatch then ns.Trinkets_RebuildWatch() end

