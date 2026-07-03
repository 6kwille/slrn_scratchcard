local function toggleNuiFrame(shouldShow)
    SetNuiFocus(shouldShow, shouldShow)
    SendNUIMessage({
        action = "setVisible",
        data = shouldShow
    })
end

-- Event för att öppna trisslotten
RegisterNetEvent('slrn_scratchcard:client:openScratcher', function(prizeData, cardData)
    SendNUIMessage({
        action = "cardSetup",
        data = cardData
    })
    SendNUIMessage({
        action = "prizeData",
        data = prizeData
    })
    Wait(100)
    toggleNuiFrame(true)
end)

-- Callback när skrapet är klart
RegisterNUICallback('scratcherComplete', function(data, cb)
    TriggerServerEvent('slrn_scratchcard:server:getPrize')
    toggleNuiFrame(false)
    cb('ok')
end)

-- Callback för att stänga UI
RegisterNUICallback('hideFrame', function(data, cb)
    toggleNuiFrame(false)
    cb('ok')
end)

-- NUI Message helper (behåller bakåtkompatibilitet om det fanns React-kod tidigare)
function SendReactMessage(action, data)
    SendNUIMessage({
        action = action,
        data = data
    })
end
