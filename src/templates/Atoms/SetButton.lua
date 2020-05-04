local VSL = LibStub("VikingSharedLib")
local addonName = ...

local addon = _G[addonName]

addon:Controller("VRNUI.SetButton", { "VRNUI.SettingsService", function(SettingsService)
  return {
    OnBind = function(frame)
    end,

    SetLabel = function(frame, text)
      frame.Label:SetText(text)
    end,

    Update = function(frame, id)
      local set = SettingsService:GetSet(id)
      frame:SetLabel(set.name)
    end
  }
end})