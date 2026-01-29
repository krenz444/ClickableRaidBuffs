-- ====================================
-- \UI\Render.lua
-- ====================================
-- This file handles the main rendering logic for the addon's icons.

local addonName, ns = ...
local parent, overlay, hover = ns.RenderParent, ns.Overlay, ns.Hover
local Glow = LibStub("LibCustomGlow-1.0")

NS = ns
ns.RenderFrames = ns.RenderFrames or {}
ns.RenderIndexByKey = ns.RenderIndexByKey or {}

_G.furphyBuffCache = _G.furphyBuffCache or {}
local C = _G.furphyBuffCache

-- Configuration for rank overlays (e.g., quality tiers).
C.rankOverlayKnobs = C.rankOverlayKnobs or {
  spec   = { scale = 0.52, x = 5,  y = -5, alpha = 1 },
  rank1  = { scale = 0.52, xMul = 0.05, yMul = -0.08, alpha = 1 },
  rank2  = { scale = 0.52, xMul = 0.16, yMul = -0.09, alpha = 1 },
  rank3  = { scale = 0.52, xMul = 0.16, yMul = -0.16, alpha = 1 },
  hearty = { scale = 0.52, xMul = 0.13, yMul = -0.20, alpha = 1 },
  fleeting = { scale = 0.42, xMul = 0.1, yMul = -0.0, alpha = 0.8 },
}

-- Generates a unique key for an entry.
local function entryKey(cat, entry)
  if cat == "MAIN_HAND" then
    return "MH:" .. tostring(entry.itemID or entry.name or "")
  elseif cat == "OFF_HAND" then
    return "OH:" .. tostring(entry.itemID or entry.name or "")
  end

  if entry.isFixed and entry.spellID then
    local suf = ""
    local b1  = (type(entry.buffID) == "table") and entry.buffID[1] or entry.buffID
    if b1 then suf = ":b" .. tostring(b1) end
    return cat .. ":spell:" .. tostring(entry.spellID) .. ":fixed" .. suf
  end

  if entry.itemID then
    return cat .. ":item:" .. tostring(entry.itemID)
  end

  if entry.spellID then
    local suf = ""
    local b1  = (type(entry.buffID) == "table") and entry.buffID[1] or entry.buffID
    if b1 then suf = ":b" .. tostring(b1) end
    return cat .. ":spell:" .. tostring(entry.spellID) .. suf
  end

  return cat .. ":name:" .. tostring(entry.name or "")
end

-- Checks if two RGBA colors are the same.
local function sameRGBA(a, b)
  if not a or not b then return false end
  return a[1]==b[1] and a[2]==b[2] and a[3]==b[3] and (a[4] or 1)==(b[4] or 1)
end

-- Enables or disables the glow effect on a button.
local function ensureGlow(btn, shouldEnable, color, size)
  if not shouldEnable then
    if btn._fbb_glow_enabled then
      Glow.PixelGlow_Stop(btn)
      btn._fbb_glow_enabled = false
      btn._fbb_glow_rgba = nil
      btn._fbb_glow_size = nil
    end
    return
  end
  local rgba = { color.r, color.g, color.b, color.a or 1 }
  local N = 8
  local frequency = 0.25
  local length = (10 / 50) * size
  local th     = ( 1.6 / 50) * size

  if btn._fbb_glow_enabled then
    if not sameRGBA(btn._fbb_glow_rgba, rgba) or btn._fbb_glow_size ~= size then
      Glow.PixelGlow_Stop(btn)
      btn._fbb_glow_enabled = false
    end
  end
  if not btn._fbb_glow_enabled then
    Glow.PixelGlow_Start(btn, rgba, N, frequency, length, th, 0, 0, true)
    btn._fbb_glow_enabled = true
    btn._fbb_glow_rgba = rgba
    btn._fbb_glow_size = size
  end
end

-- Sets the icon texture if it has changed.
local function setIconTextureIfChanged(btn, tex)
  if btn.icon._fbb_tex ~= tex then
    btn.icon:SetTexture(tex or 134400)
    btn.icon._fbb_tex = tex
  end
end

-- Sets the button action (spell or item) if it has changed.
local function setButtonActionIfChanged(btn, kind, id)
  if btn._fbb_kind ~= kind or btn._fbb_id ~= id then
    btn:SetAttribute("type", kind)
    if kind == "spell" then
      btn:SetAttribute("spell", id)
      btn:SetAttribute("item", nil)
    elseif kind == "item" then
      btn:SetAttribute("item", "item:" .. id)
      btn:SetAttribute("spell", nil)
    else
      btn:SetAttribute("type", nil)
      btn:SetAttribute("spell", nil)
      btn:SetAttribute("item", nil)
    end
    btn._fbb_kind = kind
    btn._fbb_id = id
  end
end

