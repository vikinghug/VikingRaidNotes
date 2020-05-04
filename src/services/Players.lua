local VSL = LibStub("VikingSharedLib")
local addonName = ...

local addon = _G[addonName]

addon:Service("VRNUI.PlayersService", function()
  return {
    GetPlayers = function()
      return addon.db.profile.players
    end,

    UpdatePlayersFromRaid = function(self)
      for i=1,40 do
        local name, rank, subgroup, level, class, fileName, zone, online, isDead, role, isML, combatRole = GetRaidRosterInfo(i)

        if (name) then
          self:AddPlayer(name, class)
        end
      end
    end,

    UpdatePlayersFromGuild = function(self)
      local max = GetNumGuildMembers()
      for i = 1, max do
        local nameAndServer, rankName, rankIndex, level, classDisplayName, zone, publicNote, officerNote, isOnline, status, class, achievementPoints, achievementRank, isMobile, canSoR, repStanding, GUID = GetGuildRosterInfo(i)
        local name = nameAndServer:gsub("(%w+)-%w+", "%1")

        self:AddPlayer(name, classDisplayName)
      end
    end,

    GetVersionText = function(self, name)
      if (addon.db.profile.players[name] and addon.db.profile.players[name].version) then
        return addon.db.profile.players[name].version
      else
        return "N/A"
      end
    end,

    GetVersionTextColor = function(self, name)
      if (addon.db.profile.players[name] and addon.db.profile.players[name].version) then
        local version = addon.db.profile.players[name].version

        if (addon.Version == version) then
          return VSL.Colors.GREEN:ToText()
        elseif addon.Version > version then
          return VSL.Colors.YELLOW:ToText()
        else
          return VSL.Colors.RED:ToText()
        end

      else
        return VSL.Colors.RED:ToText()
      end
    end,

    SetPlayerVersion = function(self, name, version)
      for k, v in pairs(addon.db.profile.players) do
        if k == name then
          v.version = version
        end
      end
    end,

    AddPlayer = function(self, name, class, version)
      -- TODO: This should be a list for easier filtering/sorting
      addon.db.profile.players[name] = {
        name = name,
        class = class,
        textColor = addon.db.profile.classColors[class],
        version = version or self:GetVersionText(name)
      }

      return addon.db.profile.players[name]
    end,

    GetRaidPlayers = function(self)
      local players = {}

      for i=1,40 do
        local name, rank, subgroup, level, class, fileName, zone, online, isDead, role, isML, combatRole = GetRaidRosterInfo(i)

        if (name) then
          if addon.db.profile.players[name] then
            table.insert(players, addon.db.profile.players[name])
          else
            local name = self:AddPlayer(name, class, "N/A")
            table.insert(players, name)
          end
        end
      end

      return players
    end,

    GetPlayersList = function(self)
      local players = {}
      for k, v in pairs(addon.db.profile.players) do
        table.insert(players, {
          name = v.name,
          class = v.class,
          textColor = v.textColor,
          version = v.version or self:GetVersionText(k)
        })
      end
      return players
    end,
  }
end)