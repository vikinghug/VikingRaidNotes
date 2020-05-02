local VSL = LibStub("VikingSharedLib")
local addonName = ...

_G[addonName] = LibStub("AceAddon-3.0"):NewAddon(addonName, "LibMVC-1.0")

local addon = _G[addonName]
addon.Version = "0.0.1"
VRN = addon

function addon:OnInitialize()
  self.Settings:OnLoad()
  -- self.Options:OnLoad()

  self.Frame = CreateFrame("Frame", "VikingRaidNotesFrame", UIParent, "VRNNotesWindowTemplate")

  self.Events = CreateFrame("Frame", "VRNEvents", UIParent)
  addon:BindViewToController(self.Events, "VRNUI.Events")

  self.Sets = CreateFrame("Frame", "VRNSetsList", UIParent, "VRNSetsListTemplate")
end