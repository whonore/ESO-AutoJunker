AutoJunker = {}
AutoJunker.name = "AutoJunker"

function AutoJunker:Initialize()
end

function AutoJunker.OnAddOnLoaded(event, addonName)
    if addonName == AutoJunker.name then
        AutoJunker:Initialize()
    end

    EVENT_MANAGER:RegisterForEvent(AutoJunker.name, EVENT_INVENTORY_SINGLE_SLOT_UPDATE, AutoJunker.OnInventoryChanged)
    EVENT_MANAGER:AddFilterForEvent(AutoJunker.name, EVENT_INVENTORY_SINGLE_SLOT_UPDATE, REGISTER_FILTER_IS_NEW_ITEM, true)
    EVENT_MANAGER:AddFilterForEvent(AutoJunker.name, EVENT_INVENTORY_SINGLE_SLOT_UPDATE, REGISTER_FILTER_BAG_ID, BAG_BACKPACK)
    EVENT_MANAGER:AddFilterForEvent(AutoJunker.name, EVENT_INVENTORY_SINGLE_SLOT_UPDATE, REGISTER_FILTER_INVENTORY_UPDATE_REASON, INVENTORY_UPDATE_REASON_DEFAULT)
end

function AutoJunker.OnInventoryChanged(event, bagId, slotIdx, isNew, soundCategory, updateReason, stackCount)
    if isNew and isJunk(bagId, slotIdx)
        SetItemIsJunk(bagId, slotIdx, true)
    end
end

local function isJunk(bagId, slotIdx)
    d("Checking " .. GetItemLink(bagId, slotIdx) .. " for junk")
    return false and CanItemBeMarkedAsJunk(bagIdx, slotIdx)
end

EVENT_MANAGER:RegisterForEvent(AutoJunker.name, EVENT_ADD_ON_LOADED, AutoJunker.OnAddOnLoaded)
