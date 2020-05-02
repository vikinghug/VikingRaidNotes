local VSL = LibStub("VikingSharedLib")
local addonName = ...

local addon = _G[addonName]

local function filter(tbl, func)
  local newtbl= {}
  for i, v in pairs(tbl) do
    if func(v) then
      table.insert(newtbl, v)
    end
  end
  return newtbl
end

addon:Service("VRNUI.SetsService", function()
  return {

    Sets = function()
      return addon.db.profile.sets
    end,

    SelectedSet = function()
      return addon.db.profile.selectedSet
    end,

    SelectedNote = function()
      return addon.db.profile.selectedNote
    end,

    SelectedSetButtons = function()
      local notes = filter(addon.db.profile.bosses, function(v)
        return v.setID == addon.db.profile.selectedSet
      end)
      return notes
    end,

    GetNoteForChannel = function(buttonID, channelID)
      for i, v in ipairs(addon.db.profile.notes) do
        if (v.buttonID == buttonID and v.channelID == channelID) then
          return v
        end
      end
    end,

    SetNoteForChannel = function(self, buttonID, channelID, value)
      local button = self.GetButton(buttonID)
      local set = self.GetSet(button.setID)
      local channel = self.GetChannel(channelID)

      local found = false
      for i, v in ipairs(addon.db.profile.notes) do
        if (v.buttonID == buttonID and v.channelID == channelID) then
          v.value = value
          found = true
        end
      end

      if (not found) then
        table.insert(addon.db.profile.notes, {
          setID = set.id,
          id = #addon.db.profile.notes,
          buttonID = button.id,
          channelID = channel.id,
          name = channel.name .. "_" .. button.name,
          order = #addon.db.profile.notes,
          value = value
        })
      end
    end,

    SelectSet = function(id)
      addon.db.profile.selectedSet = id
    end,

    SelectNote = function(id)
      addon.db.profile.selectedNote = id
    end,

    GetButton = function(id)
      for i, v in ipairs(addon.db.profile.bosses) do
        if v.id == id then
          return v
        end
      end
    end,

    GetSet = function(id)
      for i, v in ipairs(addon.db.profile.sets) do
        if v.id == id then
          return v
        end
      end
    end,

    GetButtonsForSet = function(setID)
      return filter(addon.db.profile.bosses, function(v)
        if v.setID == setID then
          return v
        end
      end)
    end,

    GetNote = function(id)
      for i, v in ipairs(addon.db.profile.notes) do
        if v.id == id then
          return v
        end
      end
    end,

    GetNotesForButton = function(buttonID)
      return filter(addon.db.profile.notes, function(v)
        if v.buttonID == buttonID then
          return v
        end
      end)
    end,

    GetChannel = function(id)
      for i, v in ipairs(addon.db.profile.channels) do
        if v.id == id then
         return v
        end
      end
    end,

    GetChannels = function()
      return addon.db.profile.channels
    end,

    CollapseChannel = function(id)
      for i, v in ipairs(addon.db.profile.channels) do
        if v.id == id then
          v.collapsed = true
        end
      end
    end,

    ExpandChannel = function(id)
      for i, v in ipairs(addon.db.profile.channels) do
        if v.id == id then
          v.collapsed = false
        end
      end
    end,

    PushNotesForButton = function(self, buttonID)
      print(buttonID)
      for _, note in ipairs(self.GetNotesForButton(buttonID)) do
        local data = "note:" .. note.id .. ":" .. note.setID .. ":" .. note.buttonID .. ":" .. note.value
        C_ChatInfo.SendAddonMessage("VRN_NOTES_PUSH", data, "RAID")
      end

      -- set:id:title:value
      -- for _,v in ipairs(addon.Settings.db.profile.macroButtons) do
      --   local n = 1
      --   for i=1,#v.value,200 do
      --     local data = "btn:" .. v.set .. ":" .. v.id .. "." .. n .. ":" .. v.title .. ":" .. string.sub(v.value, i, i+200)
      --     C_ChatInfo.SendAddonMessage("VRT_NOTES_PUSH", data, "GUILD")
      --     n = n+1
      --   end
      -- end
    end
  }
end)