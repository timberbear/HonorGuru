-- HonorGuru UI
local addonName, addon = ...
local L = LibStub("AceLocale-3.0"):GetLocale("HonorGuru")

-- 主窗口
local mainFrame = nil
local isNPCOpen = false

-- 创建主窗口
local function CreateMainFrame()
    local frame = CreateFrame("Frame", "HonorGuruFrame", UIParent, "BasicFrameTemplate")
    frame:SetSize(300, 400)
    frame:SetPoint("CENTER")
    frame:SetMovable(true)
    frame:EnableMouse(true)
    frame:RegisterForDrag("LeftButton")
    frame:SetScript("OnDragStart", frame.StartMoving)
    frame:SetScript("OnDragStop", frame.StopMovingOrSizing)
    frame:Hide()
    
    -- 标题
    frame.title = frame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    frame.title:SetPoint("TOP", 0, -5)
    frame.title:SetText(L["ADDON_DESCRIPTION"])
    
    -- 关闭按钮
    frame.closeButton = CreateFrame("Button", nil, frame, "UIPanelCloseButton")
    frame.closeButton:SetPoint("TOPRIGHT", -5, -5)
    
    -- 创建标签页
    frame.tabs = {}
    frame.tabFrames = {}
    
    -- 信息标签页
    local infoTab = CreateFrame("Button", "HonorGuruInfoTab", frame, "CharacterFrameTabButtonTemplate")
    infoTab:SetPoint("TOPLEFT", frame, "BOTTOMLEFT", 5, 0)
    infoTab:SetText(L["INFO_TAB"])
    frame.tabs[1] = infoTab
    
    local infoFrame = CreateFrame("Frame", nil, frame)
    infoFrame:SetPoint("TOPLEFT", 10, -30)
    infoFrame:SetPoint("BOTTOMRIGHT", -10, 10)
    
    local infoText = infoFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    infoText:SetPoint("TOPLEFT")
    infoText:SetPoint("BOTTOMRIGHT")
    infoText:SetText(L["INFO_TEXT"])
    infoText:SetJustifyH("LEFT")
    infoText:SetJustifyV("TOP")
    infoText:SetSpacing(2)
    frame.tabFrames[1] = infoFrame
    
    -- 排队标签页
    local queueTab = CreateFrame("Button", "HonorGuruQueueTab", frame, "CharacterFrameTabButtonTemplate")
    queueTab:SetPoint("LEFT", infoTab, "RIGHT", -15, 0)
    queueTab:SetText(L["MAIN_TAB"])
    frame.tabs[2] = queueTab
    
    local queueFrame = CreateFrame("Frame", nil, frame)
    queueFrame:SetPoint("TOPLEFT", 10, -30)
    queueFrame:SetPoint("BOTTOMRIGHT", -10, 10)
    
    -- 小队列表
    queueFrame.squadList = CreateFrame("ScrollFrame", "HonorGuruSquadList", queueFrame, "UIPanelScrollFrameTemplate")
    queueFrame.squadList:SetPoint("TOPLEFT", 0, 0)
    queueFrame.squadList:SetPoint("BOTTOMRIGHT", 0, 0)
    
    queueFrame.squadList.content = CreateFrame("Frame", "HonorGuruSquadListContent", queueFrame.squadList)
    queueFrame.squadList.content:SetSize(280, 360)
    queueFrame.squadList:SetScrollChild(queueFrame.squadList.content)
    frame.tabFrames[2] = queueFrame
    
    -- 标签页点击事件
    local function OnTabClick(tab)
        PanelTemplates_SetTab(frame, tab:GetID())
        for i, tabFrame in ipairs(frame.tabFrames) do
            if i == tab:GetID() then
                tabFrame:Show()
            else
                tabFrame:Hide()
            end
        end
    end
    
    infoTab:SetID(1)
    queueTab:SetID(2)
    infoTab:SetScript("OnClick", function(self) OnTabClick(self) end)
    queueTab:SetScript("OnClick", function(self) OnTabClick(self) end)
    
    -- 初始显示信息标签页
    OnTabClick(infoTab)
    PanelTemplates_SetNumTabs(frame, 2)
    
    return frame
