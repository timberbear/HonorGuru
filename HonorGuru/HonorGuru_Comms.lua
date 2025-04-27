-- HonorGuru Communication Module
local addonName, addon = ...
local L = LibStub("AceLocale-3.0"):GetLocale("HonorGuru")

-- Communication prefix
local COMM_PREFIX = "HonorGuru"

-- Communication types
local COMM_TYPES = {
    SQUAD_JOIN = "SQUAD_JOIN",
    SQUAD_LEAVE = "SQUAD_LEAVE",
    SQUAD_STATUS = "SQUAD_STATUS",
    QUEUE_STATUS = "QUEUE_STATUS",
    DEBUFF_WARNING = "DEBUFF_WARNING",
    QUEUE_WARNING = "QUEUE_WARNING",
    HONOR_REPORT = "HONOR_REPORT",
}

-- Register communication channel
local function RegisterComm()
    local f = CreateFrame("Frame")
    f:RegisterEvent("CHAT_MSG_ADDON")
    f:SetScript("OnEvent", function(self, event, prefix, message, channel, sender)
        if prefix ~= COMM_PREFIX then return end
        
        local commType, data = strsplit(":", message, 2)
        if not commType or not data then return end
        
        -- Handle different types of communication
        if commType == COMM_TYPES.SQUAD_JOIN then
            -- Handle squad join
            local squadName, playerName = strsplit(",", data)
            if squadName and playerName then
                -- Add to squad
                if not HonorGuruDB.squads[squadName] then
                    HonorGuruDB.squads[squadName] = {}
                end
                table.insert(HonorGuruDB.squads[squadName], playerName)
                -- Update UI
                if HonorGuru_UI then
                    HonorGuru_UI:UpdateSquadList()
                end
            end
        elseif commType == COMM_TYPES.SQUAD_LEAVE then
            -- Handle squad leave
            local squadName, playerName = strsplit(",", data)
            if squadName and playerName then
                -- Remove from squad
                if HonorGuruDB.squads[squadName] then
                    for i, name in ipairs(HonorGuruDB.squads[squadName]) do
                        if name == playerName then
                            table.remove(HonorGuruDB.squads[squadName], i)
                            break
                        end
                    end
                    -- Delete squad if empty
                    if #HonorGuruDB.squads[squadName] == 0 then
                        HonorGuruDB.squads[squadName] = nil
                    end
                end
                -- Update UI
                if HonorGuru_UI then
                    HonorGuru_UI:UpdateSquadList()
                end
            end
        elseif commType == COMM_TYPES.SQUAD_STATUS then
            -- Handle squad status
            local squadName, status = strsplit(",", data)
            if squadName and status then
                -- Update squad status
                if not HonorGuruDB.squadStatus then
                    HonorGuruDB.squadStatus = {}
                end
                HonorGuruDB.squadStatus[squadName] = status
                -- Update UI
                if HonorGuru_UI then
                    HonorGuru_UI:UpdateSquadStatus()
                end
            end
        elseif commType == COMM_TYPES.QUEUE_STATUS then
            -- Handle queue status
            local status = data
            if status then
                -- Update queue status
                HonorGuruDB.queueStatus = status
                -- Update UI
                if HonorGuru_UI then
                    HonorGuru_UI:UpdateQueueStatus()
                end
            end
        elseif commType == COMM_TYPES.DEBUFF_WARNING then
            -- Handle debuff warning
            if HonorGuruDB.showDebuffWarnings then
                local debuffName = data
                if debuffName then
                    -- Show warning
                    UIErrorsFrame:AddMessage(L["WARNING"]..": "..string.format(L["DEBUFF_WARNING"], debuffName), 1.0, 0.0, 0.0)
                    -- Play sound
                    if HonorGuruDB.soundEnabled then
                        PlaySound("RaidWarning")
                    end
                end
            end
        elseif commType == COMM_TYPES.QUEUE_WARNING then
            -- Handle queue warning
            if HonorGuruDB.showQueueWarnings then
                local warning = data
                if warning then
                    -- Show warning
                    UIErrorsFrame:AddMessage(L["WARNING"]..": "..string.format(L["QUEUE_WARNING"], warning), 1.0, 0.0, 0.0)
                    -- Play sound
                    if HonorGuruDB.soundEnabled then
                        PlaySound("RaidWarning")
                    end
                end
            end
        elseif commType == COMM_TYPES.HONOR_REPORT then
            -- Handle honor report
            if HonorGuruDB.showHonorReport then
                local report = data
                if report then
                    -- Show report
                    print(string.format(L["HONOR_REPORT"], report))
                end
            end
        end
    end)
end

-- Send communication
local function SendComm(commType, data)
    if not commType or not data then return end
    SendAddonMessage(COMM_PREFIX, commType..":"..data, "RAID")
end

-- Export functions
addon.SendComm = SendComm
addon.COMM_TYPES = COMM_TYPES

-- Register communication
RegisterComm() 