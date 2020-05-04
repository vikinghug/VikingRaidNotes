local VSL = LibStub("VikingSharedLib")

local addonName = ...

local addon = _G[addonName]

addon.PERMISSIONS = {
  NOTES_SYNC = 1,
  NOTES_SHOW = 2,
}

local ACCESS = {
  ["Diminisher"] = {1,2},
  ["Keladry"] = {1,2},
  ["Lunalea"] = {1,2},
  ["Lunalily"] = {1,2},
  ["Nealas"] = {1,2},
  ["Ridlee"] = {1,2},
  ["Shisei"] = {1,2},
  ["Thorikson"] = {1,2},
  ["Thugyoung"] = {1,2},
  ["Vikingbank"] = {1,2},
  ["Vikinghug"] = {1,2},
  ["Vitiatix"] = {1,2},
  ["Xendragon"] = {1,2},
}

addon:Service("VRNUI.AuthService", {
  "VRNUI.SettingsService",
  "VRNUI.PlayersService",
  function(SettingsService, PlayersService)
    return {
      IsAuthorized = function (self, player, ...)
        if (not ACCESS[player]) then return false end

        local result = true
        for i,v in ipairs({...}) do
          result = (result and tContains(ACCESS[player], v))
        end
        VSL:Debug(player, result)
        return result
      end
    }
  end
})