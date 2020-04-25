local addonName, helpers = ...;

helpers.resetStorage = function()
    helpers.storage = {
        trackedItems = {
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
            "Linked Chain Cloak",
            "Rawhide Boots",
            "Searing Blade",
            "Clay Ring of the Gorilla",
            "Rough Stone",
            "Mutton Chop",
            "Dwarven Mild",
            "Inscribed Leather Spaulders",
            "Medium Leather",
            "Buccanner's Mantle",
            "Linked Chain Boots",
            "Large Blue Sack",
            "Healing Potion",
            "Melon Juice"

        },
        items = {}
    };
end

helpers.resetStorage();

helpers.tableIncludes = function(tab, val)
    for index, value in ipairs(tab) do
        if value == val then
            return true;
        end
    end

    return false;
end

helpers.handleLootOpened = function()
    helpers.resetStorage();
    local lootInfo = GetLootInfo();
    for lootIndex, lootWrapper in ipairs(lootInfo) do
        if helpers.tableIncludes(helpers.storage.trackedItems, lootWrapper.item) then
            table.insert(helpers.storage.items, {lootIndex = lootIndex, lootName = lootWrapper.item});
            RandomRoll(1, GetNumGroupMembers());
        end
    end
end

helpers.firstUnrolled = function()
    for k,v in ipairs(helpers.storage.items) do
        if v.rollResult == nil then return v end;
    end
end

helpers.setEligibleCandidate = function(item)
    local raidMemberName = GetRaidRosterInfo(item.rollResult);

    if raidMemberName then
        item.raidMemberName = raidMemberName;
        helpers.setEligibleCandidateIndexByName(item, raidMemberName);
    end
end

helpers.setEligibleCandidateIndexByName = function(item, raidMemberName)
    for i=1, GetNumGroupMembers() do
        local tempCandidate = GetMasterLootCandidate(item.lootIndex, i);
        if tempCandidate and tempCandidate == raidMemberName then
            item.candidateIndex = i;
            item.candidateName = tempCandidate;
        end
    end
end

helpers.handleRoll = function(rollResult)
    local item = helpers.firstUnrolled();
    item.rollResult = rollResult;
    helpers.setEligibleCandidate(item);

    local remainingItem = helpers.firstUnrolled();

    if remainingItem == nil then
        for id, item in ipairs(helpers.storage.items) do
            if item.candidateIndex then
                SendChatMessage("<RepRoller> " .. item.raidMemberName .. " is ELIGIBLE to receive " .. item.lootName .. " (Loot Window Index: " .. item.lootIndex .. " || Roll Result: " .. item.rollResult .. ")", "RAID");
                GiveMasterLoot(item.lootIndex, item.candidateIndex);
            else
                SendChatMessage("<RepRoller> " .. item.raidMemberName .. " is NOT ELIGIBLE to receive " .. item.lootName .. " (Loot Window Index: " .. item.lootIndex .. " || Roll Result: " .. item.rollResult .. ")", "RAID");
                item.rollResult = nil;
                --RandomRoll(1, GetNumGroupMembers());
            end
        end
    end;
end


