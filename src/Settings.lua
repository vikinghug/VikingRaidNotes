--[[
  TODO: THIS NEEDS TO BE CONSOLIDATED
    - services/Settings.lua
    - Options.lua?
]]

local VSL = LibStub("VikingSharedLib")
local AceDB = LibStub("AceDB-3.0")
local AceGUI = LibStub("AceGUI-3.0")

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
      { id = 409, name = "Molten Core", short = "MC", order = 1, createdAt = 1588447958, updatedAt = 1588447958 },
      { id = 469, name = "Blackwing Lair", short = "BWL", order = 2, createdAt = 1588447958, updatedAt = 1588447958 },
      { id = 309, name = "Zul'Gurub", short = "ZG", order = 3, createdAt = 1588447958, updatedAt = 1588447958 },
      { id = 509, name = "Ruins of Ahn'Qiraj", short = "AQ20", order = 4, createdAt = 1588447958, updatedAt = 1588447958 },
      { id = 531, name = "Ahn'Qiraj Temple", short = "AQ40", order = 5, createdAt = 1588447958, updatedAt = 1588447958 },
    },

    channels = {
      { id = 1, name = "General", order = 1, color = VSL.Colors.YELLOW:ToTable(1), collapsed = false, createdAt = 1588447958, updatedAt = 1588447958 },
      { id = 2, name = "Tanks", order = 2, color = VSL.Colors.LIGHT_BROWN:ToTable(1), collapsed = false, createdAt = 1588447958, updatedAt = 1588447958 },
      { id = 3, name = "Mages", order = 3, color = VSL.Colors.BLUE:ToTable(1), collapsed = false, createdAt = 1588447958, updatedAt = 1588447958 },
      { id = 4, name = "Hunters", order = 4, color = VSL.Colors.DARK_GREEN:ToTable(1), collapsed = false, createdAt = 1588447958, updatedAt = 1588447958 },
      { id = 5, name = "Warlocks", order = 5, color = VSL.Colors.PURPLE:ToTable(1), collapsed = false, createdAt = 1588447958, updatedAt = 1588447958 },
      { id = 6, name = "Healers", order = 6, color = VSL.Colors.WHITE:ToTable(1), collapsed = false, createdAt = 1588447958, updatedAt = 1588447958 },
      { id = 7, name = "DPS", order = 7, color = VSL.Colors.RED:ToTable(1), collapsed = false, createdAt = 1588447958, updatedAt = 1588447958 },
    },

    bosses = {
      -- Molten Core: 409
      { id = 12118, setID = 409, name = "Lucifron", order = 1, createdAt = 1588447958, updatedAt = 1588447958 },
      { id = 11982, setID = 409, name = "Magmadar", order = 2, createdAt = 1588447958, updatedAt = 1588447958 },
      { id = 12259, setID = 409, name = "Gehennas", order = 3, createdAt = 1588447958, updatedAt = 1588447958 },
      { id = 12057, setID = 409, name = "Garr", order = 4, createdAt = 1588447958, updatedAt = 1588447958 },
      { id = 12264, setID = 409, name = "Shazzrah", order = 5, createdAt = 1588447958, updatedAt = 1588447958 },
      { id = 12056, setID = 409, name = "Baron Geddon", order = 6, createdAt = 1588447958, updatedAt = 1588447958 },
      { id = 11988, setID = 409, name = "Golemagg the Incinerator", order = 7, createdAt = 1588447958, updatedAt = 1588447958 },
      { id = 12098, setID = 409, name = "Sulfuron Harbringer", order = 8, createdAt = 1588447958, updatedAt = 1588447958 },
      { id = 12018, setID = 409, name = "Majordomo Executus", order = 9, createdAt = 1588447958, updatedAt = 1588447958 },
      { id = 11502, setID = 409, name = "Ragnaros", order = 10, createdAt = 1588447958, updatedAt = 1588447958 },
      { id = 409.1, setID = 409, name = "Trash", order = 11, createdAt = 1588447958, updatedAt = 1588447958 },

      -- Blackwing Lair: 469
      { id = 12435, setID = 469, name = "Razorgore the Untamed", order = 1, createdAt = 1588447958, updatedAt = 1588447958 },
      { id = 13020, setID = 469, name = "Vaelastrasz the Corrupt", order = 2, createdAt = 1588447958, updatedAt = 1588447958 },
      { id = 12017, setID = 469, name = "Broodlord Lashlayer", order = 3, createdAt = 1588447958, updatedAt = 1588447958 },
      { id = 11983, setID = 469, name = "Firemaw", order = 4, createdAt = 1588447958, updatedAt = 1588447958 },
      { id = 14601, setID = 469, name = "Ebonroc", order = 5, createdAt = 1588447958, updatedAt = 1588447958 },
      { id = 11981, setID = 469, name = "Flamegor", order = 6, createdAt = 1588447958, updatedAt = 1588447958 },
      { id = 14020, setID = 469, name = "Chromaggus", order = 7, createdAt = 1588447958, updatedAt = 1588447958 },
      { id = 11583, setID = 469, name = "Nefarian", order = 8, createdAt = 1588447958, updatedAt = 1588447958 },
      { id = 469.1, setID = 469, name = "Trash", order = 9, createdAt = 1588447958, updatedAt = 1588447958 },

      --[[ ZG: 309
          - High Priest Venoxis
          - High Priestess Jeklik
          - High Priestess Mar'li
          - High Priest Thekal
          - High Priestess Arlokk
          - Hakkar

        Optional
          - Bloodlord Mandokir(11382) & Ohgan(14988)
          - Edge of Madness
          - Gahz'ranka
          - Jin'do the Hexxer
      ]]
      { id = 14507, setID = 309, name = "High Priest Venoxis", order = 1, createdAt = 1588447958, updatedAt = 1588447958 },
      { id = 14517, setID = 309, name = "High Priestess Jeklik", order = 2, createdAt = 1588447958, updatedAt = 1588447958 },
      { id = 14510, setID = 309, name = "High Priestess Mar'li", order = 3, createdAt = 1588447958, updatedAt = 1588447958 },
      { id = 14509, setID = 309, name = "High Priest Thekal", order = 4, createdAt = 1588447958, updatedAt = 1588447958 },
      { id = 14515, setID = 309, name = "High Priestess Arlokk", order = 5, createdAt = 1588447958, updatedAt = 1588447958 },
      { id = 14834, setID = 309, name = "Hakkar", order = 6, createdAt = 1588447958, updatedAt = 1588447958 },

      { id = 11382, setID = 309, name = "Bloodlord Mandokir", order = 7, createdAt = 1588447958, updatedAt = 1588447958 },
      { id = 15083, setID = 309, name = "Edge of Madness", order = 8, createdAt = 1588447958, updatedAt = 1588447958 },
      { id = 15114, setID = 309, name = "Gahz'ranka", order = 9, createdAt = 1588447958, updatedAt = 1588447958 },
      { id = 11380, setID = 309, name = "Jin'do the Hexxer", order = 10, createdAt = 1588447958, updatedAt = 1588447958 },
      { id = 309.1, setID = 309, name = "Trash", order = 11, createdAt = 1588447958, updatedAt = 1588447958 },


      --[[ AQ20: 509
          - Kurinnaxx
          - General Rajaxx
          - Moam
          - Buru the Gorger
          - Ayamiss the Hunter
          - Ossirian the Unscarred
      ]]
      { id = 509.1, setID = 509, name = "Trash", order = 1, createdAt = 1588447958, updatedAt = 1588447958 },


      --[[ AQ40: 531
          - The Prophet Skeram
          - Battleguard Sartura
          - Fankriss the Unyielding
          - Princess Huhuran
          - Twin Emperors: Vek'lor(15276) & Vek'nilash(15275)
          - C'Thun

        Optional
          - Bug Trio: Yauj(15543), Vem(15544), Kri(15511)
          - Viscidus
          - Ouro
      ]]
      { id = 15263, setID = 531, name = "The Prophet Skeram", order = 1, createdAt = 1588447958, updatedAt = 1588447958 },
      { id = 15516, setID = 531, name = "Battleguard Sartura", order = 2, createdAt = 1588447958, updatedAt = 1588447958 },
      { id = 15510, setID = 531, name = "Fankriss the Unyielding", order = 3, createdAt = 1588447958, updatedAt = 1588447958 },
      { id = 15509, setID = 531, name = "Princess Huhuran", order = 4, createdAt = 1588447958, updatedAt = 1588447958 },
      { id = 15276, setID = 531, name = "Twin Emperors", order = 5, createdAt = 1588447958, updatedAt = 1588447958 },
      { id = 15727, setID = 531, name = "C'Thun", order = 6, createdAt = 1588447958, updatedAt = 1588447958 },
      { id = 15543, setID = 531, name = "Bug Trio", order = 7, createdAt = 1588447958, updatedAt = 1588447958 },
      { id = 15299, setID = 531, name = "Viscidus", order = 8, createdAt = 1588447958, updatedAt = 1588447958 },
      { id = 15517, setID = 531, name = "Ouro", order = 9, createdAt = 1588447958, updatedAt = 1588447958 },
      { id = 531.1, setID = 531, name = "Trash", order = 10, createdAt = 1588447958, updatedAt = 1588447958 },

      --[[ Naxx
        The Arachnid Quarter
          - Anub'Rekhan
          - Grand Widow Faerlina
          - Maexxna

        The Plague Quarter
          - Noth the Plaguebringer
          - Heigan the Unclean
          - Loatheb

        The Military Quarter
          - Instructor Razuvious
          - Gothik the Harvester
          - The Four Horsemen

        The Construct Quarter
          - Patchwerk
          - Grobbulus
          - Gluth
          - Thaddius

        Frostwyrm Lair
          - Sapphiron
          - Kel'Thuzad
    ]]
    },

    notes = {
      { setID = 409, id = 7,  buttonID = 12118, channelID = 2, name = "(2) Note 409.12118", order = 1, value = [[
{yellow}Main Tank:{/yellow}
  Thorikson

{yellow}Off Tanks:{/yellow}
  {skull} Vikinghug
  {x} Bolognababy]],
        createdAt = 1588447958, updatedAt = 1588447958
      },
    },
  }
}

