local VSL = LibStub("VikingSharedLib")
local addonName = ...

local addon = _G[addonName]

addon:Controller("VRNUI.Events", { "VRNUI.PlayersService", "VRNUI.SettingsService", function(PlayersService, SettingsService)
  return {
    OnBind = function(frame)
      -- C_ChatInfo.RegisterAddonMessagePrefix("VRN_NOTES_SET")
      -- C_ChatInfo.RegisterAddonMessagePrefix("VRN_NOTES_PUSH")
      PlayersService.UpdatePlayersFromGuild()
      PlayersService.UpdatePlayersFromRaid()
      frame:RegisterEvents()
    end,

    RegisterEvents = function(frame)
      frame:RegisterEvent("GROUP_ROSTER_UPDATE")
      frame:RegisterEvent("GUILD_ROSTER_UPDATE")
      frame:RegisterEvent("PLAYER_ENTERING_WORLD")
      -- frame:RegisterEvent("CHAT_MSG_ADDON")

      frame:SetScript("OnEvent", function(this, event, ...)
        frame[event](this, ...)
      end)
    end,

    PLAYER_ENTERING_WORLD = function(frame)
      PlayersService.UpdatePlayersFromGuild()
    end,

    GROUP_ROSTER_UPDATE = function(frame)
      PlayersService.UpdatePlayersFromRaid()
    end,

    GUILD_ROSTER_UPDATE = function(frame)
      PlayersService.UpdatePlayersFromGuild()
    end,
  }
end})
