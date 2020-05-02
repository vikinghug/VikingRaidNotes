local VSL = LibStub("VikingSharedLib")
local AceComm = LibStub("AceComm-3.0")
local AceSerializer = LibStub("AceSerializer-3.0")

local addonName = ...

local addon = _G[addonName]

addon.RegisterComms = function()
  -- AceComm:RegisterComm(, )
end

addon:Service("VRNUI.CommService", {
  "VRNUI.SettingsService",
  function(SettingsService)
    return {
      SendNote = function(id)
      end,

      PushNotesForButton = function(self, buttonID)
        local data = AceSerializer:Serialize(SettingsService.GetNotesForButton(buttonID))
        AceComm:SendCommMessage("VRN_NOTES_PUSH", data, "RAID")
      end
    }
  end
})