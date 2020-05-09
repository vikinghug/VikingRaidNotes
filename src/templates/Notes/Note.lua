local VSL = LibStub("VikingSharedLib")
local addonName = ...

local addon = _G[addonName]

addon:Controller("VRNUI.Note", { "VRNUI.SettingsService", "VRNUI.FormatterService", function(SettingsService, FormatterService)
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

        if (not SettingsService:GetChannel(frame.channelID).collapsed) then
          local _, height = frame:GetNoteSize()
          frame:SetHeight(height)
        end

        frame:Show()
      end
    end,

    GetNoteSize = function(frame)
      local text = frame.NoteText.Text

      local width = text:GetWidth() + (TEXT_PADDING * 2)
      local height = text:GetHeight() + (TITLE_BAR_HEIGHT + (TEXT_PADDING * 2))

      return width, height
    end,

    Collapse = function(frame)
      SettingsService:CollapseChannel(frame.channelID)
      frame:SetHeight(TITLE_BAR_HEIGHT)
      frame.NoteText:Hide()
    end,

    Expand = function(frame)
      SettingsService:ExpandChannel(frame.channelID)
      local _, height = frame:GetNoteSize()
      frame:SetHeight(height)
      frame.NoteText:Show()
    end
  }
end})