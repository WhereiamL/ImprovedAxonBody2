-- globals
local hudForceHide = false
local hudPresence
local activated = false

----------------------------------------------------------
-------------------- Commands
----------------------------------------------------------


-- HUD

RegisterCommand('axonhide', function()
  hudForceHide = true
  ShowNotification("~y~Axon Body 2~s~ overlay now ~r~hidden~s~.")
end)

RegisterCommand('axonshow', function()
  hudForceHide = false
  ShowNotification("~y~Axon Body 2~s~ overlay now ~g~visible~s~.")
end)

-- Activation and deactivation

if Config.CommandBinding then
  RegisterKeyMapping('axon', 'Toggle Axon Body 2', 'keyboard', Config.CommandBinding)
end
RegisterCommand('axon', function ()
  if activated then
    DeactivateAB3()
    ShowNotification("~y~Axon Body 2~s~ has ~r~stopped recording~s~.")
  else
    local server_id = GetPlayerServerId(PlayerId())
    local player = exports.core_framework:getclientdept(server_id)
    if(player ~= nil) then
      if(player[server_id].dept ~= "Civilian") then
        ActivateAB3(player[server_id].char_name  ..  " (" .. player[server_id].dept .. ")")
        ShowNotification("~y~Axon Body 2~s~ has ~g~started recording~s~.")
      else 
        -- ShowNotification("You have to be ~r~on duty~s~ to enable ~y~Axon Body 2~s~.")
      end
    end
  end
end)

RegisterCommand('axonon', function ()
  local server_id = GetPlayerServerId(PlayerId())
  local player = exports[Config.framework_name]:getclientdept(server_id)
  if(player ~= nil) then
    if(player[server_id].dept ~= "Civilian") then
      if activated then
        ShowNotification("~y~Axon Body 2~s~ is already ~g~recording~s~.")
      else
        
        ActivateAB3(player[server_id].char_name  ..  " (" .. player[server_id].dept .. ")")
        ShowNotification("~y~Axon Body 2~s~ has ~g~started recording~s~.")
      end
    else 
      -- ShowNotification("You have to be ~r~on duty~s~ to use ~y~Axon Body 2~s~.")
    end
  end
end)

RegisterCommand('axonoff', function ()
  if not activated then
    ShowNotification("~y~Axon Body 2~s~ has already ~r~stopped recording~s~.")
  else
    DeactivateAB3()
    ShowNotification("~y~Axon Body 2~s~ has ~r~stopped recording~s~.")
  end
end)


----------------------------------------------------------
----------------------------------------------------------
----------------------------------------------------------


-- Events

RegisterNetEvent("AB2:SetState", function(state)
  if state == true then
    ActivateAB3()
  elseif state == false then
    DeactivateAB3()
  end
end)

RegisterNetEvent("AB2:ServerBeep", function(netId)
  local otherPed = GetPlayerPed(GetPlayerFromServerId(netId))
  local ped = PlayerPedId()
  if (IsPedInAnyVehicle(ped) == IsPedInAnyVehicle(otherPed)) or not IsPedInAnyVehicle(ped) then
    local volume = 10
    local radius = 10
    
    local playerCoords = GetEntityCoords(ped);
    local targetCoords = GetEntityCoords(otherPed);
    
    local distance = Vdist(playerCoords.x, playerCoords.y, playerCoords.z, targetCoords.x, targetCoords.y, targetCoords.z);
    local distanceVolumeMultiplier = volume / radius;
    local distanceVolume = volume - (distance * distanceVolumeMultiplier);
    
    if (distance <= radius) then
      SendNUIMessage({ AxonBeep = { volume = distanceVolume } })
    end
  end
end)

-- Utils

function ActivateAB3(name)
  if activated then
    return error("AB2 attempted to activate when already active.")
  end

  activated = true

  -- beeper
  -- Citizen.CreateThread(function()
  --   Citizen.Wait(12e4)
  --   while activated do
  --     TriggerServerEvent("AB2:ClientBeep")
  --     Citizen.Wait(12e4)
  --   end
  -- end)

  -- HUD
  Citizen.CreateThread(function()
    while activated do
      Citizen.Wait(0)
      if (GetFollowPedCamViewMode() == 4 or Config.ThirdPersonMode) and not hudForceHide then
        if not hudPresence then
          SetHudPresence(true, name)
        end
      elseif hudPresence then
        SetHudPresence(false, name)
      end
    end
    SetHudPresence(false, name)
  end)
end

function DeactivateAB3()
  if not activated then
    return error("AB2 attempted to deactivate when already deactivated.")
  end

  activated = false
end

function SetHudPresence(state, charname)
  SendNUIMessage({AxonUIPresence = state, name = charname})
  hudPresence = state
end

function ShowNotification(message)
  BeginTextCommandThefeedPost("STRING")
  AddTextComponentSubstringPlayerName(message)
  EndTextCommandThefeedPostTicker(true, false)
end
