local VSL = LibStub("VikingSharedLib")
local addonName = ...

local addon = _G[addonName]

addon:Controller("VRNUI.ControlButtons", {
  function()
    return {
      OnBind = function(frame)
        frame:Hide()
      end,

      Open = function(frame)
        frame.over = true
        frame:Show()
        frame:Redraw()
      end,

      Redraw = function(frame)
        frame.Sets:Redraw()
        frame.Buttons:Redraw()
      end,

      Close = function(frame)
        frame.over = false

        C_Timer.After(1.25, function()
          if frame.over == false then
            frame:Hide()
          end
        end)
      end,

      CloseNow = function(frame)
        frame.over = false
        frame:Hide()
      end
    }
  end
})

local SetsListContentMixins = function(SettingsService, CommService)
  return {
    pool = {},

    ClearPool = function(frame)
      for i,v in ipairs(frame.pool) do
        v:Hide()
        v.active = false
      end
    end,

    Update = function(frame, data)
      frame:ClearPool()

      local parent = frame
      local relativePoint = "TOPLEFT"
      local relativeY = -6
      local width = 120

      for i,v in ipairs(data) do
        local widget
        if frame.pool[i] then
          widget = frame.pool[i]
        else
          widget = CreateFrame("Button", nil, frame, "VRNListButtonTemplate")
          table.insert(frame.pool, widget)
        end

        widget.active = true
        widget.id = v.id
        widget:SetPoint("TOPLEFT", parent, relativePoint, 0, relativeY)
        relativePoint = "BOTTOMLEFT"
        relativeY = 0
        parent = widget

        widget.Text:SetText(v.name)

        if (widget.id == SettingsService:SelectedNote() or widget.id == SettingsService:SelectedSet()) then
          widget.Text:SetTextColor(VSL.Colors.YELLOW:ToList())
        else
          widget.Text:SetTextColor(1,1,1,1)
        end

        widget:Show()
        -- widget:SetScript("OnClick", OnClick)

        -- widget:SetScript("OnLeave", function(this)

        -- end)
      end

      frame:Redraw()
    end,

    Redraw = function(frame)
      local width = 120
      for i,v in ipairs(frame.pool) do
        width = math.max(v.Text:GetWidth(), width)
        v:SetWidth(width + 12)
      end

      frame:SetSize(frame:GetRealWidth(), frame:GetRealHeight())
    end,

    GetRealWidth = function(frame)
      local width = 120
      for i, v in ipairs(frame.pool) do
        if v.active == true then
          width = math.max(width, v.Text:GetStringWidth() + 20)
        end
      end
      return width
    end,

    GetRealHeight = function(frame)
      local height = 0
      for i, v in ipairs(frame.pool) do
        if v.active == true then
          height = height + v:GetHeight()
        end
      end

      return height + 12
    end,

    OnEnter = function(frame)
      local parent = frame:GetParent()
      parent.Open(parent)
    end,

    OnLeave = function(frame)
      local parent = frame:GetParent()
      parent.Close(parent)
    end,
  }
end

addon:Controller("VRNUI.SetsList", {
  "VRNUI.SettingsService",
  "VRNUI.CommService",
  function(SettingsService, CommService)
    return {
      OnBind = function(frame)
        for k, v in pairs(SetsListContentMixins(SettingsService, CommService)) do
          frame[k] = v
        end

        frame.Update(frame, SettingsService.Sets())
        frame:SetSize(
          frame:GetRealWidth(),
          frame:GetRealHeight()
        )
      end,

      OnWidgetClick = function(frame, id)
        SettingsService:SelectSet(id)
        frame:Update(SettingsService.Sets())
        frame:GetParent().Buttons:Update(SettingsService:SelectedSetButtons())
      end,
    }
  end
})

addon:Controller("VRNUI.NotesList", {
  "VRNUI.SettingsService",
  "VRNUI.CommService",
  "VRNUI.AuthService",
  function(SettingsService, CommService, AuthService)
    return {
      OnBind = function(frame)
        for k, v in pairs(SetsListContentMixins(SettingsService, CommService)) do
          frame[k] = v
        end

        frame.Update(frame, SettingsService:SelectedSetButtons())
      end,

      OnWidgetClick = function(frame, id)
        if AuthService:IsAuthorized(UnitName("player"), 2) then
          SettingsService:SelectNote(id)
          CommService:SetPlayerNotes(id)
          frame:Update(SettingsService:SelectedSetButtons())
          if (frame:GetParent().Redraw) then
            frame:GetParent():Redraw()
          end
        end
      end,
    }
  end
})

addon:Controller("VRNUI.ListButton", {
  "VRNUI.SettingsService",
  "VRNUI.FormatterService",
  function(SettingsService, FormatterService)
    return {
      OnBind = function(frame)
      end,

      OnClick = function(frame)
        frame:GetParent():OnWidgetClick(frame.id)
      end,

      OnEnter = function(frame)
        frame:GetParent():GetParent().over = true
        if (frame.id == SettingsService:SelectedNote() or frame.id == SettingsService:SelectedSet()) then
          frame.Text:SetTextColor(VSL.Colors.YELLOW:ToList())
        else
          frame.Text:SetTextColor(VSL.Colors.YELLOW:ToList(0.75))
        end

        frame:ShowTooltip()
      end,

      OnLeave = function(frame)
        frame:GetParent():GetParent().over = false
        if (frame.id == SettingsService:SelectedNote() or frame.id == SettingsService:SelectedSet()) then
          frame.Text:SetTextColor(VSL.Colors.YELLOW:ToList())
        else
          frame.Text:SetTextColor(1,1,1,1)
        end

        frame:HideTooltip()
      end,

      ShowTooltip = function(frame)
        local notes = SettingsService:GetNotesForButton(frame.id)

        GameTooltip:SetOwner(frame, "ANCHOR_BOTTOMLEFT", 5, 0)
        for i, v in ipairs(notes) do
          local channel = SettingsService:GetChannel(v.channelID)
          GameTooltip:AddLine(channel.name, 1, 1, 1, nil)
          GameTooltip:AddLine(FormatterService.ParseText(v.value), nil, nil, nil, true)
          GameTooltip:AddLine(" ")
        end
        GameTooltip:Show()
      end,

      HideTooltip = function(frame)
        GameTooltip:Hide()
      end,
    }
  end

})