-- ====================================
-- \Gates\Instance_Gate.lua
-- ====================================

local addonName, ns = ...

function ns.Gate_Instance(inInstance)
  if inInstance == nil then
    inInstance = select(1, IsInInstance())
  end
  return inInstance and true or false
end

ns.RegisterGate("instance", function(ctx)
  return ns.Gate_Instance(ctx.inInstance)
end)
