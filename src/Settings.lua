local VSL = LibStub("VikingSharedLib")
local addonName = ...

local addon = _G[addonName]
local Settings = {}; addon.Settings = Settings

local dbDefaults = {
  profile = {
    players = {},

    classColors = {
      Druid = VSL.Colors.ORANGE:ToHex(),
      Hunter = VSL.Colors.DARK_GREEN:ToHex(),
      Mage = VSL.Colors.BLUE:ToHex(),
      Paladin = VSL.Colors.PINK:ToHex(),
      Priest = VSL.Colors.WHITE:ToHex(),
      Rogue = VSL.Colors.YELLOW:ToHex(),
      Shaman = VSL.Colors.DARK_BLUE:ToHex(),
      Warlock = VSL.Colors.PURPLE:ToHex(),
      Warrior = VSL.Colors.LIGHT_BROWN:ToHex(),
    },

    selectedSet = 409,
    selectedNote = 12118,

    sets = {
      { id = 409, name = "Molten Core", short = "MC", order = 1 },
      { id = 469, name = "Blackwing Lair", short = "BWL", order = 2 },
      { id = 309, name = "Zul'Gurub", short = "ZG", order = 3 },
      { id = 509, name = "Ruins of Ahn'Qiraj", short = "AQ20", order = 4 },
      { id = 531, name = "Ahn'Qiraj Temple", short = "AQ40", order = 5 },
    },

    channels = {
      { id = 1, name = "General", order = 1, color = VSL.Colors.YELLOW:ToTable(1), collapsed = false },
      { id = 2, name = "Tanks", order = 2, color = VSL.Colors.LIGHT_BROWN:ToTable(1), collapsed = false },
      { id = 3, name = "Mages", order = 3, color = VSL.Colors.BLUE:ToTable(1), collapsed = false },
      { id = 4, name = "Hunters", order = 4, color = VSL.Colors.DARK_GREEN:ToTable(1), collapsed = false },
      { id = 5, name = "Warlocks", order = 5, color = VSL.Colors.PURPLE:ToTable(1), collapsed = false },
      { id = 6, name = "Healers", order = 6, color = VSL.Colors.WHITE:ToTable(1), collapsed = false },
      { id = 7, name = "DPS", order = 7, color = VSL.Colors.RED:ToTable(1), collapsed = false },
    },

    bosses = {
      -- Molten Core
      { id = 12118, setID = 409, name = "Lucifron", order = 1 },
      { id = 11982, setID = 409, name = "Magmadar", order = 2 },
      { id = 12259, setID = 409, name = "Gehennas", order = 3 },
      { id = 12057, setID = 409, name = "Garr", order = 4 },
      { id = 12264, setID = 409, name = "Shazzrah", order = 5 },
      { id = 12056, setID = 409, name = "Baron Geddon", order = 6 },
      { id = 11988, setID = 409, name = "Golemagg the Incinerator", order = 7 },
      { id = 12098, setID = 409, name = "Sulfuron Harbringer", order = 8 },
      { id = 12018, setID = 409, name = "Majordomo Executus", order = 9 },
      { id = 11502, setID = 409, name = "Ragnaros", order = 10 },

      -- Blackwing Lair
      { id = 12435, setID = 469, name = "Razorgore the Untamed", order = 11 },
      { id = 13020, setID = 469, name = "Vaelastrasz the Corrupt", order = 12 },
      { id = 12017, setID = 469, name = "Broodlord Lashlayer", order = 13 },
      { id = 11983, setID = 469, name = "Firemaw", order = 14 },
      { id = 14601, setID = 469, name = "Ebonroc", order = 15 },
      { id = 11981, setID = 469, name = "Flamegor", order = 16 },
      { id = 14020, setID = 469, name = "Chromaggus", order = 17 },
      { id = 11583, setID = 469, name = "Nefarian", order = 18 },
    },

    notes = {

      { setID = 409, id = 7,  buttonID = 12118, channelID = 2, name = "(2) Note 409.12118", order = 1, value = [[
{yellow}Main Tank:{/yellow}
  Thorikson

{yellow}Off Tanks:{/yellow}
  {skull} Vikinghug
  {x} Bolognababy]] },
      { setID = 409, id = 8,  buttonID = 12118, channelID = 3, name = "(3) Note 409.12118", order = 2, value = "{rt3} This is note 3.409.12118" },
      { setID = 409, id = 10, buttonID = 12118, channelID = 5, name = "(5) Note 409.12118", order = 3, value = "{rt5} This is note 5.409.12118" },

      { setID = 409, id = 1,  buttonID = 11982, channelID = 1, name = "(1) Note 409.11982", order = 1, value = "{star} This is note 1.409.11982" },
      { setID = 409, id = 9,  buttonID = 11982, channelID = 4, name = "(4) Note 409.11982", order = 2, value = "{triangle} This is note 4.409.11982" },
      { setID = 409, id = 11,  buttonID = 11982, channelID = 5, name = "(5) Note 409.11982", order = 3, value = "" },
      { setID = 409, id = 12,  buttonID = 11982, channelID = 6, name = "(6) Note 409.11982", order = 3, value = nil },


      { setID = 469, id = 2, buttonID = 12435, channelID = 1, name = "Note 1.2", order = 2, value = "This is note 1.2" },
      { setID = 469, id = 3, buttonID = 12435, channelID = 1, name = "Note 2.1", order = 1, value = "This is note 2.1" },
      { setID = 469, id = 4, buttonID = 12435, channelID = 1, name = "Note 2.2", order = 2, value = "This is note 2.2" },
      { setID = 469, id = 5, buttonID = 12435, channelID = 1, name = "Note 3.1", order = 1, value = "This is note 3.1" },
      { setID = 469, id = 6, buttonID = 12435, channelID = 1, name = "Note 3.2", order = 2, value = "This is note 3.2" },
    },
  }
}

