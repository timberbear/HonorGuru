-- HonorGuru Communication
local addonName, addon = ...
local L = addon.L

-- Register addon message prefix
local prefix = "HonorGuru"
local comms = CreateFrame("Frame")
comms:RegisterEvent("CHAT_MSG_ADDON")
comms:SetScript("OnEvent", function(self, event, prefix, message, channel, sender)
    if prefix ~= addonName then return end
    if sender == UnitName("player") then return end
    
    -- Parse message
    local command, data = strsplit(":", message)
    
    if command == "SQUAD_UPDATE" then
        -- Update squad data
        local squadData = {strsplit(",", data)}
        addon:UpdateSquad(sender, squadData)
    elseif command == "QUEUE_STATUS" then
        -- Update queue status
        local status = tonumber(data)
        addon:UpdateQueueStatus(sender, status)
    end
end)

-- Send squad update
function addon:SendSquadUpdate()
    if not IsInGroup() then return end
    
    local message = "SQUAD_UPDATE:"
    local squadData = {}
    
    -- Collect squad data
    for i = 1, GetNumGroupMembers() do
        local name, _, _, _, _, _, _, _, _, _, _, role = GetRaidRosterInfo(i)
        if name then
            table.insert(squadData, name..":"..(role or "NONE"))
        end
    end
    
    message = message..table.concat(squadData, ",")
    
    -- Send to group
    if IsInRaid() then
        SendAddonMessage(addonName, message, "RAID")
    else
        SendAddonMessage(addonName, message, "PARTY")
    end
end

-- Send queue status
function addon:SendQueueStatus(status)
    if not IsInGroup() then return end
    
    local message = "QUEUE_STATUS:"..status
    
    -- Send to group
    if IsInRaid() then
        SendAddonMessage(addonName, message, "RAID")
    else
        SendAddonMessage(addonName, message, "PARTY")
    end
end

-- Initialize comms
local f = CreateFrame("Frame")
f:RegisterEvent("PLAYER_LOGIN")
f:SetScript("OnEvent", function(self, event)
    RegisterAddonMessagePrefix(addonName)
end) 