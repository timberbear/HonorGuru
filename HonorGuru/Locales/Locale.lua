-- Simple localization system
local addonName, addon = ...

-- Default locale (English)
local defaultLocale = {
    -- Info tab
    INFO_TAB = "Info",
    MAIN_TAB = "Queue",
    ADDON_DESCRIPTION = "HonorGuru - Alterac Valley Queue Coordinator",
    INFO_TEXT = [[
HonorGuru helps coordinate large groups queuing for Alterac Valley battleground.

Key Features:
- Monitor squad status and readiness
- Track debuffs that prevent queuing
- Coordinate queue timing
- Auto-queue support
- Sound alerts for important events

|cFFFF0000Important:|r
The main queue interface will only show up when you interact with the Alterac Valley battlemaster NPC.

Commands:
/hg - Show all commands
/hg ready - Mark yourself as ready
/hg status - Show current status
/hg config - Open settings

Created by: Your Name
Version: 1.0.0]],

    -- Main UI
    READY = "Ready",
    NOT_READY = "Not Ready",
    IN_QUEUE = "In Queue",
    HAS_DEBUFF = "Has Debuff",
    SQUAD = "Squad",
    PLAYERS = "Players",
    NEXT_QUEUE = "Next Queue",
    MINUTES = "minutes",

    -- Settings
    ENABLE_ADDON = "Enable Addon",
    MIN_SQUADS = "Minimum Squads",
    MIN_PLAYERS = "Minimum Players",
    SHOW_COUNTDOWN = "Show Countdown",
    ENABLE_SOUND = "Enable Sound",
    AUTO_QUEUE = "Auto Queue",
    CONFIG_AUTO_ACCEPT = "Auto Accept",
    CONFIG_DEBUG_MODE = "Debug Mode",
    CONFIG_TITLE = "HonorGuru Settings",

    -- Warnings
    WARNING = "Warning",
    DEBUFF_WARNING = "%s has a debuff!",
    QUEUE_WARNING = "Queue warning: %s",
    HONOR_REPORT = "Honor report: %s"
}

-- Get current locale based on game client
local function GetLocale()
    return defaultLocale
end

-- Export locale
addon.L = GetLocale() 