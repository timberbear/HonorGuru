-- HonorGuru 配置
local addonName, addon = ...

-- 默认配置
local defaultConfig = {
    enabled = true,
    minSquads = 4,
    minPlayers = 200,
    countdownEnabled = true,
    soundEnabled = true,
    autoQueue = false,
    showDebuffWarnings = true,
    showQueueWarnings = true,
    showHonorReport = true,
    queueCooldown = 300,
    debuffCheckInterval = 5,
}

-- 创建配置面板
local function CreateConfigPanel()
    local panel = CreateFrame("Frame", "HonorGuruConfigPanel", InterfaceOptionsFramePanelContainer)
    panel.name = "HonorGuru"
    
    -- 标题
    local title = panel:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
    title:SetPoint("TOPLEFT", 16, -16)
    title:SetText("HonorGuru 设置")
    
    -- 启用插件
    local enableCheckbox = CreateFrame("CheckButton", "HonorGuruEnableCheckbox", panel, "InterfaceOptionsCheckButtonTemplate")
    enableCheckbox:SetPoint("TOPLEFT", 16, -50)
    enableCheckbox.Text:SetText("启用插件")
    enableCheckbox:SetScript("OnClick", function(self)
        HonorGuruDB.enabled = self:GetChecked()
    end)
    
    -- 最小小队数量
    local minSquadsSlider = CreateFrame("Slider", "HonorGuruMinSquadsSlider", panel, "OptionsSliderTemplate")
    minSquadsSlider:SetPoint("TOPLEFT", 16, -90)
    minSquadsSlider:SetMinMaxValues(1, 10)
    minSquadsSlider:SetValueStep(1)
    minSquadsSlider:SetScript("OnValueChanged", function(self, value)
        HonorGuruDB.minSquads = value
        getglobal(self:GetName().."Text"):SetText("最小小队数量: "..value)
    end)
    
    -- 最小玩家数量
    local minPlayersSlider = CreateFrame("Slider", "HonorGuruMinPlayersSlider", panel, "OptionsSliderTemplate")
    minPlayersSlider:SetPoint("TOPLEFT", 16, -130)
    minPlayersSlider:SetMinMaxValues(100, 400)
    minPlayersSlider:SetValueStep(10)
    minPlayersSlider:SetScript("OnValueChanged", function(self, value)
        HonorGuruDB.minPlayers = value
        getglobal(self:GetName().."Text"):SetText("最小玩家数量: "..value)
    end)
    
    -- 倒计时提示
    local countdownCheckbox = CreateFrame("CheckButton", "HonorGuruCountdownCheckbox", panel, "InterfaceOptionsCheckButtonTemplate")
    countdownCheckbox:SetPoint("TOPLEFT", 16, -170)
    countdownCheckbox.Text:SetText("显示倒计时提示")
    countdownCheckbox:SetScript("OnClick", function(self)
        HonorGuruDB.countdownEnabled = self:GetChecked()
    end)
    
    -- 声音提示
    local soundCheckbox = CreateFrame("CheckButton", "HonorGuruSoundCheckbox", panel, "InterfaceOptionsCheckButtonTemplate")
    soundCheckbox:SetPoint("TOPLEFT", 16, -210)
    soundCheckbox.Text:SetText("启用声音提示")
    soundCheckbox:SetScript("OnClick", function(self)
        HonorGuruDB.soundEnabled = self:GetChecked()
    end)
    
    -- 自动排队
    local autoQueueCheckbox = CreateFrame("CheckButton", "HonorGuruAutoQueueCheckbox", panel, "InterfaceOptionsCheckButtonTemplate")
    autoQueueCheckbox:SetPoint("TOPLEFT", 16, -250)
    autoQueueCheckbox.Text:SetText("自动排队")
    autoQueueCheckbox:SetScript("OnClick", function(self)
        HonorGuruDB.autoQueue = self:GetChecked()
    end)
    
    -- 初始化值
    function panel.refresh()
        enableCheckbox:SetChecked(HonorGuruDB.enabled)
        minSquadsSlider:SetValue(HonorGuruDB.minSquads)
        minPlayersSlider:SetValue(HonorGuruDB.minPlayers)
        countdownCheckbox:SetChecked(HonorGuruDB.countdownEnabled)
        soundCheckbox:SetChecked(HonorGuruDB.soundEnabled)
        autoQueueCheckbox:SetChecked(HonorGuruDB.autoQueue)
    end
    
    InterfaceOptions_AddCategory(panel)
end

-- 初始化配置
local function InitializeConfig()
    -- 确保配置存在
    HonorGuruDB = HonorGuruDB or {}
    for k, v in pairs(defaultConfig) do
        if HonorGuruDB[k] == nil then
            HonorGuruDB[k] = v
        end
    end
    
    -- 创建配置面板
    CreateConfigPanel()
end

-- 注册初始化事件
local f = CreateFrame("Frame")
f:RegisterEvent("PLAYER_LOGIN")
f:SetScript("OnEvent", function(self, event)
    InitializeConfig()
end) 