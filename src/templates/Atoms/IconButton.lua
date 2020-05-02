local VSL = LibStub("VikingSharedLib")
local addonName = ...

local addon = _G[addonName]

addon:Controller("VRNUI.IconButton", {
  OnBind = function(frame)
    if (frame.IconTexture) then
      frame:SetIconTexture(frame.IconTexture)
    end

    if (frame.Sprite) then
      frame:SetSprite(frame.Sprite)
    end

    if (frame.IconColor) then
      frame:SetIconColor({strsplit(",", frame.IconColor)})
    end
  end,

  SetIconTexture = function(frame, file)
    frame.IconTexture:SetTexture(file)
  end,

  SetSprite = function(frame, name)
    local file, coords = VSL.Sprites:GetSprite("sprites.tga", name)
    frame.IconTexture:SetTexture(file)
    frame.IconTexture:SetTexCoord(coords[1], coords[2], coords[3], coords[4])
  end,

  SetIconColor = function(frame, color)
    frame.IconTexture:SetVertexColor(unpack(color))
  end
})