-- Creates a new button frame.
local function createButton(index)
  local name = "FurphyBuffButton" .. index
  local btn = CreateFrame("Button", name, parent, "SecureActionButtonTemplate")
  btn:SetSize(30, 30)
  btn:SetFrameStrata("MEDIUM")
  btn:SetFrameLevel(10)

  local icon = btn:CreateTexture(nil, "BACKGROUND")
  icon:SetAllPoints()
  icon:SetTexCoord(0.08, 0.92, 0.08, 0.92)
  btn.icon = icon

  local cd = CreateFrame("Cooldown", name .. "Cooldown", btn, "CooldownFrameTemplate")
  cd:SetAllPoints()
  btn.cooldown = cd

  local count = btn:CreateFontString(nil, "OVERLAY", "NumberFontNormal")
  count:SetPoint("BOTTOMRIGHT", -2, 2)
  btn.count = count

  local timerText = btn:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
  timerText:SetPoint("CENTER", 0, 0)
  btn.timerText = timerText

  btn:SetScript("OnEnter", function(self)
    if self._fbb_entry then
      GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
      if self._fbb_entry.spellID then
        GameTooltip:SetSpellByID(self._fbb_entry.spellID)
      elseif self._fbb_entry.itemID then
        GameTooltip:SetItemByID(self._fbb_entry.itemID)
      end
      GameTooltip:Show()
    end
  end)
  btn:SetScript("OnLeave", function()
    GameTooltip:Hide()
  end)

  return btn
end

-- Gets or creates a button for the given index.
local function getButton(index)
  if not ns.RenderFrames[index] then
    ns.RenderFrames[index] = createButton(index)
  end
  return ns.RenderFrames[index]
end

-- Helper to get the default font.
local function getDefaultFont()
  if ns.GetFontPath then
    return ns.GetFontPath("Friz Quadrata TT")
  end
  local fallback = GameFontNormal and select(1, GameFontNormal:GetFont())
  return fallback or "Fonts\\FRIZQT__.TTF"
end

-- Main render function.
-- Skipped during combat.
function ns.RenderAll()
  if ns._combat_suspended or ns.InCombatSuppressed then return end
  if InCombatLockdown() then return end

  local db = FurphyBuffButtonsDB
  if not db then return end

  local size = db.iconSize or 40
  local spacing = db.spacing or 5
  local cols = db.columns or 10
  local growDir = db.growDirection or "RIGHT"
  local align = db.alignment or "CENTER"

  local used = {}
  local index = 1

  -- Iterate through active buffs and render them.
  for _, entry in ipairs(ns.ActiveBuffs or {}) do
    local key = entryKey(entry.category, entry)
    local btn = ns.RenderIndexByKey[key]

    if not btn then
      btn = getButton(index)
      ns.RenderIndexByKey[key] = btn
      index = index + 1
    end

    used[key] = true
    btn._fbb_key = key
    btn._fbb_entry = entry

    btn:SetSize(size, size)
    setIconTextureIfChanged(btn, entry.icon)

    if entry.count and entry.count > 1 then
      btn.count:SetText(entry.count)
    else
      btn.count:SetText("")
    end

    if entry.duration and entry.duration > 0 then
      btn.timerText:Show()
    else
      btn.timerText:Hide()
    end

    -- Handle cooldowns
    if entry.start and entry.duration then
      btn.cooldown:SetCooldown(entry.start, entry.duration)
    else
      btn.cooldown:Hide()
    end

    -- Handle glow
    if entry.glow then
      ensureGlow(btn, true, entry.glowColor or {r=1, g=1, b=0, a=1}, size)
    else
      ensureGlow(btn, false)
    end

    -- Set click action
    if entry.spellID then
      setButtonActionIfChanged(btn, "spell", entry.spellID)
    elseif entry.itemID then
      setButtonActionIfChanged(btn, "item", entry.itemID)
    else
      setButtonActionIfChanged(btn, nil, nil)
    end

    if not btn:IsShown() then btn:Show() end
  end

  -- Hide unused buttons and cleanup glows
  for key, btn in pairs(ns.RenderIndexByKey) do
    if not used[key] and btn:IsShown() then
      if btn._fbb_glow_enabled and Glow then
        -- Check if the glow frame actually exists before stopping
        -- This prevents the "Attempted to release object that doesn't belong to this pool" error
        -- The error happens when LibCustomGlow tries to release a frame that was already released or doesn't exist
        local glowFrameName = "_PixelGlow"
        if btn[glowFrameName] then
             Glow.PixelGlow_Stop(btn)
        end
        btn._fbb_glow_enabled = false
        btn._fbb_glow_rgba = nil
      end
      if ns.ClearCooldownVisual then ns.ClearCooldownVisual(btn) end
      btn._fbb_key = nil
      btn._fbb_entry = nil
      if btn.timerText then btn.timerText:SetText(""); btn.timerText:Hide() end
      if btn.rankOverlay then btn.rankOverlay:Hide() end
      if btn.fleetingOverlay then btn.fleetingOverlay:Hide() end
      btn:Hide()
    end
  end

  -- Clean up the index map for unused keys
  for key in pairs(ns.RenderIndexByKey) do
      if not used[key] then
          ns.RenderIndexByKey[key] = nil
      end
  end

  -- Layout logic (simplified for brevity)
  local x, y = 0, 0
  local count = 0
  for _, entry in ipairs(ns.ActiveBuffs or {}) do
    local key = entryKey(entry.category, entry)
    local btn = ns.RenderIndexByKey[key]
    if btn then
      btn:ClearAllPoints()
      btn:SetPoint("TOPLEFT", parent, "TOPLEFT", x, y)

      count = count + 1
      if count % cols == 0 then
        x = 0
        y = y - (size + spacing)
      else
        x = x + (size + spacing)
      end
    end
  end
end
