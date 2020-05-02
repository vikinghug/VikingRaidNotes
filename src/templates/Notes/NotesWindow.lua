local VSL = LibStub("VikingSharedLib")
local addonName = ...

local addon = _G[addonName]

addon:Controller("VRNUI.NotesWindow", { "VRNUI.SetsService", function(SetsService)
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

      frame:SetNotes(SetsService.SelectedNote())
    end,

    SetNotes = function(frame, buttonID)
      local parent = frame

      for i, note in ipairs(pool) do
        local noteData = SetsService.GetNoteForChannel(buttonID, note.channelID)
        if (noteData ~= nil and noteData.value ~= nil and noteData.value ~= "") then
          note:SetPoint("TOPLEFT", parent, "BOTTOMLEFT", 0, -3)
          note:SetPoint("TOPRIGHT", parent, "BOTTOMRIGHT", 0, -3)
          note:SetContent(noteData)
          note:Show()
          parent = note
        else
          note:Hide()
        end

        local buttonData = SetsService.GetButton(buttonID)
        local setData = SetsService.GetSet(buttonData.setID)

        frame.TitleBar.Text:SetText(setData.short .. " - " .. buttonData.name)
      end
    end,

    Collapse = function(frame)
      frame.Content:Hide()
    end,

    Expand = function(frame)
      frame.Content:Show()
    end,
  }
end})