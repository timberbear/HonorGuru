local L = LibStub("AceLocale-3.0"):NewLocale("HonorGuru", "zhCN")
if not L then return end

-- Info tab
L["INFO_TAB"] = "信息"
L["MAIN_TAB"] = "排队"
L["ADDON_DESCRIPTION"] = "HonorGuru - 奥特兰克山谷排队助手"
L["INFO_TEXT"] = [[
HonorGuru 是一个帮助大型团队协调奥山战场排队的插件。

主要功能：
- 监控小队状态和准备情况
- 追踪影响排队的减益效果
- 协调排队时间
- 自动排队支持
- 重要事件声音提醒

|cFFFF0000重要提示：|r
主要排队界面只会在与奥特兰克山谷战场军官对话时显示。

常用命令：
/hg - 显示所有命令
/hg ready - 标记自己准备就绪
/hg status - 显示当前状态
/hg config - 打开设置

作者：Your Name
版本：1.0.0]]

-- Main UI
L["READY"] = "已准备"
L["NOT_READY"] = "未准备"
L["IN_QUEUE"] = "排队中"
L["HAS_DEBUFF"] = "有减益"
L["SQUAD"] = "小队"
L["PLAYERS"] = "玩家"
L["NEXT_QUEUE"] = "下次排队"
L["MINUTES"] = "分钟"

-- Settings
L["ENABLE_ADDON"] = "启用插件"
L["MIN_SQUADS"] = "最小小队数量"
L["MIN_PLAYERS"] = "最小玩家数量"
L["SHOW_COUNTDOWN"] = "显示倒计时"
L["ENABLE_SOUND"] = "启用声音"
L["AUTO_QUEUE"] = "自动排队"

-- Warnings
L["WARNING"] = "警告"
L["DEBUFF_WARNING"] = "%s 有减益效果！"
L["QUEUE_WARNING"] = "排队警告：%s"
L["HONOR_REPORT"] = "荣誉报告：%s" 