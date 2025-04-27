-- HonorGuru 通信模块
local addonName, addon = ...

-- 通信前缀
local COMM_PREFIX = "HonorGuru"

-- 通信类型
local COMM_TYPES = {
    SQUAD_JOIN = "SQUAD_JOIN",
    SQUAD_LEAVE = "SQUAD_LEAVE",
    SQUAD_STATUS = "SQUAD_STATUS",
    QUEUE_STATUS = "QUEUE_STATUS",
    DEBUFF_WARNING = "DEBUFF_WARNING",
    QUEUE_WARNING = "QUEUE_WARNING",
    HONOR_REPORT = "HONOR_REPORT",
}

-- 注册通信频道
local function RegisterComm()
    local f = CreateFrame("Frame")
    f:RegisterEvent("CHAT_MSG_ADDON")
    f:SetScript("OnEvent", function(self, event, prefix, message, channel, sender)
        if prefix ~= COMM_PREFIX then return end
        
        local commType, data = strsplit(":", message, 2)
        if not commType or not data then return end
        
        -- 处理不同类型的通信
        if commType == COMM_TYPES.SQUAD_JOIN then
            -- 处理加入小队
            local squadName, playerName = strsplit(",", data)
            if squadName and playerName then
                -- 添加到小队
                if not HonorGuruDB.squads[squadName] then
                    HonorGuruDB.squads[squadName] = {}
                end
                table.insert(HonorGuruDB.squads[squadName], playerName)
                -- 更新UI
                if HonorGuru_UI then
                    HonorGuru_UI:UpdateSquadList()
                end
            end
        elseif commType == COMM_TYPES.SQUAD_LEAVE then
            -- 处理离开小队
            local squadName, playerName = strsplit(",", data)
            if squadName and playerName then
                -- 从小队中移除
                if HonorGuruDB.squads[squadName] then
                    for i, name in ipairs(HonorGuruDB.squads[squadName]) do
                        if name == playerName then
                            table.remove(HonorGuruDB.squads[squadName], i)
                            break
                        end
                    end
                    -- 如果小队为空，删除小队
                    if #HonorGuruDB.squads[squadName] == 0 then
                        HonorGuruDB.squads[squadName] = nil
                    end
                end
                -- 更新UI
                if HonorGuru_UI then
                    HonorGuru_UI:UpdateSquadList()
                end
            end
        elseif commType == COMM_TYPES.SQUAD_STATUS then
            -- 处理小队状态
            local squadName, status = strsplit(",", data)
            if squadName and status then
                -- 更新小队状态
                if not HonorGuruDB.squadStatus then
                    HonorGuruDB.squadStatus = {}
                end
                HonorGuruDB.squadStatus[squadName] = status
                -- 更新UI
                if HonorGuru_UI then
                    HonorGuru_UI:UpdateSquadStatus()
                end
            end
        elseif commType == COMM_TYPES.QUEUE_STATUS then
            -- 处理排队状态
            local status = data
            if status then
                -- 更新排队状态
                HonorGuruDB.queueStatus = status
                -- 更新UI
                if HonorGuru_UI then
                    HonorGuru_UI:UpdateQueueStatus()
                end
            end
        elseif commType == COMM_TYPES.DEBUFF_WARNING then
            -- 处理减益效果警告
            if HonorGuruDB.showDebuffWarnings then
                local debuffName = data
                if debuffName then
                    -- 显示警告
                    UIErrorsFrame:AddMessage("警告: "..debuffName.." 减益效果！", 1.0, 0.0, 0.0)
                    -- 播放声音
                    if HonorGuruDB.soundEnabled then
                        PlaySound("RaidWarning")
                    end
                end
            end
        elseif commType == COMM_TYPES.QUEUE_WARNING then
            -- 处理排队警告
            if HonorGuruDB.showQueueWarnings then
                local warning = data
                if warning then
                    -- 显示警告
                    UIErrorsFrame:AddMessage("警告: "..warning, 1.0, 0.0, 0.0)
                    -- 播放声音
                    if HonorGuruDB.soundEnabled then
                        PlaySound("RaidWarning")
                    end
                end
            end
        elseif commType == COMM_TYPES.HONOR_REPORT then
            -- 处理荣誉报告
            if HonorGuruDB.showHonorReport then
                local report = data
                if report then
                    -- 显示报告
                    print("荣誉报告: "..report)
                end
            end
        end
    end)
end

-- 发送通信
local function SendComm(commType, data)
    if not commType or not data then return end
    SendAddonMessage(COMM_PREFIX, commType..":"..data, "RAID")
end

-- 导出函数
addon.SendComm = SendComm
addon.COMM_TYPES = COMM_TYPES

-- 注册通信
RegisterComm() 