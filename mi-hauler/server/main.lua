local PaymentTax = 15
local Bail = {}

RegisterServerEvent('mi-hauler:server:DoBail')
AddEventHandler('mi-hauler:server:DoBail', function(bool, vehInfo)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)

    if bool then
        if Player.PlayerData.money.bank >= Config.BailPrice then
            Bail[Player.PlayerData.citizenid] = Config.BailPrice
            Player.Functions.RemoveMoney('bank', Config.BailPrice, "tow-paid-bail")
            TriggerClientEvent('QBCore:Notify', src, 'You Have Paid The Deposit Of $'..Config.BailPrice..' Paid', 'success')
            TriggerClientEvent('mi-hauler:client:spawnHauler', src, vehInfo)
        else
            TriggerClientEvent('QBCore:Notify', src, 'You Do Not Have Enough Cash, The Deposit Is $'..Config.BailPrice..'', 'error')
        end
    else
        if Bail[Player.PlayerData.citizenid] ~= nil then
            Player.Functions.AddMoney('bank', Bail[Player.PlayerData.citizenid], "tow-bail-paid")
            Bail[Player.PlayerData.citizenid] = nil
            TriggerClientEvent('QBCore:Notify', src, 'You Got Back $'..Config.BailPrice..' From The Deposit', 'success')
        end
    end
end)


RegisterNetEvent('mi-hauler:server:GetPaid')
AddEventHandler('mi-hauler:server:GetPaid', function(jobsDone)
    local src = source 
    local Player = QBCore.Functions.GetPlayer(src)
    local jobsDone = tonumber(jobsDone)
    local bonus = 0
    local DropPrice = math.random(10, 100)
    if jobsDone > 5 then 
        bonus = math.ceil((DropPrice / 10) * 5)
    elseif jobsDone > 10 then
        bonus = math.ceil((DropPrice / 10) * 7)
    elseif jobsDone > 15 then
        bonus = math.ceil((DropPrice / 10) * 10)
    elseif jobsDone > 20 then
        bonus = math.ceil((DropPrice / 10) * 12)
    end
    local price = (DropPrice * jobsDone) + bonus
    local taxAmount = math.ceil((price / 100) * PaymentTax)
    local payment = price - taxAmount

    Player.Functions.AddJobReputation(1)
    Player.Functions.AddMoney("bank", payment, "tow-salary")
    TriggerClientEvent('QBCore:Notify', src, "You Received Your Salary From: $"..payment..", Gross: $"..price.." (From What $"..bonus.." Bonus) In $"..taxAmount.." Tax ("..PaymentTax.."%)", 'success')
    TriggerClientEvent('chatMessage', source, "JOB", "warning", "You Received Your Salary From: $"..payment..", Gross: $"..price.." (From What $"..bonus.." Bonus) In $"..taxAmount.." Tax ("..PaymentTax.."%)")
end)


RegisterServerEvent("mi-hauler:server:delivered")
AddEventHandler("mi-hauler:server:delivered", function(prize)
    local src = source

    local target = QBCore.Functions.GetPlayer(src)
    if not prize
    then
        prize = 0
    end

    target.Functions.AddMoney('cash', prize)
    TriggerClientEvent("DoShortHudText",src, "You Get $"..prize, 8)

end)