function Settings:OnLoad()
  addon.db = AceDB:New(addonName .. "DB", dbDefaults)
end

--[[ -------------------------------------------------------------------------------------------------------- OPTIONS ]]

-- local L = LibStub('AceLocale-3.0'):GetLocale(addonName)
local AceConfig = LibStub("AceConfig-3.0")
local AceDBOptions = LibStub("AceDBOptions-3.0")
local AceConfigDialog = LibStub("AceConfigDialog-3.0")
local AceConsole = LibStub("AceConsole-3.0")
local AceConfigRegistry = LibStub("AceConfigRegistry-3.0")

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
  args = { }
}

local description =
"{blue}" .. VSL.Colors.BLUE:ToText() .. "blue text|r{/blue}\n" ..
"{green}" .. VSL.Colors.GREEN:ToText() .. "green text|r{/green}\n" ..
"{red}" .. VSL.Colors.RED:ToText() .. "red text|r{/red}\n" ..
"{yellow}" .. VSL.Colors.YELLOW:ToText() .. "yellow text|r{/yellow}\n" ..
"{orange}" .. VSL.Colors.ORANGE:ToText() .. "orange text|r{/orange}\n" ..
"{pink}" .. VSL.Colors.PINK:ToText() .. "pink text|r{/pink}\n" ..
"{purple}" .. VSL.Colors.PURPLE:ToText() .. "purple text|r{/purple}\n" ..
"{brown}" .. VSL.Colors.BROWN:ToText() .. "brown text|r{/brown}\n" ..
"{cdruid}" .. VSL.Colors.ORANGE:ToText() .. "orange text|r{/cdruid}\n" ..
"{chunter}" .. VSL.Colors.GREEN:ToText() .. "green text|r{/chunter}\n" ..
"{cmage}" .. VSL.Colors.BLUE:ToText() .. "blue text|r{/cmage}\n" ..
"{cpaladin}" .. VSL.Colors.PINK:ToText() .. "pink text|r{/cpaladin}\n" ..
"{cpriest}" .. VSL.Colors.WHITE:ToText() .. "white text|r{/cpriest}\n" ..
"{crogue}" .. VSL.Colors.YELLOW:ToText() .. "yellow text|r{/crogue}\n" ..
"{cshaman}" .. VSL.Colors.DARK_BLUE:ToText() .. "blue text|r{/cshaman}|r\n" ..
"{cwarlock}" .. VSL.Colors.PURPLE:ToText() .. "purple text|r{/cwarlock}\n" ..
"{cwarrior}" .. VSL.Colors.LIGHT_BROWN:ToText() .. "brown text|r{/cwarrior}\n" ..
[[{skull} = |TInterface\TargetingFrame\UI-RaidTargetingIcon_8:0|t
{x} = |TInterface\TargetingFrame\UI-RaidTargetingIcon_7:0|t
{square} = |TInterface\TargetingFrame\UI-RaidTargetingIcon_6:0|t
{moon} = |TInterface\TargetingFrame\UI-RaidTargetingIcon_5:0|t
{triangle} = |TInterface\TargetingFrame\UI-RaidTargetingIcon_4:0|t
{diamond} = |TInterface\TargetingFrame\UI-RaidTargetingIcon_3:0|t
{circle} = |TInterface\TargetingFrame\UI-RaidTargetingIcon_2:0|t
{star} = |TInterface\TargetingFrame\UI-RaidTargetingIcon_1:0|t
{hs} = |TInterface\Icons\INV_Stone_04:0:0:0:0|t
{bl} = |TInterface\Icons\SPELL_Nature_Bloodlust:0:0:0:0|t
{tank} = |TInterface\LFGFrame\UI-LFG-ICON-PORTRAITROLES:0:0:0:0:64:64:0:19:22:41|t
{healer} = |TInterface\LFGFrame\UI-LFG-ICON-PORTRAITROLES:0:0:0:0:64:64:20:39:1:20|t
{dps} = |TInterface\LFGFrame\UI-LFG-ICON-PORTRAITROLES:0:0:0:0:64:64:20:39:22:41|t
{druid} = |TInterface\GLUES\CHARACTERCREATE\UI-CHARACTERCREATE-CLASSES:0:0:0:0:64:64:48:64:0:16|t
{hunter} = |TInterface\GLUES\CHARACTERCREATE\UI-CHARACTERCREATE-CLASSES:0:0:0:0:64:64:0:16:16:32|t
{mage} = |TInterface\GLUES\CHARACTERCREATE\UI-CHARACTERCREATE-CLASSES:0:0:0:0:64:64:16:32:0:16|t
{paladin} = |TInterface\GLUES\CHARACTERCREATE\UI-CHARACTERCREATE-CLASSES:0:0:0:0:64:64:0:16:32:48|t
{priest} = |TInterface\GLUES\CHARACTERCREATE\UI-CHARACTERCREATE-CLASSES:0:0:0:0:64:64:32:48:16:32|t
{rogue} = |TInterface\GLUES\CHARACTERCREATE\UI-CHARACTERCREATE-CLASSES:0:0:0:0:64:64:32:48:0:16|t
{shaman} = |TInterface\GLUES\CHARACTERCREATE\UI-CHARACTERCREATE-CLASSES:0:0:0:0:64:64:16:32:16:32|t
{warlock} = |TInterface\GLUES\CHARACTERCREATE\UI-CHARACTERCREATE-CLASSES:0:0:0:0:64:64:48:64:16:32|t
{warrior} = |TInterface\GLUES\CHARACTERCREATE\UI-CHARACTERCREATE-CLASSES:0:0:0:0:64:64:0:16:0:16|t]]

