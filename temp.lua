itemResults = {};
        rollResults = {};
        local lootInfo = GetLootInfo();
        
        for lootIndex, lootWrapper in ipairs(lootInfo) do
            if tableIncludes(trackedItems, lootWrapper.item) then
                table.insert(itemResults, { id = lootIndex, name = lootWrapper.item });
                RandomRoll(1, GetNumGroupMembers());
            end
        end

        