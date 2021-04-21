Statistically = {
	TITLE = "Statistically",	-- Not codereview friendly but enduser friendly version of the add-on's name
	AUTHOR = "Ek1",
	DESCRIPTION = "Never tell me the odds.",
	VERSION = "34.210421",
	LICENSE = "BY-SA = Creative Commons Attribution-ShareAlike 4.0 International License",
}
local ADDON = "Statistically"	-- Variable used to refer to this add-on. Codereview friendly.

local Settings = {
	["Quest"] = true,
	["Loot"] = true,
	["Event"] = true,
} 
Session = {}

Crafting = {}

local EVENTLOOT = {
	-- W03	Undaunted Celebration
	[156679] = 2,	-- Undaunted Reward Box
	[156717] = 1,	-- Hefty Undaunted Reward Box
	[171267] = 2,	-- Undaunted Reward Box
	[171268] = 1, -- Glorious Undaunted Reward Box

	-- W04	Midyear Mayhem
	[121526] = 2,	-- Pelinal's Midyear Boon Box
	[171535] = 2, -- Pelinal's Midyear Boon Box 2021-01-28
	--|H1:item:171535:124:1:0:0:0:0:0:0:0:0:0:0:0:1:0:0:1:0:0:0|h|h

	-- W07	Murkmire Celebration

	-- W08	Tribunal Celebration
	[171476] = 2,	-- Tribunal Coffer
	[171480] = 1,	-- Glorious Tribunal Coffer

	-- W09	Thieves Guild and Dark Brotherhood Celebration

	-- W12	Jester's Festival
	[171731] = 1,	-- Stupendous Jester's Festival Box
	[171732] = 2,	-- Jester's Festival Box

	-- W13	(4th April) 	Anniversary Jubilee
	[171779] = 2,	-- 7th Anniversary Jubilee Gift Box

	-- W18	Vampire Week

	-- W25	Midyear Mayhem

	-- W29	Summerset Celebration

	-- W31	Orsinium Celebration

	-- W35	Imperial City Celebration

	-- W38	Lost treasures of Skyrim
  [167226] = 1,	-- Box of Gray Host Pillage
	[167227] = 2,	-- Bulging Box of Gray Host Pillage
	
	-- W42	Witches Festival
	[167234] = 2,	-- Plunder Skull
	[167235] = 1,	-- Dremora Plunder Skull, Arena
	[167236] = 1,	-- Dremora Plunder Skull, Insurgent
	[167237] = 1,	-- Dremora Plunder Skull, Delve
	[167238] = 1,	-- Dremora Plunder Skull, Dungeon
	[167239] = 1,	-- Dremora Plunder Skull, Public & Sweeper
	[167240] = 1,	-- Dremora Plunder Skull, Trial
	[167241] = 1,	-- Dremora Plunder Skull, World
	
	-- w50	New Life Festival
	[141823] = 2,	-- New Life Festival Box
	[171327] = 2,	-- New Life Festival Box 2020
	[159463] = 1,	-- Stupendous Jester's Festival Box 2020
}

local EVENTQUESTIDS = {
	[5811] = 1,	-- Snow Bear Plunge
	[5835] = 1,	-- The Trial of Five-Clawed Guile
	[5837] = 1,	-- Lava Foot Stomp
	[5838] = 1,	-- Mud Ball Merriment
	[5839] = 1,	-- Signal Fire Sprint
	[5845] = 1,	-- Castle Charm Challenge
	[5855] = 1,	-- Fish Boon Feast
	[5856] = 1,	-- Stonetooth Bash
	[6134] = 1,	-- The New Life Festival
	[6588] = 1,	-- Old Life Observance

	--	Jester's Festival
	[5921] = 1,	-- Springtime Flair
	[5931] = 1,	-- A Noble Guest
	[5937] = 1,	-- Royal Revelry
	[5941] = 1,	-- The Jester's Festival
	[6622] = 1,	-- A Foe Most Porcine
	[6632] = 1,	-- The King's Spoils
	[6640] = 1,	-- Prankster's Carnival
}

