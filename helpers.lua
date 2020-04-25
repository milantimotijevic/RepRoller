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
            "Dwarven Mild"

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

    print(#helpers.storage.items)
end

helpers.firstUnrolled = function()
    for k,v in ipairs(helpers.storage.items) do
        if v.rollResult == nil then return v end;
    end
end

helpers.getEligibleCandidate = function(rollResult)
    local raidMemberName = GetRaidRosterInfo(rollResult);
    print(raidMemberName);
end

helpers.handleRoll = function(rollResult)
    local firstUnrolled = helpers.firstUnrolled();
    firstUnrolled.rollResult = rollResult;
    helpers.getEligibleCandidate(rollResult);

    firstUnrolled = helpers.firstUnrolled();

    if firstUnrolled == nil then
        for k,v in ipairs(helpers.storage.items) do print("lootIndex " .. v.lootIndex .. " lootName " .. v.lootName .. " rollResult " .. v.rollResult) end
    end;
end