local options = {
  type = "group",
	args = {
		search = {
			type = "header",
			name = "Header Item",
    },
  }
}
function Settings:OnLoad()
  addon.db = LibStub("AceDB-3.0"):New(addonName .. "DB", dbDefaults)
  LibStub("AceConfig-3.0"):RegisterOptionsTable(addonName, options)
end

--[[                                                                      OPTIONS ]]

-- local L = LibStub('AceLocale-3.0'):GetLocale(addonName)
local AceConfig = LibStub("AceConfig-3.0")
local AceDBOptions = LibStub("AceDBOptions-3.0")
local AceConfigDialog = LibStub("AceConfigDialog-3.0")

local Options = {}; addon.Options = Options

local function spairs(t, order)
  -- collect the keys
  local keys = {}
  for k in pairs(t) do keys[#keys+1] = k end

  -- if order function given, sort by it by passing the table and keys a, b,
  -- otherwise just sort the keys
  if order then
      table.sort(keys, function(a,b) return order(t, a, b) end)
  else
      table.sort(keys)
  end

  -- return the iterator function
  local i = 0
  return function()
      i = i + 1
      if keys[i] then
          return keys[i], t[keys[i]]
      end
  end
end

Options.options1 = {
  name = addonName,
  type = 'group',
  args = { }
}


local i = 1

local bool = false
Options.options2 = {
  name = "Options 2",
  type = 'group',
  childGroups = "tab",
  args = {
    enable = {
      name = "Enable",
      desc = "Enables / disables the addon",
      type = "execute",
      func = function(info, val) bool = val end,
    },
  }
}

local function GetSetsOptions(SetsService)
  local sets = SetsService.Sets()

  for _, set in ipairs(sets) do
    local buttons = {}
    for _, btn in ipairs(SetsService.GetButtonsForSet(set.id)) do
      local channels = {}

      for _, channel in ipairs(SetsService.GetChannels()) do
        local note = SetsService.GetNoteForChannel(btn.id, channel.id)
        channels[channel.name] = {
          type = "group",
          order = channel.order,
          name = channel.name,
          inline = true,
          args = {
            note = {
              name = "Note",
              type = "input",
              width = "full",
              multiline = 10,
              set = function(info, val)
                SetsService:SetNoteForChannel(btn.id, channel.id, val)
                addon.Frame:SetNotes(btn.id)
              end,

              get = function(info)
                local noteData = SetsService.GetNoteForChannel(btn.id, channel.id)
                return noteData and noteData.value or ""
              end
            },
          }
        }
      end

      channels.push = {
        type = "execute",
        name = "Push " .. btn.name,
        order = 0,
        func = function()
          SetsService:PushNotesForButton(btn.id)
        end
      }

      buttons[tostring(btn.id)] = {
        type = "group",
        order = btn.order,
        name = btn.name,
        args = channels,
      }
    end

    Options.options2.args[tostring(set.id)] = {
      type = "group",
      order = set.order,
      name = set.name,
      args = buttons,
      childGroups = "tree",
    }
  end

  return Options.options2
end

function Options:OnLoad(SetsService)
  AceConfig:RegisterOptionsTable(addonName, addon.Options.options1, { "vikingraidnotes", "vrn" })
  AceConfigDialog:AddToBlizOptions(addonName, addonName)

  LibStub("AceConsole-3.0"):RegisterChatCommand("vrnc", function()
    AceConfigDialog:Open("VikingRaidNotes.options2")
  end)

  local profiles = AceDBOptions:GetOptionsTable(addon.db)
  AceConfig:RegisterOptionsTable(addonName .. ".profiles", profiles)
  AceConfigDialog:AddToBlizOptions(addonName .. ".profiles", "Profiles", addonName)

  AceConfig:RegisterOptionsTable(addonName .. ".options2", GetSetsOptions(SetsService))
  AceConfigDialog:AddToBlizOptions(addonName .. ".options2", "Options 2", addonName)

  --@debug@
  -- AceConfig:RegisterOptionsTable(addonName .. ".model", modelOptions, {"model"})
  --@end-debug@
end

-- function Options:OpenModelOptions()
--   if not AceConfigDialog.OpenFrames[addonName .. ".model"] then
--     AceConfigDialog:Open(addonName .. ".model")
--   end
-- end






--[[
addon:Service("VRNUI.PoolService", function()
  local pools = {}

  return {
    Clear = function(self, parent)
      local name = parent:GetName()
      local pool = pools[name] or {}

      for i, item in ipairs(pool) do
        item:Hide()
        item.active = false
      end

      pools[name] = pool
    end,
    Add = function(self, parent, options)
      local name = parent:GetName()
      local pool = pools[name] or {}

      local found = false
      for i, item in ipairs(pool) do
        if (item.active == false) then
          found = i
          break
        end
      end

      if (found) then
        pool[found]:Update(options)
      else
        table.insert(pool, {})
      end

      pools[name] = pool
    end
  }
end)
]]

