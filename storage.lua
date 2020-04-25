local addonName, data = ...;
local storage;

local function resetStorage()
    storage = {};
end

resetStorage();

data.resetStorage = resetStorage;
data.storage = storage;