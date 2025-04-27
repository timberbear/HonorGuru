local L = LibStub("AceLocale-3.0"):NewLocale("HonorGuru", "enUS", true)
if not L then return end

-- Info tab
L["INFO_TAB"] = "Info"
L["MAIN_TAB"] = "Queue"
L["ADDON_DESCRIPTION"] = "HonorGuru - Alterac Valley Queue Coordinator"
L["INFO_TEXT"] = [[
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
Version: 1.0.0]]

-- Main UI
L["READY"] = "Ready"
L["NOT_READY"] = "Not Ready"
L["IN_QUEUE"] = "In Queue"
L["HAS_DEBUFF"] = "Has Debuff"
L["SQUAD"] = "Squad"
L["PLAYERS"] = "Players"
L["NEXT_QUEUE"] = "Next Queue"
L["MINUTES"] = "minutes"

-- Settings
L["ENABLE_ADDON"] = "Enable Addon"
L["MIN_SQUADS"] = "Minimum Squads"
L["MIN_PLAYERS"] = "Minimum Players"
L["SHOW_COUNTDOWN"] = "Show Countdown"
L["ENABLE_SOUND"] = "Enable Sound"
L["AUTO_QUEUE"] = "Auto Queue"

-- Warnings
L["WARNING"] = "Warning"
L["DEBUFF_WARNING"] = "%s has a debuff!"
L["QUEUE_WARNING"] = "Queue warning: %s"
L["HONOR_REPORT"] = "Honor report: %s" 