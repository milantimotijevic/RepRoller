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

local matchedCount = 0;
local rollResults = {};

f:RegisterEvent("CHAT_MSG_SYSTEM");
f:RegisterEvent("LOOT_OPENED");
f:RegisterEvent("LOOT_CLOSED");
f:SetScript("OnEvent", function(self, event, ...)
    if event == "LOOT_OPENED" then
        local lootInfo = GetLootInfo();
        
        for lootIndex, lootWrapper in ipairs(lootInfo) do
            if tableIncludes(trackedItems, lootWrapper.item) then
                matchedCount = matchedCount + 1;
                RandomRoll(1, GetNumGroupMembers());
            end
        end
    end

    if event == "CHAT_MSG_SYSTEM" then
      local message = ...;
      local author, rollResult, rollMin, rollMax = string.match(message, "(.+) rolls (%d+) %((%d+)-(%d+)%)");
      if author and author == name then
        table.insert(rollResults, rollResult);

        if matchedCount == #rollResults then 
            for lootIndex, lootWrapper in ipairs(lootInfo) do
                if tableIncludes(trackedItems, lootWrapper.item) then
                    local poppedRollResults = table.remove(rollResults, 1);
                    GiveMasterLoot(currentLootIndex, poppedRollResults);
                end
            end
        end
      end
    end

    if event == "LOOT_CLOSED" then
        matchedCount = 0;
        rollResults = {};
    end

end)

SendSystemMessage("<RepRoller> Successfully loaded");

