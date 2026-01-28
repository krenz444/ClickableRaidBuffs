-- ====================================
-- \Gates\NoPet_Gate.lua
-- ====================================

local addonName, ns = ...

local function HasUsablePet()
  if not UnitExists("pet") then return false end
  if UnitIsDeadOrGhost and UnitIsDeadOrGhost("pet") then return false end
  if not UnitIsVisible("pet") then return false end
  return true
end

function ns.Gate_NoPet()
  return not HasUsablePet()
end

function ns.Gate_HasPet()
  return HasUsablePet()
end

ns.RegisterGate("no_pet", function()
  return ns.Gate_NoPet()
end)

ns.RegisterGate("has_pet", function()
  return ns.Gate_HasPet()
end)
