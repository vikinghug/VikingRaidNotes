local VSL = LibStub("VikingSharedLib")
local addonName = ...

_G[addonName] = LibStub("AceAddon-3.0"):NewAddon(addonName, "LibMVC-1.0")

local addon = _G[addonName]
addon.Version = GetAddOnMetadata("VikingRaidNotes", "Version")
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

  LibStub("LibDBIcon-1.0"):Register("VikingRaidNotes", {
    type = "data source",
    text = "Viking Raid Notes",
    icon = "Interface\\Addons\\VikingSharedLib\\assets\\textures\\viking-head-32.tga",
    OnClick = function()
      addon.db.profile.notesWindow.hide = not addon.db.profile.notesWindow.hide
      if addon.db.profile.notesWindow.hide then
        addon.Frame:Hide()
      else
        addon.Frame:Show()
      end
    end,
    OnTooltipShow = function(tooltip)
      tooltip:AddDoubleLine(format("%s", "VikingRaidNotes"), format("|cff777777v%s", addon.Version));
      tooltip:AddLine("|cFFCFCFCFLeft Click: |rHide/Show GUI");
    end
  }, self.db.profile.minimap)
end
