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
    "Yellow Hakkari Bijou",
    "Seer's Mantle"
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

local currentLootIndex;

local handler = function(candidateIndex)
   print("currentLootIndex " .. currentLootIndex .. " candidateIndex " .. candidateIndex); 
end;



f:RegisterEvent("CHAT_MSG_SYSTEM");
f:RegisterEvent("LOOT_OPENED");
f:SetScript("OnEvent", function(self, event, ...)
    if event == "LOOT_OPENED" then
        local lootInfo = GetLootInfo();
        
        for lootIndex, lootWrapper in ipairs(lootInfo) do
            if tableIncludes(trackedItems, lootWrapper.item) then
                currentLootIndex = lootIndex;
                RandomRoll(1, GetNumGroupMembers());
            end
        end
    end

    if event == "CHAT_MSG_SYSTEM" then
      local message = ...;
      local author, rollResult, rollMin, rollMax = string.match(message, "(.+) rolls (%d+) %((%d+)-(%d+)%)");
      if author and author == name and handler then
        handler(rollResult);
      end
    end
end)

--GetNumGroupMembers()
--RandomRoll(1, GetNumGroupMembers())
--local name, realm = UnitName("player")

