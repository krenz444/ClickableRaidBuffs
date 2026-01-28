-- ====================================
-- \Core\GateCheck.lua
-- ====================================

local addonName, ns = ...

ns._GateHandlers = ns._GateHandlers or {}

function ns.RegisterGate(name, fn)
  if type(name) ~= "string" or type(fn) ~= "function" then return false end
  ns._GateHandlers[name] = fn
  return true
end

function ns.PassesGates(data, playerLevel, inInstance, rested)
  if not data then return true end

  local g = data.gates
  local hasEvenRested, hasEvenDead = false, false
  if g and #g > 0 then
    for i = 1, #g do
      local name = g[i]
      if name == "evenRested" then hasEvenRested = true
      elseif name == "evenDead" then hasEvenDead = true
      end
    end
  end

  local isDead = UnitIsDeadOrGhost and UnitIsDeadOrGhost("player") or false
  if isDead and not hasEvenDead then
    return false
  end
  if rested == nil then
    rested = IsResting and IsResting() or false
  end
  if rested and not hasEvenRested then
    return false
  end

  if data.minLevel and not (ns.Gate_Level and ns.Gate_Level(data.minLevel, playerLevel)) then
    return false
  end

  if not g or #g == 0 then
    return true
  end

  local ctx = { playerLevel = playerLevel, inInstance = inInstance, rested = rested }
  for i = 1, #g do
    local name = g[i]

    if name ~= "evenRested" and name ~= "evenDead" then
      if (name == "rested" and hasEvenRested) or (name == "alive" and hasEvenDead) then
      else
        local fn = ns._GateHandlers and ns._GateHandlers[name]
        if fn and not fn(ctx, data) then
          return false
        end
      end
    end
  end

  return true
end