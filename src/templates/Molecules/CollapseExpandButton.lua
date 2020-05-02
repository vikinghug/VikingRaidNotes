local VSL = LibStub("VikingSharedLib")
local addonName = ...

local addon = _G[addonName]

local ICON_COLOR_NORMAL = {1, 1, 1, 0.25}
local ICON_COLOR_HOVER = {1, 1, 1, 1}

addon:Controller("VRNUI.CollapseButton", {
  OnClick = function(frame)
    frame:GetParent():Collapse()
    frame:GetParent().CollapseButton:Hide()
    frame:GetParent().ExpandButton:Show()
  end,

  OnEnter = function(frame)
    frame:SetIconColor(ICON_COLOR_HOVER)
  end,

  OnLeave = function(frame)
    frame:SetIconColor(ICON_COLOR_NORMAL)
  end
})

addon:Controller("VRNUI.ExpandButton", {
  OnBind = function(frame)
    frame:SetIconColor(ICON_COLOR_NORMAL)
  end,

  OnClick = function(frame)
    frame:GetParent():Expand()
    frame:GetParent().CollapseButton:Show()
    frame:GetParent().ExpandButton:Hide()
  end,

  OnEnter = function(frame)
    frame:SetIconColor(ICON_COLOR_HOVER)
  end,

  OnLeave = function(frame)
    frame:SetIconColor(ICON_COLOR_NORMAL)
  end
})