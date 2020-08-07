local frame = CreateFrame("FRAME") 
frame:RegisterEvent("ADDON_LOADED") 
frame:RegisterEvent("PLAYER_LOGIN")
frame:RegisterEvent("PLAYER_LOGOUT")

local clearVars = false

function frame:OnEvent(event, arg1)    
    if event == "ADDON_LOADED" and arg1 == "CurrencyGetter" then

        if CG_PearlCount == nil then
            a = {}
        else
            a = CG_PearlCount
        end

        if CG_HeartCount == nil then
            b = {}
        else
            b = CG_HeartCount
        end 

        if CG_WarCount == nil then
            c = {}
        else
            c = CG_WarCount
        end 

        if CG_IlvlCount == nil then
            d = {}
        else
            d = CG_IlvlCount
        end

        if CG_SmCount == nil then
            e = {}
        else
            e = CG_SmCount
        end

    elseif event == "PLAYER_LOGIN" then
        --UpdateInfo()
        AzerItem = C_AzeriteItem.FindActiveAzeriteItem()
        local CurrentPearlCount = select(2, GetCurrencyInfo(1721))
        local CurrentWarResCount = select(2, GetCurrencyInfo(1560))
        local CurrentAzerLevel = C_AzeriteItem.GetPowerLevel(AzerItem)

        local CurrentSmCount = nil
        local englishFaction = UnitFactionGroup("player")

        if englishFaction == "Horde" then
            CurrentSmCount = select(2, GetCurrencyInfo(1716))
        else
            CurrentSmCount = select(2, GetCurrencyInfo(1717))
        end 

        local PlayerName = GetUnitName("player", true)
        a[PlayerName .. " - " .. GetRealmName()] = CurrentPearlCount
        b[PlayerName .. " - " .. GetRealmName()] = CurrentAzerLevel
        c[PlayerName .. " - " .. GetRealmName()] = CurrentWarResCount
        d[PlayerName .. " - " .. GetRealmName()] = select(2, GetAverageItemLevel())  
        e[PlayerName .. " - " .. GetRealmName()] = CurrentSmCount    

    elseif event == "PLAYER_LOGOUT" then
        --UpdateInfo()
        if clearVars then
            CG_PearlCount = nil
            CG_HeartCount = nil
            CG_WarCount = nil
            CG_IlvlCount = nil
            CG_SmCount = nil
            a = nil
            b = nil
            c = nil
            d = nil
            e = nil
        else
            
            local CurrentPearlCount = select(2, GetCurrencyInfo(1721))
            local CurrentWarResCount = select(2, GetCurrencyInfo(1560))
            local CurrentAzerLevel = C_AzeriteItem.GetPowerLevel(AzerItem)

            local CurrentSmCount = nil
            local englishFaction = UnitFactionGroup("player")

            if englishFaction == "Horde" then
                CurrentSmCount = select(2, GetCurrencyInfo(1716))
            else
                CurrentSmCount = select(2, GetCurrencyInfo(1717))
            end 
            
            local PlayerName = GetUnitName("player", true)
            a[PlayerName .. " - " .. GetRealmName()] = CurrentPearlCount
            b[PlayerName .. " - " .. GetRealmName()] = CurrentAzerLevel
            c[PlayerName .. " - " .. GetRealmName()] = CurrentWarResCount
            d[PlayerName .. " - " .. GetRealmName()] = select(2, GetAverageItemLevel())
            e[PlayerName .. " - " .. GetRealmName()] = CurrentSmCount
            
            CG_PearlCount = a
            CG_HeartCount = b
            CG_WarCount = c
            CG_IlvlCount = d
            CG_SmCount = e

            AzerItem = nil
        end
    end
end

frame:SetScript("OnEvent", frame.OnEvent)
SLASH_HOWMANYPEARLS1 = "/pearls"
SLASH_HOWMANYHEARTS1 = "/heartlvl"
SLASH_HOWMANYWARRES1 = "/warres"
SLASH_HOWMANYILVLS1 = "/ilvl"
SLASH_HOWMANYSERVICEMEDALS1 = "/sm"
SLASH_CLEARVARS1 = "/cvars"

SlashCmdList["HOWMANYPEARLS"] = function()
    print("------Pearl count------")
    for idx, row in ipairs(GetSortedTable(a, "pearls")) do
        print(row.value, " -- ", row.key)
     end
    print("-----------------------")
    print(" ")
end

SlashCmdList["HOWMANYHEARTS"] = function()
    print("------Heart count------")
    for idx, row in ipairs(GetSortedTable(b, "hearts")) do
        print(row.value, " -- ", row.key)
     end
    print("-----------------------")
    print(" ")
end

SlashCmdList["HOWMANYWARRES"] = function()
    print("------WarRes count-----")
    for idx, row in ipairs(GetSortedTable(c, "warres")) do
        print(row.value, " -- ", row.key)
     end
    print("-----------------------")
    print(" ")
end

SlashCmdList["HOWMANYILVLS"] = function()
    print("-------Ilvl count------")
    --local sorted = GetSortedTable(d)
    for idx, row in ipairs(GetSortedTable(d, "ilvl")) do
       print(round(tonumber(row.value),1), " -- ", row.key)
    end
--[[
    for name, iCount in pairs(d) do
        print(round(tonumber(iCount),1), " -- ", name)
    end
]]
    print("-----------------------")
    print(" ")
end

SlashCmdList["HOWMANYSERVICEMEDALS"] = function()
    print("------ServiceMedal count-----")
    if e == nil then
        print("TABLE MALFUNCTIONED")
    else
        for idx, row in ipairs(GetSortedTable(e, "sm")) do
            print(row.value, " -- ", row.key)
        end
    end
    print("-----------------------")
    print(" ")
end

SlashCmdList["CLEARVARS"] = function()
    clearVars = true
end

function round(num, numDecimalPlaces)
    local mult = 10^(numDecimalPlaces or 0)
    return math.floor(num * mult + 0.5) / mult
end










--[[
function UpdateInfo()
    local CurrentPearlCount = select(2, GetCurrencyInfo(1721))
    local CurrentWarResCount = select(2, GetCurrencyInfo(1560))
    local PlayerName = GetUnitName("player", false)

    a[CurrentPearlCount] = PlayerName
    b[C_AzeriteItem.GetPowerLevel(C_AzeriteItem.FindActiveAzeriteItem())] = PlayerName
    c[CurrentWarResCount] = PlayerName
    d[select(2, GetAverageItemLevel())] = PlayerName
end
]]


function GetSortedTable(tbl, table_source)
    local meta = {}
    for foo, bar in pairs(tbl) do
        table.insert(meta, {key=foo, value=bar})
    end
    table.sort(meta, function(a,b)
        return a.value > b.value
    end)
    return meta
end

--[[
local sorted = GetSortedTable(someTable)
for idx, row in ipairs(sorted) do
    -- something with row.key and row.value
end
]]

-- ilvl: overall, equipped = GetAverageItemLevel()

-- war resources: select(2, GetCurrencyInfo(1560))


--[[
    CG_PearlCount = nil
    CG_HeartCount = nil 
    CG_WarCount   = nil
    CG_IlvlCount  = nil
    a = nil
    b = nil
    c = nil
    d = nil
]]