---------------------------------------
--      ESX_WASHLAB by Dividerz      --
-- FOR SUPPORT: Arne#7777 on Discord --
---------------------------------------

ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
local storedAccounts = {}

ESX.RegisterServerCallback('esx_washlab:callback:getBlackMoneyAmount', function(source, cb)
    local sourcePlayer = ESX.GetPlayerFromId(source)
    local amount = sourcePlayer.getAccount('black_money').money

    if amount ~= nil then
        cb(amount)
    end
end)

RegisterNetEvent('esx_washlab:server:removeBlackMoney')
AddEventHandler('esx_washlab:server:removeBlackMoney', function()
    local _source = source
    local sourcePlayer = ESX.GetPlayerFromId(_source)
    local amount = sourcePlayer.getAccount('black_money').money
    
    if (amount ~= nil and amount > 0) then
        sourcePlayer.removeAccountMoney('black_money', amount)
        if (storedAccounts[_source] ~= nil and storedAccounts[_source] > 0) then
            storedAccounts[_source] = storedAccounts[_source] + amount
        else
            storedAccounts[_source] = amount
        end
    end
end)

RegisterNetEvent('esx_washlab:server:giveCleanMoney')
AddEventHandler('esx_washlab:server:giveCleanMoney', function(amount)
    local _source = source
    local sourcePlayer = ESX.GetPlayerFromId(source)
    local total = amount
    if (Config.TakePercentage) then
        total = amount * Config.WashPercentage
    end

    --[[
        "protected" part
    ]]
    if (storedAccounts[_source] ~= nil and storedAccounts[_source] > 0) then
        if (storedAccounts[_source] >= total) then
            sourcePlayer.addMoney(total) 
            TriggerClientEvent('esx:showNotification', _source, 'You washed ~y~$' .. total .. '~s~.')
            storedAccounts[_source] = storedAccounts[_source] - total
        else
            TriggerClientEvent('esx:showNotification', _source, 'dont exploit please - nertigel')
        end
    end
end)