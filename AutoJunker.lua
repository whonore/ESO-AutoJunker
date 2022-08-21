AutoJunker = {}
AutoJunker.name = "AutoJunker"

local function init()
    EVENT_MANAGER:RegisterForEvent(
        AutoJunker.name,
        EVENT_INVENTORY_SINGLE_SLOT_UPDATE,
        AutoJunker.OnInventoryChanged)
    EVENT_MANAGER:AddFilterForEvent(
        AutoJunker.name,
        EVENT_INVENTORY_SINGLE_SLOT_UPDATE,
        REGISTER_FILTER_BAG_ID,
        BAG_BACKPACK)
    EVENT_MANAGER:AddFilterForEvent(
        AutoJunker.name,
        EVENT_INVENTORY_SINGLE_SLOT_UPDATE,
        REGISTER_FILTER_INVENTORY_UPDATE_REASON,
        INVENTORY_UPDATE_REASON_DEFAULT)
end

local function isJunk(bagId, slotIdx)
    if not CanItemBeMarkedAsJunk(bagId, slotIdx) or IsItemJunk(bagId, slotIdx) then
        return false
    end

    -- TODO: Allow more types of filters
    local type, _ = GetItemType(bagId, slotIdx)
    return type == ITEMTYPE_TRASH
end

local function notifyJunk(bagId, slotIdx)
    -- TODO: Use a nicer notification
    d("Marking " .. GetItemLink(bagId, slotIdx) .. " as junk.")
end

function AutoJunker.OnInventoryChanged(
        event,
        bagId,
        slotIdx,
        isNew,
        soundCategory,
        updateReason,
        stackCount)
    if stackCount > 0 and isJunk(bagId, slotIdx) then
        notifyJunk(bagId, slotIdx)
        SetItemIsJunk(bagId, slotIdx, true)
    end
end

EVENT_MANAGER:RegisterForEvent(
    AutoJunker.name,
    EVENT_ADD_ON_LOADED,
    function(event, addon)
        if addon ~= AutoJunker.name then return end
        EVENT_MANAGER:UnregisterForEvent(AutoJunker.name, EVENT_ADD_ON_LOADED)
        init()
    end)
