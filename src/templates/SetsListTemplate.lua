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
    }
  end
})

local SetsListContentMixins = function(SettingsService, CommService, OnClick)
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
        widget:SetScript("OnClick", OnClick)
        widget:SetScript("OnEnter", function(this)
          this:GetParent():GetParent().over = true
          if (widget.id == SettingsService:SelectedNote() or widget.id == SettingsService:SelectedSet()) then
            widget.Text:SetTextColor(VSL.Colors.YELLOW:ToList())
          else
            this.Text:SetTextColor(VSL.Colors.YELLOW:ToList(0.75))
          end
        end)

        widget:SetScript("OnLeave", function(this)
          this:GetParent():GetParent().over = false
          if (widget.id == SettingsService:SelectedNote() or widget.id == SettingsService:SelectedSet()) then
            widget.Text:SetTextColor(VSL.Colors.YELLOW:ToList())
          else
            widget.Text:SetTextColor(1,1,1,1)
          end
        end)
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
  }
end

addon:Controller("VRNUI.SetsList", {
  "VRNUI.SettingsService",
  "VRNUI.CommService",
  function(SettingsService, CommService)
    return {
      OnBind = function(frame)
        frame:SetScript("OnEnter", function(this)
          frame.GetParent():Open()
        end)

        frame:SetScript("OnLeave", function(this)
          frame.GetParent():Close()
        end)

        local OnClick = function(this)
          SettingsService.SelectSet(this.id)
          this:GetParent():Update(SettingsService.Sets())
          this:GetParent():GetParent().Buttons:Update(SettingsService.SelectedSetButtons())
        end

        for k, v in pairs(SetsListContentMixins(SettingsService, CommService, OnClick)) do
          frame[k] = v
        end

        frame.Update(frame, SettingsService.Sets())
        frame:SetSize(
          frame:GetRealWidth(),
          frame:GetRealHeight()
        )
      end,
    }
  end
})

addon:Controller("VRNUI.NotesList", {
  "VRNUI.SettingsService",
  "VRNUI.CommService",
  function(SettingsService, CommService)
    return {
      OnBind = function(frame)
        frame:SetScript("OnEnter", function(this)
          frame.GetParent():Open()
        end)

        frame:SetScript("OnLeave", function(this)
          frame.GetParent():Close()
        end)

        local OnClick = function(this)
          SettingsService.SelectNote(this.id)
          CommService:SetPlayerNotes(this.id)
          this:GetParent():Update(SettingsService.SelectedSetButtons())
          if (this:GetParent():GetParent().Redraw) then
            this:GetParent():GetParent():Redraw()
          end
        end

        for k, v in pairs(SetsListContentMixins(SettingsService, CommService, OnClick)) do
          frame[k] = v
        end

        frame.Update(frame, SettingsService.SelectedSetButtons())
      end,
    }
  end
})