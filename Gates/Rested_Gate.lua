-- ====================================
-- \Gates\Rested_Gate.lua
-- ====================================

local addonName, ns = ...

function ns.Gate_Rested(restedFlag)
  if restedFlag == nil then
    restedFlag = IsResting and IsResting() or false
  end
  return not restedFlag
end

ns.RegisterGate("rested", function(ctx)
  return ns.Gate_Rested(ctx.rested)
end)
