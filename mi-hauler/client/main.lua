isLoggedIn = false
local PlayerJob = {}
local CurrentPlate = nil
local JobsDone = 0
local NpcOn = false
local CurrentLocation = {}
local CurrentBlip = nil
local LastVehicle = 0
local VehicleSpawned = false

local TargetTrailer = nil
local TargetHauler = nil
local TargetBlip = nil
local isAttached = false


RegisterNetEvent('QBCore:Client:OnPlayerLoaded')
AddEventHandler('QBCore:Client:OnPlayerLoaded', function()
    isLoggedIn = true
    PlayerJob = QBCore.Functions.GetPlayerData().job

    if PlayerJob.name == "hauler" then
        local TowBlip = AddBlipForCoord(Config.Locations["main"].coords.x, Config.Locations["main"].coords.y, Config.Locations["main"].coords.z)
        SetBlipSprite(TowBlip, 477)
        SetBlipDisplay(TowBlip, 4)
        SetBlipScale(TowBlip, 0.6)
        SetBlipAsShortRange(TowBlip, true)
        SetBlipColour(TowBlip, 15)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentSubstringPlayerName(Config.Locations["main"].label)
        EndTextCommandSetBlipName(TowBlip)
    end
end)

RegisterNetEvent('QBCore:Client:OnPlayerUnload')
AddEventHandler('QBCore:Client:OnPlayerUnload', function()
    isLoggedIn = false
end)

RegisterNetEvent('QBCore:Client:OnJobUpdate')
AddEventHandler('QBCore:Client:OnJobUpdate', function(JobInfo)
    PlayerJob = JobInfo

    if PlayerJob.name == "hauler" then
        local TowBlip = AddBlipForCoord(Config.Locations["main"].coords.x, Config.Locations["main"].coords.y, Config.Locations["main"].coords.z)
        SetBlipSprite(TowBlip, 477)
        SetBlipDisplay(TowBlip, 4)
        SetBlipScale(TowBlip, 0.6)
        SetBlipAsShortRange(TowBlip, true)
        SetBlipColour(TowBlip, 15)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentSubstringPlayerName(Config.Locations["main"].label)
        EndTextCommandSetBlipName(TowBlip)
    end
end)

RegisterNetEvent('mi-hauler:client:ToggleNpc')
AddEventHandler('mi-hauler:client:ToggleNpc', function()
    if QBCore.Functions.GetPlayerData().job.name == "hauler" then
        if isAttached then 
            QBCore.Functions.Notify("First Finish Your Work", "error")
            return
        end
        NpcOn = not NpcOn
        if NpcOn then
            local randomLocation = getRandomVehicleLocation()

            CurrentLocation.x = Config.Locations["truckspot"][randomLocation].spawn_coords.x
            CurrentLocation.y = Config.Locations["truckspot"][randomLocation].spawn_coords.y
            CurrentLocation.z = Config.Locations["truckspot"][randomLocation].spawn_coords.z
            CurrentLocation.w = Config.Locations["truckspot"][randomLocation].spawn_coords.w
            CurrentLocation.model = Config.Locations["truckspot"][randomLocation].model
            CurrentLocation.id = randomLocation
            CurrentLocation.target = Config.Locations["truckspot"][randomLocation].target_coords
            CurrentLocation.prize = Config.Locations["truckspot"][randomLocation].prize
            CurrentLocation.livery = Config.Locations["truckspot"][randomLocation].livery

            CurrentBlip = AddBlipForCoord(CurrentLocation.x, CurrentLocation.y, CurrentLocation.z)
            SetBlipColour(CurrentBlip, 3)
            SetBlipRoute(CurrentBlip, true)
            SetBlipRouteColour(CurrentBlip, 3)
        else
            -- Hapus Trailer tidak terpakai
            if TargetTrailer ~= nil then
                QBCore.Functions.DeleteVehicle(TargetTrailer)
            end

            if DoesBlipExist(CurrentBlip) then
                RemoveBlip(CurrentBlip)
                CurrentLocation = {}
                CurrentBlip = nil
                TargetBlip = nil
            end
            VehicleSpawned = false
        end
    end
end)

