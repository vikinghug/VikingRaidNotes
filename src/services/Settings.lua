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

addon:Service("VRNUI.SettingsService", function()
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

    GetNoteForChannel = function(self, buttonID, channelID)
      local found = false
      for i, v in ipairs(addon.db.profile.notes) do
        if (v.buttonID == buttonID and v.channelID == channelID) then
          found = v
        end
      end

      if (not found) then
        local timestamp = time()
        local button = self:GetButton(buttonID)
        local channel = self:GetChannel(channelID)

        -- TODO: MAKE THIS TRULY UNIQUE... this is a really unpredictable way of doing this
        local id = #addon.db.profile.notes
        table.insert(addon.db.profile.notes, {
          setID = button.setID,
          id = id,
          buttonID = buttonID,
          channelID = channelID,
          name = channel.name .. "_" .. button.name,
          order = id,
          value = "",
          updatedAt = timestamp
        })

        return self:GetNote(id)
      else
        return found
      end
    end,

    SetNoteForChannel = function(self, buttonID, channelID, value)
      local timestamp = time()
      local button = self:GetButton(buttonID)
      local set = self:GetSet(button.setID)
      local channel = self:GetChannel(channelID)

      local found = false
      for i, v in ipairs(addon.db.profile.notes) do
        if (v.buttonID == buttonID and v.channelID == channelID) then
          v.value = value
          v.updatedAt = timestamp
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
          value = value,
          updatedAt = timestamp
        })
      end
    end,

    UpsertNote = function(self, note)
      local timestamp = time()

      local found = false
      for i, v in ipairs(addon.db.profile.notes) do
        if (v.channelID == note.channelID and v.buttonID == note.buttonID) then
          found = true
          addon.db.profile.notes[i].value = note.value
          addon.db.profile.notes[i].updatedAt = timestamp
        end
      end

      if (not found) then
        note.updatedAt = timestamp
        table.insert(addon.db.profile.notes, note)
      end

      addon.Options:UpdateSetsOptions()
    end,

    UpsertNotes = function(self, notes)
      for i, v in ipairs(notes) do
        self:UpsertNote(v)
      end
    end,

    SelectSet = function(self, id)
      addon.db.profile.selectedSet = id
    end,

    SelectNote = function(self, id)
      addon.db.profile.selectedNote = id
    end,

    GetButton = function(self, id)
      for i, v in ipairs(addon.db.profile.bosses) do
        if v.id == id then
          return v
        end
      end
    end,

    GetSet = function(self, id)
      for i, v in ipairs(addon.db.profile.sets) do
        if v.id == id then
          return v
        end
      end
    end,

    GetButtonsForSet = function(self, setID)
      return filter(addon.db.profile.bosses, function(v)
        if v.setID == setID then
          return v
        end
      end)
    end,

    GetNote = function(self, id)
      for i, v in ipairs(addon.db.profile.notes) do
        if v.id == id then
          return v
        end
      end
    end,

    GetNotesForButton = function(self, buttonID)
      return filter(addon.db.profile.notes, function(v)
        if v.buttonID == buttonID then
          return v
        end
      end)
    end,

    GetChannel = function(self, id)
      for i, v in ipairs(addon.db.profile.channels) do
        if v.id == id then
         return v
        end
      end
    end,

    GetChannels = function(self)
      return addon.db.profile.channels
    end,

    SaveNotesPosition = function(self, x, y)
      addon.db.profile.notesPosition = {
        x = x,
        y = y,
      }
    end,

    CollapseChannel = function(self, id)
      for i, v in ipairs(addon.db.profile.channels) do
        if v.id == id then
          v.collapsed = true
        end
      end
    end,

    ExpandChannel = function(self, id)
      for i, v in ipairs(addon.db.profile.channels) do
        if v.id == id then
          v.collapsed = false
        end
      end
    end
  }
end)