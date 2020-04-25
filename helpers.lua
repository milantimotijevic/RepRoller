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
            "Clay Ring of the Gorilla"
        },
        rolls = {}
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

helpers.firstUnrolled = function()
    for k,v in ipairs(helpers.storage.rolls) do
        if v.rollValue == nil then return v end;
    end
end

helpers.handleLootOpened = function()
    local lootInfo = GetLootInfo();
    for lootIndex, lootWrapper in ipairs(lootInfo) do
        if helpers.tableIncludes(helpers.storage.trackedItems, lootWrapper.item) then
            table.insert(helpers.storage.rolls, {lootIndex = lootIndex, lootName = lootWrapper.item});
            RandomRoll(1, GetNumGroupMembers());
        end
    end

    print(#helpers.storage.rolls)
end

helpers.handleRoll = function()
    local firstUnrolled = helpers.firstUnrolled();
    print(firstUnrolled.lootName)
end


