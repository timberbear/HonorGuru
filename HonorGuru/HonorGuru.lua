-- HonorGuru
local addonName, addon = ...
local L = addon.L

-- Initialize addon
local function Initialize()
    -- Create or load saved variables
    HonorGuruDB = HonorGuruDB or {
        squads = {},
        squadMembers = {},
        settings = {
            autoQueue = true,
            autoAccept = true,
            debugMode = false
        }
    }
    
    -- Print welcome message
    print(L.ADDON_LOADED)
end

-- Register initialization event
local f = CreateFrame("Frame")
f:RegisterEvent("PLAYER_LOGIN")
f:SetScript("OnEvent", function(self, event)
    Initialize()
end) 