end

-- 更新小队列表
function UpdateSquadList()
    if not mainFrame or not mainFrame.tabFrames[2].squadList then return end
    
    local content = mainFrame.tabFrames[2].squadList.content
    -- 清除现有内容
    for i = 1, #content do
        if content[i] then
            content[i]:Hide()
        end
    end
    
    -- 添加小队
    local yOffset = 0
    for squadName, members in pairs(HonorGuruDB.squads or {}) do
        -- 创建小队标题
        local squadTitle = content:CreateFontString(nil, "OVERLAY", "GameFontNormal")
        squadTitle:SetPoint("TOPLEFT", 5, -yOffset)
        squadTitle:SetText(L["SQUAD"]..": "..squadName)
        
        yOffset = yOffset + 20
        
        -- 添加成员
        for _, memberName in ipairs(members) do
            local memberText = content:CreateFontString(nil, "OVERLAY", "GameFontNormal")
            memberText:SetPoint("TOPLEFT", 15, -yOffset)
            local status = ""
            if HonorGuruDB.squadMembers[memberName] then
                if HonorGuruDB.squadMembers[memberName].ready then
                    status = " ("..L["READY"]..")"
                elseif HonorGuruDB.squadMembers[memberName].hasDebuff then
                    status = " ("..L["HAS_DEBUFF"]..")"
                elseif HonorGuruDB.squadMembers[memberName].inQueue then
                    status = " ("..L["IN_QUEUE"]..")"
                else
                    status = " ("..L["NOT_READY"]..")"
                end
            end
            memberText:SetText(memberName..status)
            
            yOffset = yOffset + 20
        end
        
        yOffset = yOffset + 10
    end
    
    -- 更新滚动区域大小
    content:SetHeight(math.max(yOffset, 360))
end

-- 更新小队状态
function UpdateSquadStatus()
    if not mainFrame then return end
    UpdateSquadList()
end

-- 更新排队状态
function UpdateQueueStatus()
    if not mainFrame then return end
    UpdateSquadList()
end

-- 检查是否正在与战场军官对话
local function CheckNPCInteraction()
    if not mainFrame then return end
    
    -- 检查目标是否是战场军官
    if UnitExists("target") and UnitGUID("target") then
        local _, _, _, _, _, npcID = strsplit("-", UnitGUID("target"))
        if npcID == "13257" then -- 奥山战场军官的NPC ID
            isNPCOpen = true
            mainFrame:Show()
            return
        end
    end
    
    isNPCOpen = false
    mainFrame:Hide()
end

-- 初始化UI
local function InitializeUI()
    -- 创建主窗口
    mainFrame = CreateMainFrame()
    
    -- 注册事件
    local eventFrame = CreateFrame("Frame")
    eventFrame:RegisterEvent("GROUP_ROSTER_UPDATE")
    eventFrame:RegisterEvent("CHAT_MSG_ADDON")
    eventFrame:RegisterEvent("PLAYER_TARGET_CHANGED")
    
    eventFrame:SetScript("OnEvent", function(self, event, ...)
        if event == "GROUP_ROSTER_UPDATE" then
            UpdateSquadList()
        elseif event == "CHAT_MSG_ADDON" then
            local prefix, message = ...
            if prefix == "HonorGuru" then
                UpdateSquadStatus()
                UpdateQueueStatus()
            end
        elseif event == "PLAYER_TARGET_CHANGED" then
            CheckNPCInteraction()
        end
    end)
    
    -- 初始更新
    UpdateSquadList()
    UpdateSquadStatus()
    UpdateQueueStatus()
end

-- 注册初始化事件
local f = CreateFrame("Frame")
f:RegisterEvent("PLAYER_LOGIN")
f:SetScript("OnEvent", function(self, event)
    InitializeUI()
end) 