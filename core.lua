local addonName, data = ...;
local helpers = data.helpers;
local resetStorage = data.resetStorage;
local storage = data.storage;
print('aa')

print(storage.cats[1])

local trackedItems = {
    "Zulian Coin",
    "Razzashi Coin",
    "Hakkari Coin",
    "Sandfury Coin",
    "Skullsplitter Coin",
    "Bloodscalp Coin",
    "Gurubashi Coin",
    "Vilebranch Coin",
    "Witherbark Coin",
    "Red Hakkari Bijou",
    "Green Hakkari Bijou",
    "Blue Hakkari Bijou",
    "Purple Hakkari Bijou",
    "Bronze Hakkari Bijou",
    "Silver Hakkari Bijou",
    "Gold Hakkari Bijou",
    "Orange Hakkari Bijou",
    "Yellow Hakkari Bijou"
};

local function tableIncludes (tab, val)
    for index, value in ipairs(tab) do
        if value == val then
            return true
        end
    end

    return false
end

local name, realm = UnitName("player");
local f = CreateFrame("frame");

local itemResults;
local rollResults;

f:RegisterEvent("CHAT_MSG_SYSTEM");
f:RegisterEvent("LOOT_OPENED");
f:SetScript("OnEvent", function(self, event, ...)
    if event == "LOOT_OPENED" then
        itemResults = {};
        rollResults = {};
        local lootInfo = GetLootInfo();
        
        for lootIndex, lootWrapper in ipairs(lootInfo) do
            if tableIncludes(trackedItems, lootWrapper.item) then
                table.insert(itemResults, { id = lootIndex, name = lootWrapper.item });
                RandomRoll(1, GetNumGroupMembers());
            end
        end
    end

    if event == "CHAT_MSG_SYSTEM" then
      local message = ...;
      local author, rollResult, rollMin, rollMax = string.match(message, "(.+) rolls (%d+) %((%d+)-(%d+)%)");
      if author and author == name then
        local raidMemberName = GetRaidRosterInfo(rollResult);
        table.insert(rollResults, { id = rollResult, name = raidMemberName });
        
        if #itemResults == #rollResults then 
            for lootIndex, lootWrapper in ipairs(lootInfo) do
                if tableIncludes(trackedItems, lootWrapper.item) then
                    local poppedRaidResult = table.remove(rollResults, 1);

                    for i=1,GetNumGroupMembers() do
                        local candidate = GetMasterLootCandidate(lootIndex, i);
                        if candidate and poppedRaidResult.name and candidate == poppedRaidResult.name then
                            SendChatMessage("<RepRoller> Assigning " .. lootWrapper.item .. " to raid member " .. poppedRaidResult.id .. "(" .. poppedRaidResult.name .. ")", "RAID");
                            --GiveMasterLoot(lootIndex, poppedRaidResult.id);
                        else
                            SendChatMessage("<RepRoller> Error assigning " .. lootWrapper.item .. " to raid member " .. poppedRaidResult.id .. "(" .. poppedRaidResult.name .. ")", "RAID");
                        end
                    end
                    
                end
            end
        end
      end
    end
end)

SendSystemMessage("<RepRoller> Successfully loaded");

