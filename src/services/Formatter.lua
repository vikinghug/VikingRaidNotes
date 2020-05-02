local VSL = LibStub("VikingSharedLib")
local addonName = ...

local addon = _G[addonName]

local function subReplace(pattern)
  local p = pattern:gsub("(%%?)(.)", function(percent, letter)
    if percent ~= "" or not letter:match("%a") then
      return percent .. letter
    else
      return string.format("[%s%s]", letter:lower(), letter:upper())
    end
  end)
  return p
end

addon:Service("VRNUI.FormatterService", function()
  local pools = {}

  return {

    ParseText = function(str)
      local dict = {
        blue = VSL.Colors.BLUE:ToText(),
        green = VSL.Colors.GREEN:ToText(),
        red = VSL.Colors.RED:ToText(),
        yellow = VSL.Colors.YELLOW:ToText(),
        orange = VSL.Colors.ORANGE:ToText(),
        pink = VSL.Colors.PINK:ToText(),
        purple = VSL.Colors.PURPLE:ToText(),
        brown = VSL.Colors.BROWN:ToText(),
        cdruid = VSL.Colors.ORANGE:ToText(),
        chunter = VSL.Colors.GREEN:ToText(),
        cmage = VSL.Colors.BLUE:ToText(),
        cpaladin = VSL.Colors.PINK:ToText(),
        cpriest = VSL.Colors.WHITE:ToText(),
        crogue = VSL.Colors.YELLOW:ToText(),
        cshaman = VSL.Colors.BLUE:ToText(),
        cwarlock = VSL.Colors.PURPLE:ToText(),
        cwarrior = VSL.Colors.LIGHT_BROWN:ToText(),
        star = "{rt1}",
        circle = "{rt2}",
        diamond = "{rt3}",
        triangle = "{rt4}",
        moon = "{rt5}",
        square = "{rt6}",
        cross = "{rt7}",
        x = "{rt7}",
        skull = "{rt8}",
        hs = "|TInterface\\Icons\\INV_Stone_04:0:0:0:{spacing}|t",
        bl = "|TInterface\\Icons\\SPELL_Nature_Bloodlust:0:0:0:{spacing}|t",
        tank = "|TInterface\\LFGFrame\\UI-LFG-ICON-PORTRAITROLES:0:0:0:{spacing}:64:64:0:19:22:41|t",
        healer = "|TInterface\\LFGFrame\\UI-LFG-ICON-PORTRAITROLES:0:0:0:{spacing}:64:64:20:39:1:20|t",
        dps = "|TInterface\\LFGFrame\\UI-LFG-ICON-PORTRAITROLES:0:0:0:{spacing}:64:64:20:39:22:41|t",
        druid = "|TInterface\\GLUES\\CHARACTERCREATE\\UI-CHARACTERCREATE-CLASSES:0:0:0:{spacing}:64:64:48:64:0:16|t",
        hunter = "|TInterface\\GLUES\\CHARACTERCREATE\\UI-CHARACTERCREATE-CLASSES:0:0:0:{spacing}:64:64:0:16:16:32|t",
        mage = "|TInterface\\GLUES\\CHARACTERCREATE\\UI-CHARACTERCREATE-CLASSES:0:0:0:{spacing}:64:64:16:32:0:16|t",
        paladin = "|TInterface\\GLUES\\CHARACTERCREATE\\UI-CHARACTERCREATE-CLASSES:0:0:0:{spacing}:64:64:0:16:32:48|t",
        priest = "|TInterface\\GLUES\\CHARACTERCREATE\\UI-CHARACTERCREATE-CLASSES:0:0:0:{spacing}:64:64:32:48:16:32|t",
        rogue = "|TInterface\\GLUES\\CHARACTERCREATE\\UI-CHARACTERCREATE-CLASSES:0:0:0:{spacing}:64:64:32:48:0:16|t",
        shaman = "|TInterface\\GLUES\\CHARACTERCREATE\\UI-CHARACTERCREATE-CLASSES:0:0:0:{spacing}:64:64:16:32:16:32|t",
        warlock = "|TInterface\\GLUES\\CHARACTERCREATE\\UI-CHARACTERCREATE-CLASSES:0:0:0:{spacing}:64:64:48:64:16:32|t",
        warrior = "|TInterface\\GLUES\\CHARACTERCREATE\\UI-CHARACTERCREATE-CLASSES:0:0:0:{spacing}:64:64:0:16:0:16|t",
      }

      -- Inspired by the work of Angry Assignments
      local text = str:gsub("||", "|")
        :gsub(subReplace('{healthstone}'), "{hs}")
        :gsub(subReplace('{bloodlust}'), "{bl}")
        :gsub(subReplace('{damage}'), "{dps}")
        :gsub(subReplace('{spell%s+(%d+)}'), function(id)
          return GetSpellLink(id)
        end)
        :gsub(subReplace('{icon%s+([%w_]+)}'), "|TInterface\\Icons\\%1:0:0:0:{spacing}|t")
        :gsub(subReplace('{icon%s+(%d+)}'), function(id)
          return format("|T%s:0:0:0:{spacing}|t", select(3, GetSpellInfo(tonumber(id))) )
        end)
        :gsub("{/([%w]+)}", "|r")
        :gsub("{([%w]+)}", function(m)
          local sub = dict[string.lower(m)]
          return sub and sub or ""
        end)
        :gsub(subReplace('{rt([1-8])}'), "|TInterface\\TargetingFrame\\UI-RaidTargetingIcon_%1:0:0:0:{spacing}|t" )
        :gsub(subReplace('{boss%s+(%d+)}'), function(id)
          return select(5, EJ_GetEncounterInfo(id))
        end)
        :gsub(subReplace('{journal%s+(%d+)}'), function(id)
          return C_EncounterJournal.GetSectionInfo(id) and C_EncounterJournal.GetSectionInfo(id).link
        end)
        :gsub("[^%s]+", function(s)
          if not addon.db.profile.players[s] then return s end
          return s:gsub(s, "|c" .. addon.db.profile.players[s].textColor .. s .. "|r")
        end)

      return text
    end
  }
end)