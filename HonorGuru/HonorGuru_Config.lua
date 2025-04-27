-- HonorGuru Configuration
local addonName, addon = ...
local L = LibStub("AceLocale-3.0"):GetLocale("HonorGuru")

-- Default configuration
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

-- Create configuration panel
local function CreateConfigPanel()
    local panel = CreateFrame("Frame", "HonorGuruConfigPanel", InterfaceOptionsFramePanelContainer)
    panel.name = "HonorGuru"
    
    -- Title
    local title = panel:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
    title:SetPoint("TOPLEFT", 16, -16)
    title:SetText(L["ADDON_DESCRIPTION"])
    
    -- Enable addon
    local enableCheckbox = CreateFrame("CheckButton", "HonorGuruEnableCheckbox", panel, "InterfaceOptionsCheckButtonTemplate")
    enableCheckbox:SetPoint("TOPLEFT", 16, -50)
    enableCheckbox.Text:SetText(L["ENABLE_ADDON"])
    enableCheckbox:SetScript("OnClick", function(self)
        HonorGuruDB.enabled = self:GetChecked()
    end)
    
    -- Minimum squads
    local minSquadsSlider = CreateFrame("Slider", "HonorGuruMinSquadsSlider", panel, "OptionsSliderTemplate")
    minSquadsSlider:SetPoint("TOPLEFT", 16, -90)
    minSquadsSlider:SetMinMaxValues(1, 10)
    minSquadsSlider:SetValueStep(1)
    minSquadsSlider:SetScript("OnValueChanged", function(self, value)
        HonorGuruDB.minSquads = value
        getglobal(self:GetName().."Text"):SetText(L["MIN_SQUADS"]..": "..value)
    end)
    
    -- Minimum players
    local minPlayersSlider = CreateFrame("Slider", "HonorGuruMinPlayersSlider", panel, "OptionsSliderTemplate")
    minPlayersSlider:SetPoint("TOPLEFT", 16, -130)
    minPlayersSlider:SetMinMaxValues(100, 400)
    minPlayersSlider:SetValueStep(10)
    minPlayersSlider:SetScript("OnValueChanged", function(self, value)
        HonorGuruDB.minPlayers = value
        getglobal(self:GetName().."Text"):SetText(L["MIN_PLAYERS"]..": "..value)
    end)
    
    -- Countdown notification
    local countdownCheckbox = CreateFrame("CheckButton", "HonorGuruCountdownCheckbox", panel, "InterfaceOptionsCheckButtonTemplate")
    countdownCheckbox:SetPoint("TOPLEFT", 16, -170)
    countdownCheckbox.Text:SetText(L["SHOW_COUNTDOWN"])
    countdownCheckbox:SetScript("OnClick", function(self)
        HonorGuruDB.countdownEnabled = self:GetChecked()
    end)
    
    -- Sound notification
    local soundCheckbox = CreateFrame("CheckButton", "HonorGuruSoundCheckbox", panel, "InterfaceOptionsCheckButtonTemplate")
    soundCheckbox:SetPoint("TOPLEFT", 16, -210)
    soundCheckbox.Text:SetText(L["ENABLE_SOUND"])
    soundCheckbox:SetScript("OnClick", function(self)
        HonorGuruDB.soundEnabled = self:GetChecked()
    end)
    
    -- Auto queue
    local autoQueueCheckbox = CreateFrame("CheckButton", "HonorGuruAutoQueueCheckbox", panel, "InterfaceOptionsCheckButtonTemplate")
    autoQueueCheckbox:SetPoint("TOPLEFT", 16, -250)
    autoQueueCheckbox.Text:SetText(L["AUTO_QUEUE"])
    autoQueueCheckbox:SetScript("OnClick", function(self)
        HonorGuruDB.autoQueue = self:GetChecked()
    end)
    
    -- Initialize values
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

-- Initialize configuration
local function InitializeConfig()
    -- Ensure configuration exists
    HonorGuruDB = HonorGuruDB or {}
    for k, v in pairs(defaultConfig) do
        if HonorGuruDB[k] == nil then
            HonorGuruDB[k] = v
        end
    end
    
    -- Create configuration panel
    CreateConfigPanel()
end

-- Register initialization event
local f = CreateFrame("Frame")
f:RegisterEvent("PLAYER_LOGIN")
f:SetScript("OnEvent", function(self, event)
    InitializeConfig()
end) 