local WRITQUESTIDS = {
	--	Writs that can give alloys/tannin/resin/plating as rewards and need visiting to table
	[5368] = "Blacksmith Writ",
	[5377] = "Blacksmith Writ",
	[5392] = "Blacksmith Writ",
	[5374] = "Clothier Writ",
	[5388] = "Clothier Writ",
	[5389] = "Clothier Writ",
	[5400] = "Enchanter Writ",
	[5406] = "Enchanter Writ",
	[5407] = "Enchanter Writ",
	[6228] = "Jewelry Crafting Writ",
	[6218] = "Jewelry Crafting Writ",
	[6227] = "Jewelry Crafting Writ",
	[5394] = "Woodworker Writ",
	[5395] = "Woodworker Writ",
	[5396] = "Woodworker Writ",

-- Following ones can be completed by having stack in bank
	[5409] = "Provisioner Writ",
	[5412] = "Provisioner Writ",
	[5413] = "Provisioner Writ",
	[5414] = "Provisioner Writ",
	[5415] = "Alchemist Writ",
	[5416] = "Alchemist Writ",
	[5417] = "Alchemist Writ",
	[5418] = "Alchemist Writ",
	[6098] = "Alchemist Writ",
	[6099] = "Alchemist Writ",
	[6100] = "Alchemist Writ",
	[6101] = "Alchemist Writ",
	[6102] = "Alchemist Writ",
	[6103] = "Alchemist Writ",
	[6104] = "Alchemist Writ",
	[6105] = "Alchemist Writ",
}

StatisticallyEvent = {}

-- 100034	EVENT_LOOT_RECEIVED (number eventCode, string receivedBy, string itemName, number quantity, ItemUISoundCategory soundCategory, LootItemType lootType, boolean self, boolean isPickpocketLoot, string questItemIcon, number itemId, boolean isStolen)
function Statistically.EVENT_LOOT_RECEIVED(eventCode, receivedBy, itemName, quantity, ItemUISoundCategory, LootItemType, lootedByPlayer, questItemIcon, questItemIcon, StringitemId, isStolen)
	if not lootedByPlayer then return end	-- Only intrested about players loot

	if true --Settings[Track][Event]
	and	EVENTLOOT[itemId] then	-- Only intrested about event items
		d( ADDON .. ": and it was found in EVENTLOOT[itemId] ")
		if not StatisticallyEvent[itemId] then	-- Does itemId loot have a table
			d( ADDON .. ": StatisticallyEvent is emptyyyyyyy")
			StatisticallyEvent[itemId] = 1	-- if not, create one
		else
			StatisticallyEvent[itemId] = StatisticallyEvent[itemId] + 1	or 1 -- increase loot counter by one
		end

		d( ADDON .. ": " .. zo_strformat("<<i:1>>", StatisticallyEvent[itemId]) .. " " .. itemName)
		end
end


--	EVENT_QUEST_ADDED (number eventCode, number journalIndex, string questName, string objectiveName)
function Statistically_EVENT_QUEST_ADDED(_, addedToJournalIndex, addedQuestName, objectiveName)
	if GetJournalQuestType(addedToJournalIndex) == QUEST_TYPE_CRAFTING
	and GetJournalQuestRepeatType(addedToJournalIndex) == QUEST_REPEAT_DAILY then
		Session[addedQuestName] = os.time()
--		Session.addedQuestName = os.time() ei näin tai tulee addedQuestName niminen avain
--		d(ADDON .. " EVENT_QUEST_ADDED " .. addedQuestName .. " " .. Session[addedQuestName])

		if Session["Started"] == nil then
			Session["Started"] = os.time()
		end
	end
end

--	EVENT_QUEST_ADVANCED (number eventCode, number journalIndex, string questName, boolean isPushed, boolean isComplete, boolean mainStepChanged)
function Statistically_EVENT_QUEST_ADVANCED(eventCode, journalIndex, questName, isPushed, isComplete, mainStepChanged)
	d(ADDON .. " EVENT_QUEST_ADVANCED " .. questName )
end

--	EVENT_QUEST_REMOVED (number eventCode, boolean isCompleted, number journalIndex, string questName, number zoneIndex, number poiIndex, number questID)
function Statistically_EVENT_QUEST_REMOVED (eventCode, isCompleted, journalIndex, questName, zoneIndex, poiIndex, questID)
	if not isCompleted
	and Session[questName] ~= nil then
		Session[questName] = nil
	end
	-- d(ADDON .. ": EVENT_QUEST_REMOVED  " .. questName .. " @ " .. GetMapName() )
end

