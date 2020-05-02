--[[
  TODO: THIS NEEDS TO BE CONSOLIDATED
    - services/Comm.lua
]]

local VSL = LibStub("VikingSharedLib")
local AceComm = LibStub("AceComm-3.0")
local AceSerializer = LibStub("AceSerializer-3.0")

local addonName = ...

local addon = _G[addonName]

local Comm = {}; addon.Comm = Comm;

function Comm:Register()
  AceComm:RegisterComm("VRN_NOTES_SET", self.Handler)
  AceComm:RegisterComm("VRN_NOTES_PUSH", self.Handler)
end

function Comm:Handler(text, channel, sender)
  local success, data = AceSerializer:Deserialize(text)
  if (success) then
    addon.Services.SettingsService:UpsertNotes(data)
  end
end
