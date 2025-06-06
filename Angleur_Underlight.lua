AngleurUnderlight_MainFishingRod = {
    name = nil,
    link = nil,
    itemID = nil,
    icon = nil
}
local queue = AngleurUnderlight_Queue

local UNDERLIGHT = 133755

local colorUnderlight = CreateColor(0.9, 0.8, 0.5)
local colorYello = CreateColor(1.0, 0.82, 0.0)

function AngleurUnderlight_UpdateButton(self)
    if AngleurUnderlight_MainFishingRod.name then
        self.icon:SetTexture(AngleurUnderlight_MainFishingRod.icon)
        self.closeButton:Show()
            self.tooltipTitle = AngleurUnderlight_MainFishingRod.link .. "\nset as Main Fishing Rod."
            self.tooltipText = "\nWhen you start swimming, the " .. colorUnderlight:WrapTextInColorCode("Underlight Angler ") .. " will be " 
            .. "equipped to trigger the buff.\n\nWhen you stop swimming, your main fishing rod will be re-equipped"
    else
        self.closeButton:Hide()
        self.icon:SetTexture()
        self.tooltipTitle = "No main fishing rod set"
        self.tooltipText = "\nYour " .. colorUnderlight:WrapTextInColorCode("Underlight Angler ") 
        .. "will be swapped in and out to keep the buff active when you start/stop swimming.\n\n" 
        .. colorYello:WrapTextInColorCode("Drag ") .. "a fishing rod here to set it as main."
    end
end

function AngleurUnderlight_RemoveMainRod(self)
    AngleurUnderlight_MainFishingRod.name = nil
    AngleurUnderlight_MainFishingRod.link = nil
    AngleurUnderlight_MainFishingRod.itemID = nil
    AngleurUnderlight_MainFishingRod.icon = nil
    local parent = self:GetParent()
    AngleurUnderlight_UpdateButton(parent)
end

function AngleurUnderlight_GrabFishingRod(self)
    Angleur_BetaPrint("I wonder if this is a fishing rod.")
    if InCombatLockdown() then
        ClearCursor()
        print("Can't drag item in combat.")
        return
    end
    local itemLoc = C_Cursor.GetCursorItem()
    local itemID = C_Item.GetItemID(itemLoc)
    if not C_Item.IsEquippableItem(itemID) then
        print("Not an equippable item. Please drag in your main fishing rod.")
        return
    end
    local profession = C_TradeSkillUI.GetProfessionForCursorItem()
    if profession ~= 10 then
        print("Not a fishing rod. Please drag in your main fishing rod.")
        return
    end
    local itemInfo = {C_Item.GetItemInfo(itemID)}
    if itemInfo[9] ~= "INVTYPE_PROFESSION_TOOL" then
        print("Item is equippable and fishing related, but not a fishing rod. Please drag in your main fishing rod.")
        return
    end
    AngleurUnderlight_MainFishingRod.name = itemInfo[1]
    AngleurUnderlight_MainFishingRod.link = itemInfo[2]
    AngleurUnderlight_MainFishingRod.itemID = itemID
    AngleurUnderlight_MainFishingRod.icon = itemInfo[10]
    AngleurUnderlight_UpdateButton(self)
end
-- /dump IsSwimming("player")
-- /dump IsSubmerged("player")
-- /dump C_PlayerInfo.GetGlidingInfo()
function AngleurUnderlight_OnLoad(self)
    self:RegisterEvent("PLAYER_ENTERING_WORLD")
    self:SetScript("OnEvent", AngleurUnderlight_EventLoader)
end

function AngleurUnderlight_EventLoader(self, event, unit, ...)
    if event == "PLAYER_ENTERING_WORLD" then
        AngleurUnderlight_UpdateButton(self)
    end
end

local function isEligible(itemID)
    if not C_Item.IsEquippableItem(itemID) then return false end
    if not (C_Item.GetItemCount(itemID) >= 1) then
        return false
    end
    return true
end
local function checkReEquip()
    if InCombatLockdown() then return false end
    local mainRod = AngleurUnderlight_MainFishingRod.itemID
    if not mainRod then return end
    if not isEligible(mainRod) then 
        print("The main fishing rod not found in bags. Cannot swap.")
        return 
    end
    local mainRodEquipped = C_Item.IsEquippedItem(mainRod)
    if mainRodEquipped then
        -- do nothing
    else
        queue.unequip = false
        queue.equip = mainRod
        AngleurUnderlight_HandleQueue()
    end
end

local function checkEquip()
    if InCombatLockdown() then return false end
    if not isEligible(UNDERLIGHT) then 
        print("Underlight Angler not found in bags. Cannot equip.")
        return
    end
    local fishingAura = C_UnitAuras.GetPlayerAuraBySpellID(394009)
    local underlightEquipped = C_Item.IsEquippedItem(UNDERLIGHT)
    Angleur_BetaPrint("fishing aura: ", fishingAura, "\nunderlight equipped: ", underlightEquipped)
    if fishingAura then
        if underlightEquipped then
            --do nothing
        else
            queue.unequip = false
            queue.equip = UNDERLIGHT
            AngleurUnderlight_HandleQueue()
        end
    else
        if underlightEquipped then
            queue.unequip = true
            queue.equip = UNDERLIGHT
            AngleurUnderlight_HandleQueue()
        else
            queue.unequip = false
            queue.equip = UNDERLIGHT
            AngleurUnderlight_HandleQueue()
        end
    end
end
    
    
local wasSwimming = false
local swimdelayFrame = CreateFrame("Frame")
swimdelayFrame:Show()
function AngleurUnderlight_Events(self, event, unit)
    if event == "PLAYER_REGEN_DISABLED" then
        queue.unequip = false
        queue.equip = nil
        AngleurUnderlight_HandleQueue()
    elseif event == "PLAYER_REGEN_ENABLED" then
        -- need to delay after exiting combat a little bit otherwise the fish form doesn't trigger
        if IsSwimming() then
            wasSwimming = true
            checkEquip()
        elseif wasSwimming == true then
            wasSwimming = false
            checkReEquip()
        end
    elseif event == "MOUNT_JOURNAL_USABILITY_CHANGED" or "MIRROR_TIMER_START" then
        -- No need to check for it all when in combat, + "wasSwimming" needs to stay unchanged during combat
        if InCombatLockdown() then return end
        Angleur_SingleDelayer(1, 0, 0.2, swimdelayFrame, function()
            if IsSwimming() then
                wasSwimming = true
                Angleur_BetaPrint("swimming start")
                checkEquip()
                return true
            else
                if wasSwimming == true then
                    wasSwimming = false
                    Angleur_BetaPrint("was swimming")
                    checkReEquip()
                end
            end
        end,
        function()
            if IsSwimming() then
                wasSwimming = true
                Angleur_BetaPrint("swimming started")
                checkEquip()
            else
                if wasSwimming == true then
                    wasSwimming = false
                    Angleur_BetaPrint("was swimming")
                    checkReEquip()
                end
                Angleur_BetaPrint("player is not swimming, but also wasn't swimming before")
            end
        end)
    end
end

local eventFrame = CreateFrame("Frame")
eventFrame:RegisterEvent("MOUNT_JOURNAL_USABILITY_CHANGED")
eventFrame:RegisterEvent("MIRROR_TIMER_START")
eventFrame:RegisterEvent("PLAYER_REGEN_DISABLED")
eventFrame:RegisterEvent("PLAYER_REGEN_ENABLED")
eventFrame:SetScript("OnEvent", AngleurUnderlight_Events)

