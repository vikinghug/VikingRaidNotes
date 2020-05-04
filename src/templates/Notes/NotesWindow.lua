local VSL = LibStub("VikingSharedLib")
local addonName = ...

local addon = _G[addonName]

local Helpers = {};

function Helpers:Find(data, id)
  local comp = function(v)
    if (v.id == id) then return true end
    return false
  end

  if (type(id) == "function") then
    comp = id
  end

  for k, v in ipairs(data) do
    if (comp(v)) then return v end
  end
end

addon:Controller("VRNUI.NotesWindow", { "VRNUI.SettingsService", function(SettingsService)
  local pool = {}

  return {
    OnBind = function(frame)
      for i, v in ipairs(addon.db.profile.channels) do
        local parent = (i == 1) and frame.Content or pool[i-1]
        local note = CreateFrame("Frame", nil, frame.Content, "VRNNoteTemplate")
        note.channelID = v.id
        note:SetPoint("TOPLEFT", parent, "BOTTOMLEFT", 0, -3)
        note:SetPoint("TOPRIGHT", parent, "BOTTOMRIGHT", 0, -3)
        note:SetTitle(v)

        table.insert(pool, note)
      end

      frame.ExpandButton:Hide()

      frame:SetNotes(addon.db.profile, SettingsService.SelectedNote())


      frame:SetClampedToScreen(true)

      -- frame.TitleBar:SetClampedToScreen(true)
      frame.TitleBar:RegisterForDrag("LeftButton")

      frame.TitleBar:SetScript("OnDragStart", function()
        frame:StartMoving()
      end)

      frame.TitleBar:SetScript("OnDragStop", function()
        frame:StopMovingOrSizing()
      end)

      frame.TitleBar:SetScript("OnEnter", function()
        frame.ControlButtons:Open()
      end)

      frame.TitleBar:SetScript("OnLeave", function()
        frame.ControlButtons:Close()
      end)
    end,

    SetNotes = function(frame, data, buttonID)
      local parent = frame

      for _, channel in ipairs(data.channels) do
        local noteFrame = Helpers:Find(pool, function(v) return v.channelID == channel.id end)
        if (noteFrame) then
        else
          local note = CreateFrame("Frame", nil, frame.Content, "VRNNoteTemplate")
          note.channelID = channel.id
          note:SetTitle(channel)
          table.insert(pool, note)
        end
      end

      for i, note in ipairs(pool) do
        local noteData = Helpers:Find(data.notes, function(v)
          if (v.buttonID == buttonID and v.channelID == note.channelID) then
            return true
          end
        end)

        if (noteData ~= nil and noteData.value ~= nil and noteData.value ~= "") then
          note:SetPoint("TOPLEFT", parent, "BOTTOMLEFT", 0, -3)
          note:SetPoint("TOPRIGHT", parent, "BOTTOMRIGHT", 0, -3)
          note:SetContent(noteData)
          note:Show()
          parent = note
        else
          note:Hide()
        end
      end

      local buttonData = Helpers:Find(data.bosses, buttonID)
      local setData = Helpers:Find(data.sets, buttonData.setID)

      frame.TitleBar.Text:SetText(setData.short .. " - " .. buttonData.name)
    end,

    Collapse = function(frame)
      frame.Content:Hide()
    end,

    Expand = function(frame)
      frame.Content:Show()
    end,
  }
end})