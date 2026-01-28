-- ====================================
-- \Gates\Death_Gate.lua
-- ====================================

local addonName, ns = ...

function ns.Gate_Alive()
  return not UnitIsDeadOrGhost("player")
end

ns.RegisterGate("alive", function()
  return ns.Gate_Alive()
end)
