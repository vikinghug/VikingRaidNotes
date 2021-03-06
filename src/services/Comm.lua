local VSL = LibStub("VikingSharedLib")
local AceComm = LibStub("AceComm-3.0")
local AceSerializer = LibStub("AceSerializer-3.0")

local addonName = ...

local addon = _G[addonName]

addon:Service("VRNUI.CommService", {
  "VRNUI.SettingsService",
  "VRNUI.PlayersService",
  function(SettingsService, PlayersService)
    return {
      Register = function(self)
        AceComm:RegisterComm("VRN_NOTES_SET", function(event, ...) self:NOTES_SET(...) end)
        AceComm:RegisterComm("VRN_NOTES_PUSH", function(event, ...) self:NOTES_PUSH(...) end)
        AceComm:RegisterComm("VRN_VERSION_PULL", function(event, ...) self:VERSION_PULL(...) end)
        AceComm:RegisterComm("VRN_VERSION_PUSH", function(event, ...) self:VERSION_PUSH(...) end)
      end,

      NOTES_PUSH = function(self, text, channel, sender)
        local success, data = AceSerializer:Deserialize(text)
        if (success) then
          addon.Services.SettingsService:UpsertNotes(data)
        end
      end,

      NOTES_SET = function(self, text, channel, sender)
        local success, data = AceSerializer:Deserialize(text)
        if (success) then
          addon.Frame:SetNotes(data, data.buttonID)
        end
      end,

      VERSION_PULL = function(self, text, channel, sender)
        self:SendVersionTo(sender)
      end,

      VERSION_PUSH = function(self, text, channel, sender, ...)
        PlayersService:SetPlayerVersion(sender, text)
      end,

      SetPlayerNotes = function(self, buttonID)
        local notes = SettingsService:GetNotesForButton(buttonID)
        local button = SettingsService:GetButton(buttonID)
        local set = SettingsService:GetSet(button.setID)
        local channels = SettingsService:GetChannels()

        local data = {
          buttonID = buttonID,
          sets = { set },
          bosses = { button },
          channels = channels,
          notes = notes
        }
        addon.Frame:SetNotes(data, data.buttonID)
        AceComm:SendCommMessage("VRN_NOTES_SET", AceSerializer:Serialize(data), "RAID", nil, "ALERT")
      end,

      PushNote = function(self, noteID)
        local data = AceSerializer:Serialize({SettingsService:GetNote(noteID)})
        AceComm:SendCommMessage("VRN_NOTES_PUSH", data, "RAID", nil, "ALERT")
      end,

      PushNotesForButton = function(self, buttonID)
        local data = AceSerializer:Serialize(SettingsService:GetNotesForButton(buttonID))
        AceComm:SendCommMessage("VRN_NOTES_PUSH", data, "RAID", nil, "ALERT")
      end,

      CheckVersions = function(self, players, callback)
        for k, v in pairs(players) do
          if (UnitIsConnected(k)) then
            AceComm:SendCommMessage("VRN_VERSION_PULL", addon.Version, "WHISPER", k, nil, function()
              if (callback) then
                callback(k, true)
              end
            end)
          else
            callback(k, false)
          end
        end
      end,

      BroadCastVersion = function(self)
        AceComm:SendCommMessage("VRN_VERSION_PUSH", addon.Version, "RAID")
      end,

      GetVersionFrom = function(self, player)
        AceComm:SendCommMessage("VRN_VERSION_PULL", addon.Version, "WHISPER", player)
      end,

      SendVersionTo = function(self, player)
        AceComm:SendCommMessage("VRN_VERSION_PUSH", addon.Version, "WHISPER", player)
      end,
    }
  end
})