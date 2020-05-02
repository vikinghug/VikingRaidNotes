local VSL = LibStub("VikingSharedLib")
local addonName = ...

local addon = _G[addonName]

addon:Controller("VRNUI.Note", { "VRNUI.SetsService", "VRNUI.FormatterService", function(SetsService, FormatterService)
  local TITLE_BAR_HEIGHT = 18
  local TEXT_PADDING = 6
  return {
    OnBind = function(frame)
      frame.ExpandButton:Hide()
    end,

    SetTitle = function(frame, data)
      frame.TitleBar.Text:SetText(data.name)
      frame.TitleBar:SetChannelColor(data)
      -- frame.TitleBar.Text:SetTextColor(data.color.r, data.color.g, data.color.b, data.color.a)
    end,

    SetContent = function(frame, noteData)
      if noteData ~= nil then
        frame.NoteText.Text:SetText(FormatterService.ParseText(noteData.value))

        local width, height = frame:GetNoteSize()
        if (not SetsService.GetChannel(frame.channelID).collapsed) then
          frame:SetSize(width, height)
        end

        frame:Show()
      end
    end,

    GetNoteSize = function(frame)
      local width = frame.NoteText.Text:GetStringWidth() + (TEXT_PADDING * 2)
      local height = frame.NoteText.Text:GetStringHeight() + (TITLE_BAR_HEIGHT + (TEXT_PADDING * 2))

      return width, height
    end,

    Collapse = function(frame)
      SetsService.CollapseChannel(frame.channelID)
      frame:SetHeight(TITLE_BAR_HEIGHT)
      frame.NoteText:Hide()
    end,

    Expand = function(frame)
      SetsService.ExpandChannel(frame.channelID)
      local _, height = frame:GetNoteSize()
      frame:SetHeight(height)
      frame.NoteText:Show()
    end
  }
end})