local VSL = LibStub("VikingSharedLib")
local addonName = ...

_G[addonName] = LibStub("AceAddon-3.0"):NewAddon(addonName, "LibMVC-1.0")

local addon = _G[addonName]
addon.Version = "0.0.1"
VRN = addon

function addon:OnInitialize()
  self.Settings:OnLoad()
  -- self.Options:OnLoad()

  addon:BindViewToController(addon.Events, "VRNUI.Events")

  self.Frame = CreateFrame("Frame", "VikingRaidNotesFrame", UIParent, "VRNNotesWindowTemplate")
  self.Sets = CreateFrame("Frame", "VRNSetsList", UIParent, "VRNSetsListTemplate")
end