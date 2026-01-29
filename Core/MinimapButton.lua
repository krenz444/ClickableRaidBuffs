-- ====================================
-- \Core\MinimapButton.lua
-- ====================================
-- This file handles the creation and management of the minimap button using LibDataBroker and LibDBIcon.

local addonName, ns = ...

local FurphyBuffButtons = LibStub("AceAddon-3.0"):NewAddon("FurphyBuffButtons", "AceConsole-3.0")

-- Libs
local LDB = LibStub("LibDataBroker-1.1")
local LDI = LibStub("LibDBIcon-1.0", true)
local AceDB = LibStub("AceDB-3.0")

-- Create the data object for the minimap button
local miniButton = LDB:NewDataObject("FurphyBuffButtons", {
    type = "data source",
    text = "FBB",
    icon = "Interface\\AddOns\\FurphyBuffButtons\\Media\\furphyMinimapIcon",

    OnClick = function(_, btn)
        if InCombatLockdown() then
            print("|cFF00ccffFBB:|r Minimap menu is disabled during combat.")
            return
        end

        if btn == "LeftButton" then
            if ns and ns.OptionsFrame and ns.OptionsFrame:IsShown() then
                ns.OptionsFrame:Hide()
            elseif ns and ns.OpenOptions then
                ns.OpenOptions()
            elseif SlashCmdList and SlashCmdList["FURPHYBUFFBUTTONS"] then
                SlashCmdList["FURPHYBUFFBUTTONS"]("")
            end

        elseif btn == "RightButton" then
            if ns and ns._mover and ns._mover:IsShown() then
                if ns.ToggleMover then ns.ToggleMover(false) end
            else
                if ns.ToggleMover then ns.ToggleMover(true) end
            end
        end
    end,

    OnTooltipShow = function(tooltip)
        if not tooltip or not tooltip.AddLine then return end
        tooltip:AddLine("|cff00ccffFurphy Buff Buttons|r")
        tooltip:AddLine(" ")
        tooltip:AddLine("Left-click: Open Settings")
        tooltip:AddLine("Right-click: Toggle Icon Frame Lock")
    end,
})

-- Refreshes the minimap icon state (show/hide) based on settings
function FurphyBuffButtons:RefreshMinimapIcon()
    if not (LDI and self.minimapDB and self.minimapDB.profile) then return end
    local prof = self.minimapDB.profile
    prof.minimap = prof.minimap or { hide = false, minimapPos = 180 }

    LDI:Register("FurphyBuffButtons", miniButton, prof.minimap)

    if prof.minimap.hide then
        LDI:Hide("FurphyBuffButtons")
    else
        LDI:Show("FurphyBuffButtons")
    end

    if ns and ns.InfoTab_UpdateMinimapCheckbox then
        ns.InfoTab_UpdateMinimapCheckbox(prof.minimap.hide)
    end
end

-- Initializes the minimap button and database
function FurphyBuffButtons:OnInitialize()
    self.minimapDB = AceDB:New("FurphyBuffButtonsMinimapDB", {
        profile = {
            minimap = {
                hide = false,
                minimapPos = 180,
            },
        },
    }, true)

    if self.minimapDB.keys and self.minimapDB.keys.profile ~= "Default" then
        self.minimapDB:SetProfile("Default")
    end

    local legacy = nil
    local sv = _G.FurphyBuffButtonsDB
    if type(sv) == "table" and type(sv.profile) == "table" and type(sv.profile.minimap) == "table" then
        legacy = sv.profile.minimap
    end
    if legacy then
        local dst = self.minimapDB.profile.minimap
        if dst.hide == nil       and legacy.hide       ~= nil then dst.hide       = legacy.hide       end
        if dst.minimapPos == nil and legacy.minimapPos ~= nil then dst.minimapPos = legacy.minimapPos end
        if dst.lock == nil       and legacy.lock       ~= nil then dst.lock       = legacy.lock       end
    end

    self:RefreshMinimapIcon()

    self.minimapDB.RegisterCallback(self, "OnProfileChanged", "OnMinimapProfileChanged")
    self.minimapDB.RegisterCallback(self, "OnProfileCopied",  "OnMinimapProfileChanged")
    self.minimapDB.RegisterCallback(self, "OnProfileReset",   "OnMinimapProfileChanged")
end

function FurphyBuffButtons:OnMinimapProfileChanged()
    self:RefreshMinimapIcon()
end

-- Toggles the visibility of the minimap button
function FurphyBuffButtons:ToggleMinimapButton(state)
    if not (LDI and self.minimapDB and self.minimapDB.profile) then return end

    local prof = self.minimapDB.profile
    if state == nil then
        state = not (prof.minimap and prof.minimap.hide)
    end

    prof.minimap = prof.minimap or {}
    prof.minimap.hide = state and true or false

    if prof.minimap.hide then
        LDI:Hide("FurphyBuffButtons")
    else
        LDI:Show("FurphyBuffButtons")
    end

    if ns and ns.InfoTab_UpdateMinimapCheckbox then
        ns.InfoTab_UpdateMinimapCheckbox(prof.minimap.hide)
    end
end

-- Public API to toggle the minimap button
function ns.ToggleMinimapButton(state)
    if FurphyBuffButtons and FurphyBuffButtons.ToggleMinimapButton then
        FurphyBuffButtons:ToggleMinimapButton(state)
    end
end
function ns.Minimap_Show()
    if FurphyBuffButtons then FurphyBuffButtons:ToggleMinimapButton(false) end
end
function ns.Minimap_Hide()
    if FurphyBuffButtons then FurphyBuffButtons:ToggleMinimapButton(true) end
end
function ns.Minimap_Toggle()
    if not (FurphyBuffButtons and FurphyBuffButtons.minimapDB and FurphyBuffButtons.minimapDB.profile) then return end
    local hide = (FurphyBuffButtons.minimapDB.profile.minimap and FurphyBuffButtons.minimapDB.profile.minimap.hide) and true or false
    FurphyBuffButtons:ToggleMinimapButton(not hide)
end
