RegisterNetEvent('AB2:ClientBeep', function()
    TriggerClientEvent('AB2:ServerBeep', -1, source)
end)