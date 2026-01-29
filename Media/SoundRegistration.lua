-- ====================================
-- \Media\SoundRegistration.lua
-- ====================================

local LSM = LibStub and LibStub("LibSharedMedia-3.0", true)
if not LSM then return end

local BASE = "Interface\\AddOns\\FurphyBuffButtons\\Media\\Sounds\\"
local DIR_SFX = BASE .. "SFX for gamesapps\\"
local DIR_SWEET = BASE .. "SweetAlerts\\"
local EXT = ".ogg"
local PREFIX = "Alerts: |cffff7d0Ffunki.gg|r "

local function regList(dir, entries)
  for _, e in ipairs(entries) do
    LSM:Register("sound", PREFIX .. e[2], dir .. e[1] .. EXT)
  end
end

regList(DIR_SFX, {
  {"320654__rhodesmas__level-up-02",      "Chime"},
  {"320655__rhodesmas__level-up-01",      "Working On It"},
  {"320657__rhodesmas__level-up-03",      "Victory"},
  {"320672__rhodesmas__win-01",           "Broadway"},
  {"320775__rhodesmas__win-02",           "Angelic"},
  {"320776__rhodesmas__action-02",        "Glimmer"},
  {"320777__rhodesmas__action-01",        "Shimmer"},
  {"320887__rhodesmas__win-04",           "Success"},
  {"321262__rhodesmas__coins-purchase-02","Pot of Gold"},
  {"321263__rhodesmas__coins-purchase-01","Treasure"},
  {"322894__rhodesmas__disconnected-02",  "Bad Coms"},
  {"322895__rhodesmas__disconnected-01",  "Disconnected"},
  {"322896__rhodesmas__connected-02",     "Good Coms"},
  {"322897__rhodesmas__connected-01",     "Connected"},
  {"320883__rhodesmas__action-03",        "Notice"},
  {"322929__rhodesmas__success-04",       "Shimmer"},
  {"322930__rhodesmas__success-03",       "Winning"},
  {"322931__rhodesmas__incorrect-01",     "Losing"},
  {"342749__rhodesmas__notification-01",  "Tip Tap"},
  {"342750__rhodesmas__coins-purchase-4", "Synth Wave"},
  {"342751__rhodesmas__coins-purchase-3", "Light Strum"},
  {"342755__rhodesmas__notification-02",  "Notice"},
  {"342757__rhodesmas__searching-03",     "Chill Sonar"},
  {"380264__rhodesmas__alert-03",         "Ding Wave"},
  {"380265__rhodesmas__alert-02",         "Blaster"},
  {"380266__rhodesmas__alert-01",         "Jingle"},
  {"380277__rhodesmas__alert-04",         "Jingle Down"},
})

regList(DIR_SWEET, {
  {"72125__kizilsungur__sweetalertsound1", "Ding Dong"},
  {"72126__kizilsungur__sweetalertsound2", "Attention"},
  {"72127__kizilsungur__sweetalertsound3", "Ping"},
  {"72128__kizilsungur__sweetalertsound4", "Synth"},
  {"72129__kizilsungur__sweetalertsound5", "Marimba"},
})


regList(BASE, {
  {"JewelcraftingFinalize", "Clank"},
})