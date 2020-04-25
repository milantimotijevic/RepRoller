local addonName, helpers = ...;

helpers.resetStorage = function()
    helpers.storage = {};
end

helpers.resetStorage();

helpers.handleLootOpened = function()
    print("Handling loot opened...");
end

