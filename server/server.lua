local playerData = {}

-- Funktion för att skapa en trisslott-data
local function createScratcher(src, scratcherIndex)
    if not src then return end

    local cardConfig = Config.CardArray[scratcherIndex]
    if not cardConfig then return end

    local prizeSquares = cardConfig.gridSizeX * cardConfig.gridSizeY
    local prizeData = {}
    local winner = math.random(100) <= cardConfig.winChance
    local winningAmount = 0
    
    if winner then
        winningAmount = Config.PrizeAmounts[math.random(#Config.PrizeAmounts)]
        -- Lägg till 3 vinnande rutor
        for i = 1, 3 do
            table.insert(prizeData, {
                amount = winningAmount,
                icon = Config.PrizeIcons[math.random(#Config.PrizeIcons)].icon,
                isWinner = true
            })
        end
        prizeSquares = prizeSquares - 3
    end

    -- Fyll resten med slumpmässiga (icke-vinnande) belopp
    for i = 1, prizeSquares do
        local randomAmount = Config.PrizeAmounts[math.random(#Config.PrizeAmounts)]
        -- Se till att vi inte råkar skapa 3 av samma om vi inte ska vinna
        if randomAmount == winningAmount and not winner then
            randomAmount = Config.PrizeAmounts[1] == winningAmount and Config.PrizeAmounts[2] or Config.PrizeAmounts[1]
        end

        table.insert(prizeData, {
            amount = randomAmount,
            icon = Config.PrizeIcons[math.random(#Config.PrizeIcons)].icon,
            isWinner = false
        })
    end

    -- Blanda tabellen så vinsterna inte alltid ligger först
    for i = #prizeData, 2, -1 do
        local j = math.random(i)
        prizeData[i], prizeData[j] = prizeData[j], prizeData[i]
    end

    playerData[src] = {
        prizeAmount = winner and winningAmount or 0,
        scratcherType = scratcherIndex,
        isFinished = false
    }

    local cardData = {
        gridSizeX = cardConfig.gridSizeX,
        gridSizeY = cardConfig.gridSizeY,
        cardBgColor = cardConfig.cardBgColor,
        stripeColor = cardConfig.stripeColor,
        label = cardConfig.label
    }

    TriggerClientEvent('slrn_scratchcard:client:openScratcher', src, prizeData, cardData)
end

-- Export för ox_inventory
exports('scratcher', function(event, item, inventory, slot, data)
    if event == 'usingItem' then
        local src = inventory.id
        if playerData[src] and playerData[src].playerCooldown then
            DoNotification(src, 'Du skrapar för snabbt!', 'error')
            return false
        end
        return true
    end

    if event == 'usedItem' then
        local src = inventory.id
        createScratcher(src, 'triss')
        playerData[src].playerCooldown = true
        SetTimeout(Config.Cooldown, function()
            if playerData[src] then
                playerData[src].playerCooldown = false
            end
        end)
    end
end)

-- Event när spelaren har skrapat klart
RegisterNetEvent('slrn_scratchcard:server:getPrize', function()
    local src = source
    if not playerData[src] or playerData[src].isFinished then return end
    
    playerData[src].isFinished = true
    local prize = playerData[src].prizeAmount

    if prize > 0 then
        local message = ("Grattis! Du vann %s SEK på din Trisslott!"):format(prize)
        DoNotification(src, message, 'success')
        
        local player = GetPlayer(src)
        if player then
            AddMoney(player, 'cash', prize)
        end
    else
        DoNotification(src, "Tyvärr, ingen vinst denna gång. Plötsligt händer det!", 'error')
    end
    
    -- Rensa data efter en liten stund
    SetTimeout(5000, function()
        playerData[src] = nil
    end)
end)

-- Debug kommando
if Config.Debug then
    RegisterCommand('testtriss', function(source, args)
        createScratcher(source, 'triss')
    end, true)
end
