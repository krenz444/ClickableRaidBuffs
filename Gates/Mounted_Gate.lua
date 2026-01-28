-- ====================================
-- \Gates\Mounted_Gate.lua
-- ====================================

local addonName, ns = ...

function ns.Gate_NotMounted()
  return not (IsMounted and IsMounted())
end

ns.RegisterGate("not_mounted", function()
  return ns.Gate_NotMounted()
end)
