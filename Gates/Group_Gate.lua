-- ====================================
-- \Gates\Group_Gate.lua
-- ====================================

local addonName, ns = ...

function ns.PassesGroupGate()
  return (IsInGroup() or IsInRaid()) and true or false
end

ns.RegisterGate("group", function()
  return ns.PassesGroupGate()
end)
