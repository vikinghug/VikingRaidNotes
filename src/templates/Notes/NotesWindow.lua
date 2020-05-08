local VSL = LibStub("VikingSharedLib")
local AceConfigDialog = LibStub("AceConfigDialog-3.0")

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

addon:Controller("VRNUI.NotesWindow", {
  "VRNUI.SettingsService",
  "VRNUI.AuthService",
  function(SettingsService, AuthService)
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

        frame:SetDontSavePosition(true)
        frame:SetPoint(
          "TOPRIGHT",
          UIParent,
          "BOTTOMLEFT",
          addon.db.profile.notesPosition.x,
          addon.db.profile.notesPosition.y
        )

        frame.ExpandButton:Hide()

        frame:SetNotes(addon.db.profile, SettingsService.SelectedNote())

        frame:SetClampedToScreen(true)

        frame.TitleBar:SetFrameStrata("LOW")
        frame.TitleBar:RegisterForDrag("LeftButton")

        frame.TitleBar:SetScript("OnDragStart", function()
          frame:DragStart()
        end)

        frame.TitleBar:SetScript("OnDragStop", function()
          frame:DragStop()
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

      DragStart = function(frame)
        frame:StartMoving()
      end,

      DragStop = function(frame)
        frame:StopMovingOrSizing()
        SettingsService:SaveNotesPosition(
          frame:GetRight(),
          frame:GetTop()
        )
      end,

      Collapse = function(frame)
        frame.Content:Hide()
      end,

      Expand = function(frame)
        frame.Content:Show()
      end,

      HandleVisibility = function(frame)
        if addon.db.profile.notesWindow.hide then
          frame:Hide()
        else
          frame:Show()
        end
      end,
    }
  end
})

local ICON_COLOR_NORMAL = {1, 1, 1, 0.25}
local ICON_COLOR_HOVER = {1, 1, 1, 1}

addon:Controller("VRNUI.NotesSettings", {
  "VRNUI.AuthService",
  function(AuthService)
    return {
      OnBind = function(frame)
        frame:SetFrameStrata("DIALOG")
      end,

      OnShow = function(frame)
        local player = UnitName("player")
        if not AuthService:IsAuthorized(player, addon.PERMISSIONS.NOTES_SYNC) then
          frame:Hide()
        end
      end,

      OnClick = function(frame)
        AceConfigDialog:Open("VikingRaidNotes.options2")
      end,

      OnEnter = function(frame)
        frame:SetIconColor(ICON_COLOR_HOVER)
      end,

      OnLeave = function(frame)
        frame:SetIconColor(ICON_COLOR_NORMAL)
      end
    }
  end
})

addon:Controller("VRNUI.VersionIcon", {
  "VRNUI.AuthService",
  function(AuthService)
    return {
      OnBind = function(frame)
        frame:SetFrameStrata("DIALOG")
      end,

      OnShow = function(frame)
        local player = UnitName("player")
        if not AuthService:IsAuthorized(player, addon.PERMISSIONS.NOTES_SYNC) then
          frame:Hide()
        end
      end,

      OnClick = function(frame)
        addon.Options:PlayersVersionWindow()
      end,

      OnEnter = function(frame)
        frame:SetIconColor(ICON_COLOR_HOVER)
      end,

      OnLeave = function(frame)
        frame:SetIconColor(ICON_COLOR_NORMAL)
      end
    }
  end
})

addon:Controller("VRNUI.SetsListButton", {
  "VRNUI.AuthService",
  function(AuthService)
    return {
      OnBind = function(frame)
        frame:SetFrameStrata("DIALOG")
      end,

      OnShow = function(frame)
        local parent = frame:GetParent()
        parent.TitleBar.Text:SetParent(parent.TitleBar)

        local player = UnitName("player")
        if AuthService:IsAuthorized(player, addon.PERMISSIONS.NOTES_SHOW) then


          parent.TitleBar.Text:SetPoint("LEFT", parent.TitleBar, "LEFT", 22, 0)
        else
          parent.TitleBar.Text:SetPoint("LEFT", parent.TitleBar, "LEFT", 6, 0)
          frame:Hide()
        end

        for i=1,parent.TitleBar.Text:GetNumPoints() do
          VSL:Debug("point["..i.."]", parent.TitleBar.Text:GetPoint(i))
        end
      end,

      OnClick = function(frame)
        local buttons = addon.Frame.ControlButtons
        if (buttons:IsVisible()) then
          buttons:CloseNow()
        else
          buttons:Open()
        end
      end,

      OnEnter = function(frame)
        frame:SetIconColor(ICON_COLOR_HOVER)
      end,

      OnLeave = function(frame)
        frame:SetIconColor(ICON_COLOR_NORMAL)
        addon.Frame.ControlButtons:Close()
      end
    }
  end
})