function getRandomVehicleLocation()
    local randomVehicle = math.random(1, #Config.Locations["truckspot"])
    while (randomVehicle == LastVehicle) do
        Citizen.Wait(10)
        randomVehicle = math.random(1, #Config.Locations["truckspot"])
    end
    return randomVehicle
end

function DrawText3D(x, y, z, text)
	SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(true)
    AddTextComponentString(text)
    SetDrawOrigin(x, y, z, 0)
    DrawText(0.0, 0.0)
    local factor = (string.len(text)) / 370
    DrawRect(0.0, 0.0+0.0125, 0.017+ factor, 0.03, 0, 0, 0, 75)
    ClearDrawOrigin()
    
end


Citizen.CreateThread(function()
    while true do 
        if isLoggedIn and PlayerJob.name == "hauler" then
            local ped = PlayerPedId()
            local pos = GetEntityCoords(ped)

            if #(pos - vector3(Config.Locations["vehicle"].coords.x, Config.Locations["vehicle"].coords.y, Config.Locations["vehicle"].coords.z)) < 30.0 then
                DrawMarker(2, Config.Locations["vehicle"].coords.x, Config.Locations["vehicle"].coords.y, Config.Locations["vehicle"].coords.z - 0.2, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.4, 0.4, 0.2, 255, 255, 255, 255, 0, 0, 0, 1, 0, 0, 0)
                if #(pos - vector3(Config.Locations["vehicle"].coords.x, Config.Locations["vehicle"].coords.y, Config.Locations["vehicle"].coords.z)) < 1.5 then

                    if IsPedInAnyVehicle(ped, false) then
                        DrawText3D(Config.Locations["vehicle"].coords.x, Config.Locations["vehicle"].coords.y, Config.Locations["vehicle"].coords.z, "~g~E~w~ - Store The Vehicle")
                    else
                        DrawText3D(Config.Locations["vehicle"].coords.x, Config.Locations["vehicle"].coords.y, Config.Locations["vehicle"].coords.z, "~g~E~w~ - Vehicle")
                    end

                    if IsControlJustReleased(0, 38) then
                        if IsPedInAnyVehicle(ped, false) then
                            DeleteVehicle(GetVehiclePedIsIn(ped))
                            TriggerServerEvent('mi-hauler:server:DoBail', false)
                        else
                            TriggerServerEvent('mi-hauler:server:DoBail', true)
                        end
                    end

                end 
            end

            if #(pos - vector3(Config.Locations["main"].coords.x, Config.Locations["main"].coords.y, Config.Locations["main"].coords.z)) < 30.0 then
                DrawMarker(2, Config.Locations["main"].coords.x, Config.Locations["main"].coords.y, Config.Locations["main"].coords.z - 0.2, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.4, 0.4, 0.2, 255, 255, 255, 255, 0, 0, 0, 1, 0, 0, 0)
                if #(pos - vector3(Config.Locations["main"].coords.x, Config.Locations["main"].coords.y, Config.Locations["main"].coords.z)) < 1.5 then
                    DrawText3D(Config.Locations["main"].coords.x, Config.Locations["main"].coords.y, Config.Locations["main"].coords.z, "~g~E~w~ - Payslip")
                    if IsControlJustReleased(0, 38) then
                        if JobsDone > 0 then
                            RemoveBlip(CurrentBlip)
                            TriggerServerEvent("mi-hauler:server:GetPaid", JobsDone)
                            JobsDone = 0
                            NpcOn = false
                        else
                            QBCore.Functions.Notify("You Havent Done Any Work Yet", "error")
                        end
                    end
                elseif #(pos - vector3(Config.Locations["main"].coords.x, Config.Locations["main"].coords.y, Config.Locations["main"].coords.z)) < 2.5 then
                    DrawText3D(Config.Locations["main"].coords.x, Config.Locations["main"].coords.y, Config.Locations["main"].coords.z, "Payslip")
                end  
            end

            if NpcOn and CurrentLocation ~= nil and next(CurrentLocation) ~= nil then
                if #(pos - vector3(CurrentLocation.x, CurrentLocation.y, CurrentLocation.z)) < 50.0 and not VehicleSpawned then

                    RemoveBlip(CurrentBlip)
                    VehicleSpawned = true
                    QBCore.Functions.SpawnVehicle(CurrentLocation.model, function(veh)
                        exports['LegacyFuel']:SetFuel(veh, 0.0)

                        if CurrentLocation.livery ~= nil then
                            SetVehicleModKit(veh, 0)
                            SetVehicleLivery(veh, tonumber(CurrentLocation.livery))
                        end

                        SetEntityHeading(veh, CurrentLocation.w)

                        TargetTrailer = veh
                    end, CurrentLocation, true) 
                    
                end
            end

            -- Jika Trailer Sudah Diattach
            local vehicle = GetEntityModel(GetVehiclePedIsIn(ped, false))
            if TargetHauler == vehicle then
                local trailerAttached, trailerModel = GetVehicleTrailerVehicle(GetVehiclePedIsUsing(ped))
                if trailerAttached and TargetBlip == nil then
                    TargetBlip = AddBlipForCoord(CurrentLocation.target.x, CurrentLocation.target.y, CurrentLocation.target.z)
                    SetBlipColour(TargetBlip, 3)
                    SetBlipRoute(TargetBlip, true)
                    SetBlipRouteColour(TargetBlip, 3)
                    isAttached = true
                end
            end
        else
            Citizen.Wait(1000)
        end
        Citizen.Wait(5)
    end
end)


-- Tujuan
Citizen.CreateThread(function()
    while true do 
        if isLoggedIn and CurrentLocation.target ~= nil then
            local ped = PlayerPedId()
            local targetLocation = CurrentLocation.target

            if PlayerJob.name == "hauler" then
                local pos = GetEntityCoords(ped)

                if IsPedInAnyVehicle(ped, false) then
                    if #(pos - vector3(targetLocation.x, targetLocation.y, targetLocation.z)) < 50.0 then
                        if TargetBlip ~= nil then
                            RemoveBlip(TargetBlip)
                            TargetBlip = nil
                        end
                        DrawMarker(2, targetLocation.x, targetLocation.y, targetLocation.z - 0.35, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.4, 0.4, 0.2, 255, 255, 255, 255, 0, 0, 0, 1, 0, 0, 0)
                        DrawText3D(targetLocation.x, targetLocation.y, targetLocation.z, "~g~E~w~ - Store Trailer")
                        if #(pos - vector3(targetLocation.x, targetLocation.y, targetLocation.z)) < 1.5 then

                            if IsControlJustReleased(0, 38) then
                                if IsPedInAnyVehicle(ped, false) then
                                    deliveredTrailer(GetVehiclePedIsIn(ped))
                                end
                            end

                        end 
                    end
                
                end
            
            else
                Citizen.Wait(1000)
            end
        else
            Citizen.Wait(1000)
        end
        Citizen.Wait(5)
    end
end)

function deliveredTrailer(vehicle)
    local ped = PlayerPedId()
    local trailerAttached, trailerModel = GetVehicleTrailerVehicle(GetVehiclePedIsUsing(ped))

    if trailerAttached then
        if trailerModel ~= TargetTrailer then
            QBCore.Functions.Notify("You Delivered A Wrong Trailer!", "error")
            return
        end

        QBCore.Functions.DeleteVehicle(TargetTrailer)

        JobsDone = JobsDone + 1
        VehicleSpawned = false
        isAttached = false

        QBCore.Functions.Notify("You Have Delivered A Trailer", "success")
        QBCore.Functions.Notify("A New Trailer Can Be Picked Up")

        -- Kirim Uang
        TriggerServerEvent('mi-hauler:server:delivered', CurrentLocation.prize)

        local randomLocation = getRandomVehicleLocation()
        CurrentLocation.x = Config.Locations["truckspot"][randomLocation].spawn_coords.x
        CurrentLocation.y = Config.Locations["truckspot"][randomLocation].spawn_coords.y
        CurrentLocation.z = Config.Locations["truckspot"][randomLocation].spawn_coords.z
        CurrentLocation.w = Config.Locations["truckspot"][randomLocation].spawn_coords.w
        CurrentLocation.model = Config.Locations["truckspot"][randomLocation].model
        CurrentLocation.id = randomLocation
        CurrentLocation.target = Config.Locations["truckspot"][randomLocation].target_coords
        CurrentLocation.prize = Config.Locations["truckspot"][randomLocation].prize
        CurrentLocation.livery = Config.Locations["truckspot"][randomLocation].livery

        CurrentBlip = AddBlipForCoord(CurrentLocation.x, CurrentLocation.y, CurrentLocation.z)
        SetBlipColour(CurrentBlip, 3)
        SetBlipRoute(CurrentBlip, true)
        SetBlipRouteColour(CurrentBlip, 3)
    else
        QBCore.Functions.Notify("You Have Dont Have A Trailer!", "error")
    end
end

RegisterNetEvent('mi-hauler:client:spawnHauler')
AddEventHandler('mi-hauler:client:spawnHauler', function()
    if QBCore.Functions.GetPlayerData().job.name == "hauler" then

        local spawnHauler = {}
        spawnHauler.x = Config.Locations["vehicle"].coords.x
        spawnHauler.y = Config.Locations["vehicle"].coords.y
        spawnHauler.z = Config.Locations["vehicle"].coords.z
        spawnHauler.w = Config.Locations["vehicle"].coords.w
        spawnHauler.model = Config.Locations["vehicle"].model

        QBCore.Functions.SpawnVehicle(spawnHauler.model, function(veh)
            TargetHauler = GetEntityModel(veh)
            SetVehicleNumberPlateText(veh, "TRKR"..tostring(math.random(1000, 9999)))
            SetEntityHeading(veh, spawnHauler.w)
            exports['LegacyFuel']:SetFuel(veh, 100.0)
            SetEntityAsMissionEntity(veh, true, true)

            TaskWarpPedIntoVehicle(PlayerPedId(), veh, -1)
            TriggerEvent("vehiclekeys:client:SetOwner", GetVehicleNumberPlateText(veh))
            SetVehicleEngineOn(veh, true, true)
            CurrentPlate = GetVehicleNumberPlateText(veh)
            for i = 1, 9, 1 do 
                SetVehicleExtra(veh, i, 0)
            end

        end, spawnHauler, true)
    end
end)
