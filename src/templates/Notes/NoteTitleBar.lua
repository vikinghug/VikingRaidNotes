local VSL = LibStub("VikingSharedLib")
local addonName = ...

local addon = _G[addonName]

addon:Controller("VRNUI.NoteTitleBar", function()
  return {
    OnBind = function(frame)
      -- VSL:Debug("TitleBar.OnBind:frame", frame)
    end,

    SetChannelColor = function(frame, data)
      frame.ChannelIcon.Texture:SetVertexColor(data.color.r, data.color.g, data.color.b, 0.25)
    end,
  }
end)