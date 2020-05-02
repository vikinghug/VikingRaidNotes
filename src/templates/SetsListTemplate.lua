local VSL = LibStub("VikingSharedLib")
local addonName = ...

local addon = _G[addonName]

addon:Controller("VRNUI.SetsList", { "VRNUI.SetsService", function(SetsService)
  local pool = {}

  local function clearPool()
    for i,v in ipairs(pool) do
      v:Hide()
    end
  end

  return {
    OnBind = function(frame)
      frame:SetPoint("BOTTOMLEFT", frame:GetParent())

      local setParent = frame

      local sets = SetsService:Sets()
      for i,v in ipairs(sets) do
        local set
        if pool[i] then
          set = pool[i]
        else
          set = CreateFrame("Button", nil, setParent, "VRNListButtonTemplate")
          table.insert(pool, set)
        end

        set.id = v.id
        set:SetPoint("TOPLEFT", setParent, "BOTTOMLEFT", 0, -2)
        setParent = set

        set.Text:SetText(v.name)
        if (v.id == SetsService:SelectedSet()) then
          set.Text:SetTextColor(VSL.Colors.YELLOW:ToList())
        else
          set.Text:SetTextColor(1,1,1,1)
        end

        set:SetScript("OnClick", function(this)
          SetsService.SelectSet(v.id)
          frame:Update()
          frame:GetParent().Buttons:Update()
        end)
        set:Show()
      end
      frame:GetParent().Buttons:Update()

    end,

    Update = function(frame)
      for i, set in ipairs(pool) do
        if (set.id == SetsService:SelectedSet()) then
          set.Text:SetTextColor(VSL.Colors.YELLOW:ToList())
        else
          set.Text:SetTextColor(1,1,1,1)
        end
      end
    end,

    OnShow = function(frame)
    end,
  }
end})

addon:Controller("VRNUI.NotesList", { "VRNUI.SetsService", function(SetsService)
  local pool = {}

  local function clearPool()
    for i,v in ipairs(pool) do
      v:Hide()
    end
  end

  return {
    OnBind = function(frame)
    end,

    Update = function(frame)
      clearPool()
      frame:SetPoint("BOTTOMRIGHT", frame:GetParent())

      local parent = frame
      local notes = SetsService:SelectedSetButtons()
      for i,v in ipairs(notes) do
        local note
        if pool[i] then
          note = pool[i]
        else
          note = CreateFrame("Button", nil, parent, "VRNListButtonTemplate")
          table.insert(pool, note)
        end

        note.id = v.id
        note:SetPoint("TOPLEFT", parent, "BOTTOMLEFT", 0, -2)
        parent = note

        note.Text:SetText(v.name)
        if (note.id == SetsService:SelectedNote()) then
          note.Text:SetTextColor(VSL.Colors.YELLOW:ToList())
        else
          note.Text:SetTextColor(1,1,1,1)
        end

        note:SetScript("OnClick", function(this)
          SetsService.SelectNote(note.id)
          addon.Frame:SetNotes(note.id)
          frame:Update()
        end)
        note:Show()
      end
    end,

    OnShow = function(frame)
    end,
  }
end})
