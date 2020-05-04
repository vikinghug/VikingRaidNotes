local VSL = LibStub("VikingSharedLib")
local addonName = ...

local addon = _G[addonName]

local ICON_COLOR_NORMAL = {1, 1, 1, 0.25}
local ICON_COLOR_HOVER = {1, 1, 1, 1}

addon:Controller("VRNUI.CollapseButton", {
  OnBind = function(frame)
    frame:SetFrameStrata("DIALOG")
  end,

  OnClick = function(frame)
    local parent = frame:GetParent()
    parent:Collapse()
    parent.CollapseButton:Hide()
    parent.ExpandButton:Show()
    local frameLevel = parent:GetFrameLevel()
    parent:SetFrameLevel(frameLevel)
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
    frame:SetFrameStrata("HIGH")
  end,

  OnClick = function(frame)
    local parent = frame:GetParent()
    parent:Expand()
    parent.CollapseButton:Show()
    parent.ExpandButton:Hide()
    local frameLevel = parent:GetFrameLevel()
    parent:SetFrameLevel(frameLevel)
  end,

  OnEnter = function(frame)
    frame:SetIconColor(ICON_COLOR_HOVER)
  end,

  OnLeave = function(frame)
    frame:SetIconColor(ICON_COLOR_NORMAL)
  end
})