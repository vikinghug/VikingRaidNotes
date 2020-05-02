-- local frameHolder;

-- -- create the frame that will hold all other frames/objects:
-- local self = frameHolder or CreateFrame("Frame", nil, UIParent); -- re-size this to whatever size you wish your ScrollFrame to be, at this point

-- -- now create the template Scroll Frame (this frame must be given a name so that it can be looked up via the _G function (you'll see why later on in the code)
-- self.scrollframe = self.scrollframe or CreateFrame("ScrollFrame", "ANewScrollFrame", self, "UIPanelScrollFrameTemplate");

-- -- create the standard frame which will eventually become the Scroll Frame's scrollchild
-- -- importantly, each Scroll Frame can have only ONE scrollchild
-- self.scrollchild = self.scrollchild or CreateFrame("Frame"); -- not sure what happens if you do, but to be safe, don't parent this yet (or do anything with it)

-- -- define the scrollframe's objects/elements:
-- local scrollbarName = self.scrollframe:GetName()
-- self.scrollbar = _G[scrollbarName.."ScrollBar"];
-- self.ScrollUpButton = _G[scrollbarName.."ScrollBarScrollUpButton"];
-- self.ScrollDownButton = _G[scrollbarName.."ScrollBarScrollDownButton"];

-- -- all of these objects will need to be re-anchored (if not, they appear outside the frame and about 30 pixels too high)
-- self.ScrollUpButton:ClearAllPoints();
-- self.ScrollUpButton:SetPoint("TOPRIGHT", self.scrollframe, "TOPRIGHT", -2, -2);

-- self.ScrollDownButton:ClearAllPoints();
-- self.ScrollDownButton:SetPoint("BOTTOMRIGHT", self.scrollframe, "BOTTOMRIGHT", -2, 2);

-- self.scrollbar:ClearAllPoints();
-- self.scrollbar:SetPoint("TOP", self.ScrollUpButton, "BOTTOM", 0, -2);
-- self.scrollbar:SetPoint("BOTTOM", self.ScrollDownButton, "TOP", 0, 2);

-- -- now officially set the scrollchild as your Scroll Frame's scrollchild (this also parents self.scrollchild to self.scrollframe)
-- -- IT IS IMPORTANT TO ENSURE THAT YOU SET THE SCROLLCHILD'S SIZE AFTER REGISTERING IT AS A SCROLLCHILD:
-- self.scrollframe:SetScrollChild(self.scrollchild);

-- -- set self.scrollframe points to the first frame that you created (in this case, self)
-- self.scrollframe:SetAllPoints(self);

-- -- now that SetScrollChild has been defined, you are safe to define your scrollchild's size. Would make sense to make it's height > scrollframe's height,
-- -- otherwise there's no point having a scrollframe!
-- -- note: you may need to define your scrollchild's height later on by calculating the combined height of the content that the scrollchild's child holds.
-- -- (see the bit below about showing content).
-- self.scrollchild:SetSize(self.scrollframe:GetWidth(), ( self.scrollframe:GetHeight() * 2 ));


-- -- THE SCROLLFRAME IS COMPLETE AT THIS POINT.  THE CODE BELOW DEMONSTRATES HOW TO SHOW DATA ON IT.


-- -- you need yet another frame which will be used to parent your widgets etc to.  This is the frame which will actually be seen within the Scroll Frame
-- -- It is parented to the scrollchild.  I like to think of scrollchild as a sort of 'pin-board' that you can 'pin' a piece of paper to (or take it back off)
-- self.moduleoptions = self.moduleoptions or CreateFrame("Frame", nil, self.scrollchild);
-- self.moduleoptions:SetAllPoints(self.scrollchild);

-- -- a good way to immediately demonstrate the new scrollframe in action is to do the following...

-- -- create a fontstring or a texture or something like that, then place it at the bottom of the frame that holds your info (in this case self.moduleoptions)
-- self.moduleoptions.fontstring:SetText("This is a test.");
-- self.moduleoptions.fontstring:SetPoint("BOTTOMLEFT", self.moduleoptions, "BOTTOMLEFT", 20, 60);

-- -- you should now need to scroll down to see the text "This is a test."
local VSL = LibStub("VikingSharedLib")
local addonName = ...

local addon = _G[addonName]

-- local VRNScrollFrame = {}; addon.VRNScrollFrame = VRNScrollFrame;

-- function VRNScrollFrame:OnLoad()
-- 	print("@@@@@@@@@@@@@@@@@@ OnLoad", self)
-- end

addon:Controller("VRNUI.ScrollFrame", {
	OnBind = function(frame)
		VSL:Debug("OnBind", frame)
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

		VSL:Debug("OnMouseWheel", scrollBar:GetValue())

		if (delta > 0) then
			scrollBar:SetValue(scrollBar:GetValue() - scrollStep)
		else
			scrollBar:SetValue(scrollBar:GetValue() + scrollStep)
		end
	end
})