--	EVENT_QUEST_COMPLETE (number eventCode, string questName, number level, number previousExperience, number currentExperience, number championPoints, QuestType questType, InstanceDisplayType instanceDisplayType)
function Statistically_EVENT_QUEST_COMPLETE(eventCode, questName, level, previousExperience, currentExperience, championPoints, questType, instanceDisplayType)

	if Session[questName] ~= nil then

		local returingInMap = GetMapName()

		if Crafting[returingInMap] == nil then
			Crafting[returingInMap] = {}
			d( ADDON .. ": 1st crafting record in " .. returingInMap)
		end

		if Crafting[returingInMap][questName] == nil then
			d( ADDON .. ": 1st crafting record of " .. questName .. "in " .. returingInMap)
			Crafting[returingInMap][questName] = {}
		end

		local TotalTime	= os.time() - (Session[questName] or 0)
		Crafting[returingInMap][questName][TotalTime] = 1 + (Crafting[returingInMap][questName][TotalTime] or 0)

		d( ADDON .. ": " .. questName .. " was done in " .. ZO_FormatTimeLargestTwo(TotalTime, TIME_FORMAT_STYLE_DESCRIPTIVE_MINIMAL) )

		Session[questName] = nil

		Session[0] = 1 + (Session[0] or 1)

		if Session[0] > 6 
		and Session["Started"] ~= nil then
			if Crafting[returingInMap]["Total"]	== nil then
				Crafting[returingInMap]["Total"] = {}
			end
			local StartToEnd = os.time() - (Session["Started"] or 0)
			Crafting[returingInMap]["Total"][StartToEnd] = 1 + (Crafting[returingInMap]["Total"][StartToEnd] or 0)
			d( ADDON .. ": " .. returingInMap .. " 7x crafting was done in " .. ZO_FormatTimeLargestTwo(StartToEnd, TIME_FORMAT_STYLE_DESCRIPTIVE_MINIMAL) )
		end
	end
end

function Statistically.toggleTrackQuest (trueFalse)
	if trueFalse then
		Crafting   = ZO_SavedVars:NewAccountWide("StatisticallyCrafting", 1, GetWorldName(), default) or {}	-- Load settings
--		EVENT_MANAGER:RegisterForEvent(ADDON,	EVENT_QUEST_ADDED,	Statistically_EVENT_QUEST_ADDED)
		EVENT_MANAGER:RegisterForEvent(ADDON,	EVENT_QUEST_ADVANCED,	Statistically_EVENT_QUEST_ADVANCED)
		EVENT_MANAGER:RegisterForEvent(ADDON,	EVENT_QUEST_COMPLETE,	Statistically_EVENT_QUEST_COMPLETE)
		EVENT_MANAGER:RegisterForEvent(ADDON,	EVENT_QUEST_REMOVED,	Statistically_EVENT_QUEST_REMOVED)
	else
		EVENT_MANAGER:UnregisterForEvent(ADDON, EVENT_QUEST_ADDED)
--		EVENT_MANAGER:UnregisterForEvent(ADDON, EVENT_QUEST_ADVANCED)
		EVENT_MANAGER:UnregisterForEvent(ADDON, EVENT_QUEST_COMPLETE)
		EVENT_MANAGER:UnregisterForEvent(ADDON, EVENT_QUEST_REMOVED)
	end
end


-- Lets fire up the add-on by registering for events per StatisticallySettings
function Statistically.Initialize()
--	StatisticallySettings   = ZO_SavedVars:NewAccountWide("StatisticallySettings", 1, GetWorldName(), default) or {}	-- Load settings
	StatisticallyEvent   = ZO_SavedVars:NewAccountWide("StatisticallyEvent", 1, GetWorldName(), default) or {}	-- Load settings
	Crafting   = ZO_SavedVars:NewAccountWide("StatisticallyCrafting", 1, GetWorldName(), default) or {}	-- Load settings

	if Settings["Event"]
	or Settings["Loot"] then
		EVENT_MANAGER:RegisterForEvent(ADDON,	EVENT_LOOT_RECEIVED,	Statistically.EVENT_LOOT_RECEIVED)
	end

	Statistically.toggleTrackQuest( Settings.Quest )
end

-- Here the magic starts
function Statistically.EVENT_ADD_ON_LOADED(_, loadedAddOnName)
  if loadedAddOnName == ADDON then
		--	Seems it is our time to shine so lets stop listening load trigger, load saved variables and initialize the add-on
		EVENT_MANAGER:UnregisterForEvent(ADDON, EVENT_ADD_ON_LOADED)

		Statistically.Initialize()
  end
end
-- Registering for the add on loading loop
EVENT_MANAGER:RegisterForEvent(ADDON, EVENT_ADD_ON_LOADED, Statistically.EVENT_ADD_ON_LOADED )