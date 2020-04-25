local addonName, helpers = ...;


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

f:RegisterEvent("CHAT_MSG_SYSTEM");
f:RegisterEvent("LOOT_OPENED");
f:SetScript("OnEvent", function(self, event, ...)
    if event == "LOOT_OPENED" then
        helpers.handleLootOpened();
    end

    if event == "CHAT_MSG_SYSTEM" then
      local message = ...;
      local author, rollResult, rollMin, rollMax = string.match(message, "(.+) rolls (%d+) %((%d+)-(%d+)%)");
      if author and author == name then
        --local raidMemberName = GetRaidRosterInfo(rollResult);
        --table.insert(rollResults, { id = rollResult, name = raidMemberName });
        helpers.handleRoll()
      end
    end
end)

SendSystemMessage("<RepRoller> Successfully loaded");

