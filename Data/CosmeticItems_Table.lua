-- ====================================
-- \Data\CosmeticItems_Table.lua
-- ====================================

_G.FurphyBuffData = _G.FurphyBuffData or {}
local FurphyBuffData = _G.FurphyBuffData

FurphyBuffData["COSMETIC"] = {
  [8529]    = { name = "Noggenfogger Elixer",      itemID = 8529,   buffID = { 16591 }, },
  [124640]  = { name = "Inky Black Potion",        itemID = 124640, buffID = { 185394 }, gates = { "notMap", { notMap = 2215 }, }, }, 
  [204370]  = { name = "Stinky Bright Potion",     itemID = 204370, buffID = { 404840 }, gates = { "notMap", { notMap = 2215 }, }, }, 
  [197767]  = { name = "Blubbery Muffin",          itemID = 197767, buffID = { 382761 }, },
  [2460]    = { name = "Elixer of Tongues",        itemID = 2460,   buffID = { 382761 }, },
  [6657]    = { name = "Savory Deviate Delight",   itemID = 6657,   buffID = { 8219, 8220, 8221, 8222, 174864, 174865, 174867, 174868 }, },
}