function Options:UpdateSetsOptions()
  local sets = addon.Services.SettingsService.Sets()

  for _, set in ipairs(sets) do
    local buttons = {}
    for _, btn in ipairs(addon.Services.SettingsService.GetButtonsForSet(set.id)) do
      local channels = {}

      for _, channel in ipairs(addon.Services.SettingsService.GetChannels()) do
        local note = addon.Services.SettingsService.GetNoteForChannel(btn.id, channel.id)
        -- channels[channel.name] = {
        --   type = "header",
        --   order = channel.order,
        --   name = channel.name,
        -- }
        local channelColor = VSL.Colors:New(
          channel.color.r,
          channel.color.g,
          channel.color.b,
          channel.color.a
        )
        channels[channel.name .. "_break"] =  {
          type = "header",
          name = "",
          order = channel.order
        }

        channels[channel.name .. "_label"] =  {
          type = "description",
          name = channelColor:ToText() .. channel.name .. "|r",
          order = channel.order + 0.1,
          fontSize = "large",
        }

        channels[channel.name .. "_note"] = {
          name = "Note Value",
          desc = description,
          order = channel.order + 0.2,
          type = "input",
          width = "full",
          multiline = 10,
          set = function(info, val)
            addon.Services.SettingsService:SetNoteForChannel(btn.id, channel.id, val)
            addon.Frame:SetNotes(btn.id)
          end,

          get = function(info)
            local noteData = addon.Services.SettingsService.GetNoteForChannel(btn.id, channel.id)
            return noteData and noteData.value or ""
          end
        }

        channels[channel.name .. "_desc"] =  {
          type = "description",
          order = channel.order + 0.3,
          name =
            "Last Updated: " .. ((note and note.updatedAt) and note.updatedAt or "Never") ..
            (note and (
              ", id: " .. note.id ..
              ", btnID: " .. note.buttonID ..
              ", setID: " .. note.setID ..
              ", channelID: " .. note.channelID
            ) or "") ..
            "\n\n"
        }
      end

      channels.push = {
        type = "execute",
        name = "Push '" .. btn.name .. "' to Raid Members",
        order = 0,
        width = "full",
        func = function()
          addon.Services.CommService:PushNotesForButton(btn.id)
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

  AceConfigRegistry:NotifyChange(addonName .. ".options2")
end

-- Options.players = {
--   name = "Players",
--   type = 'group',
--   args = {
--     hr =  {
--       type = "header",
--       name = "",
--       order = 1
--     }
--   }
-- }

-- local function strToNum(str)
--   local val = 0
--   for i = 1, #str do
--       val = val + str:upper():byte(i, i+1)
--   end
--   return val
-- end

-- function Options:UpdatePlayersOptions()
--   for i, player in ipairs(getSortedPlayers()) do
--     print(player)
--     Options.players.args[player.name] = {
--       type = "description",
--       width = 1,
--       order = i,
--       name = "|c" .. player.textColor .. player.name .. "|r",
--     }
--     Options.players.args[player.name .. "_version"] = {
--       type = "description",
--       width = 1,
--       order = i + 0.1,
--       name = "|c" .. player.textColor .. "xxx" .. "|r",
--     }
--   end

--   AceConfigRegistry:NotifyChange(addonName .. ".players")
-- end

local function getSortedPlayers()
  local players = addon.Services.PlayersService.GetRaidPlayers()

  table.sort(players, function(a, b) return a.name:upper() < b.name:upper() end)
  return players
end

local function PlayerList(frame)
  local scrollContainer = AceGUI:Create("SimpleGroup")
  scrollContainer:SetFullWidth(true)
  scrollContainer:SetHeight(250)
  scrollContainer:SetLayout("Fill")

  local scroll = AceGUI:Create("ScrollFrame")
  scroll:SetLayout("List")
  scrollContainer:AddChild(scroll)

  local playerVersions = {}

  for i, player in ipairs(getSortedPlayers()) do
    local playerContainer = AceGUI:Create("SimpleGroup")
    local label = AceGUI:Create("Label")
    local version = AceGUI:Create("Label")

    label:SetText("|c" .. player.textColor .. player.name .. "|r")
    label:SetRelativeWidth(0.65)

    version:SetText(
      addon.Services.PlayersService:GetVersionTextColor(player.name) ..
      player.version
    )
    version:SetJustifyH("Right")
    version:SetRelativeWidth(0.35)

    playerContainer:SetFullWidth(true)
    playerContainer:SetLayout("Flow")
    playerContainer:AddChild(label)
    playerContainer:AddChild(version)

    scroll:AddChild(playerContainer)

    playerVersions[player.name] = version
  end

  VRNPLAYERS = playerVersions

  frame:AddChild(scrollContainer)
  return playerVersions
end

function Options:PlayersVersionWindow()
  if (Options.playersFrameShown) then return end

  local frame = AceGUI:Create("Window")
  frame:SetTitle("Players")
  frame:SetStatusText("AceGUI-3.0 Example Container Frame")
  frame:SetCallback("OnClose", function(widget)
    AceGUI:Release(widget)
    Options.playersFrameShown = false
  end)
  frame:SetLayout("Flow")
  frame:SetWidth(300)
  frame:SetHeight(400)

  local header = AceGUI:Create("SimpleGroup")
  local contents = AceGUI:Create("InlineGroup")
  contents:SetLayout("Fill")
  contents:SetFullWidth(true)
  contents:SetFullHeight(true)

  local playerVersions = PlayerList(contents)

  local syncButton = AceGUI:Create("Button")
  syncButton:SetFullWidth(true)
  syncButton:SetText("Scan for Versions")
  syncButton:SetCallback("OnClick", function(widget)
    for k, v in pairs(playerVersions) do
      v:SetText(VSL.Colors.DARK_GREY:ToText() .. "...")
    end

    addon.Services.CommService:CheckVersions(playerVersions, function(player, online)
      C_Timer.After(2, function()
        playerVersions[player]:SetText(
          (online and "" or (VSL.Colors.DARK_GREY:ToText() .. "offline|r ")) ..
          addon.Services.PlayersService:GetVersionTextColor(player) ..
          addon.Services.PlayersService:GetVersionText(player)
        )
      end)
    end)
  end)
  header:AddChild(syncButton)

  frame:AddChild(header)
  frame:AddChild(contents)
  Options.playersFrameShown = true
end


function Options:OnLoad()
  AceConfig:RegisterOptionsTable(addonName, addon.Options.options1, { "vikingraidnotes", "vrn" })
  AceConfigDialog:AddToBlizOptions(addonName, addonName)

  local profiles = AceDBOptions:GetOptionsTable(addon.db)
  AceConfig:RegisterOptionsTable(addonName .. ".profiles", profiles)
  AceConfigDialog:AddToBlizOptions(addonName .. ".profiles", "Profiles", addonName)

  Options:UpdateSetsOptions()
  AceConfig:RegisterOptionsTable(addonName .. ".options2", Options.options2)
  AceConfigDialog:AddToBlizOptions(addonName .. ".options2", "Options 2", addonName)

  AceConsole:RegisterChatCommand("vrnc", function()
    AceConfigDialog:Open("VikingRaidNotes.options2")
  end)

  -- TODO: Put this back in.. only removed for simplicity sake right now
  -- Options:UpdatePlayersOptions()
  -- AceConfig:RegisterOptionsTable(addonName .. ".players", Options.players)
  -- AceConfigDialog:AddToBlizOptions(addonName .. ".players", "Players", addonName)
  AceConsole:RegisterChatCommand("vrnp", function()
    Options:PlayersVersionWindow()
  end)
end