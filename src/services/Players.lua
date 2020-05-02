local VSL = LibStub("VikingSharedLib")
local addonName = ...

local addon = _G[addonName]

addon:Service("VRNUI.PlayersService", function()
  return {
    UpdatePlayersFromRaid = function()
      for i=1,40 do
        local name, rank, subgroup, level, class, fileName, zone, online, isDead, role, isML, combatRole = GetRaidRosterInfo(i)

        if (name) then
          addon.db.profile.players[name] = {
            class = class,
            textColor = addon.db.profile.classColors[class]
          }
        end
      end
    end,

    UpdatePlayersFromGuild = function()
      local max = GetNumGuildMembers()
      for i = 1, max do
        local nameAndServer, rankName, rankIndex, level, classDisplayName, zone, publicNote, officerNote, isOnline, status, class, achievementPoints, achievementRank, isMobile, canSoR, repStanding, GUID = GetGuildRosterInfo(i)
        local name = nameAndServer:gsub("(%w+)-%w+", "%1")

        addon.db.profile.players[name] = {
          class = classDisplayName,
          textColor = addon.db.profile.classColors[classDisplayName]
        }
      end
    end
  }
end)