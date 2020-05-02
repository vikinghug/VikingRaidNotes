local VSL = LibStub("VikingSharedLib")
local addonName = ...

local addon = _G[addonName]

addon:Controller("VRNUI.ScrollFrame", {
	OnBind = function(frame)
	end,

	OnShow = function(frame)
	end,

	Enable = function(frame)
		frame.ScrollBar:Enable()
	end,

	Disable = function(frame)
		frame.ScrollBar:Disable()
	end,

	ResetScroll = function(frame)
		frame.ScrollBar:SetValue(0)
	end,

	OnMouseWheel = function(frame, delta)
		local scrollBar = frame.ScrollBar
		local scrollStep = scrollBar:GetHeight() / 10

		if (delta > 0) then
			scrollBar:SetValue(scrollBar:GetValue() - scrollStep)
		else
			scrollBar:SetValue(scrollBar:GetValue() + scrollStep)
		end
	end
})