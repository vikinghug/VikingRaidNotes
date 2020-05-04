local VSL = LibStub("VikingSharedLib")
local addonName = ...

_G[addonName] = LibStub("AceAddon-3.0"):NewAddon(addonName, "LibMVC-1.0")

local addon = _G[addonName]
addon.Version = "0.0.2"
VRN = addon

local Services = {}; addon.Services = Services;

function addon:OnInitialize()
  addon:Controller("VRNUI.ServicesController", {
    "VRNUI.SettingsService",
    "VRNUI.CommService",
    "VRNUI.PlayersService",
    function(SettingsService, CommService, PlayersService)
      return {
        OnBind = function(frame)
          frame.SettingsService = SettingsService
          frame.CommService = CommService
          frame.PlayersService = PlayersService

          CommService:Register()
        end
      }
    end
  })
  addon:BindViewToController(Services, "VRNUI.ServicesController")

  self.Settings:OnLoad()
  self.Options:OnLoad()

  self.Frame = CreateFrame("Frame", "VikingRaidNotesFrame", UIParent, "VRNNotesWindowTemplate")

  self.Events = CreateFrame("Frame", "VRNEvents", UIParent)
  addon:BindViewToController(self.Events, "VRNUI.Events")

  -- self.Sets = CreateFrame("Frame", "VRNSetsList", UIParent, "VRNSetsListTemplate")
end