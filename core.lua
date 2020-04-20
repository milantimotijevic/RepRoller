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

local currentLootIndex;
local currentItemName;

f:RegisterEvent("CHAT_MSG_SYSTEM");
f:RegisterEvent("LOOT_OPENED");
f:SetScript("OnEvent", function(self, event, ...)
    local groupType;

    if IsInGroup("LE_PARTY_CATEGORY_HOME") then groupType = "PARTY" end

    if IsInRaid("LE_PARTY_CATEGORY_HOME") then groupType = "RAID" end

    if groupType == nil then return end

    if event == "LOOT_OPENED" then
        local lootInfo = GetLootInfo();
        
        for lootIndex, lootWrapper in ipairs(lootInfo) do
            if tableIncludes(trackedItems, lootWrapper.item) then
                currentLootIndex = lootIndex;
                currentItemName = lootWrapper.item;
                RandomRoll(1, GetNumGroupMembers());
            end
        end
    end

    if event == "CHAT_MSG_SYSTEM" then
      local message = ...;
      local author, rollResult, rollMin, rollMax = string.match(message, "(.+) rolls (%d+) %((%d+)-(%d+)%)");
      if author and author == name then
        local msg = "<RepRoller> Raid Rolled " .. currentItemName;
        SendChatMessage(msg, groupType);
        GiveMasterLoot(currentLootIndex, rollResult);
      end
    end
end)

