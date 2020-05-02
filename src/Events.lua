local VSL = LibStub("VikingSharedLib")
local addonName = ...

local addon = _G[addonName]

addon:Controller("VRNUI.Events", { "VRNUI.PlayersService", "VRNUI.SetsService", function(PlayersService, SetsService)
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
      VSL:Debug("PLAYER_ENTERING_WORLD")
      addon.Options:OnLoad(SetsService)
      PlayersService.UpdatePlayersFromGuild()
    end,

    GROUP_ROSTER_UPDATE = function(frame)
      VSL:Debug("GROUP_ROSTER_UPDATE")
      PlayersService.UpdatePlayersFromRaid()
    end,

    GUILD_ROSTER_UPDATE = function(frame)
      VSL:Debug("GUILD_ROSTER_UPDATE")
      PlayersService.UpdatePlayersFromGuild()
    end,

    -- CHAT_MSG_ADDON = function(frame, prefix, text, channel, sender, target, zoneChannelID, localID, name, instanceID)
    --   if (prefix == "VRN_NOTES_PUSH") then
    --     VSL:Debug("CHAT_MSG_ADDON", {prefix, text, channel, sender, target, zoneChannelID, localID, name, instanceID})
    --     local type, noteID, setID, buttonID, value = text:match("(%w+):(%d+):(%d+):(%d+):(.+)")

    --     print(type, noteID, setID, buttonID, value)
    --   end
    --   -- PlayersService.UpdatePlayersFromGuild()
    -- end,
  }
end})
