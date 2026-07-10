local loadingScreenFinished = false
local ready = false
local guiEnabled = false

ESX.SecureNetEvent("esx_identity:alreadyRegistered", function()
    while not loadingScreenFinished do
        Wait(100)
    end
    TriggerEvent("esx_skin:playerRegistered")
end)

ESX.SecureNetEvent("esx_identity:setPlayerData", function(data)
    SetTimeout(1, function()
        ESX.SetPlayerData("name", ("%s %s"):format(data.firstName, data.lastName))
        ESX.SetPlayerData("firstName", data.firstName)
        ESX.SetPlayerData("lastName", data.lastName)
        ESX.SetPlayerData("dateofbirth", data.dateOfBirth)
        ESX.SetPlayerData("sex", data.sex)
        ESX.SetPlayerData("height", data.height)
    end)
end)

AddEventHandler("esx:loadingScreenOff", function()
    loadingScreenFinished = true
end)

RegisterNUICallback("ready", function(_, cb)
    ready = true
    cb(1)
end)

function setGuiState(state)
    SetNuiFocus(state, state)
    guiEnabled = state
    LocalPlayer.state:set('identityOpen', state, true)

    -- if state then
    --     exports.krs_hud:HideHud()
    -- else
    --     exports.krs_hud:ShowHud()
    -- end

    SendNUIMessage({ type = "enableui", enable = state, colors = Config.Colors })
end


RegisterNetEvent("esx_identity:showRegisterIdentity", function()
    TriggerEvent("esx_skin:resetFirstSpawn")
        while not (ready and loadingScreenFinished) do
            print("Waiting for esx_identity NUI..")
            Wait(100)
        end
    if not ESX.PlayerData.dead then
        setGuiState(true)
    end
end)

RegisterNUICallback("register", function(data, cb)
        if not guiEnabled then
            return
        end

        ESX.TriggerServerCallback("esx_identity:registerIdentity", function(callback)
            if not callback then
                return
            end

            ESX.ShowNotification(TranslateCap("thank_you_for_registering"))
            setGuiState(false)

            if not ESX.GetConfig().Multichar then
                TriggerEvent("esx_skin:playerRegistered")
            end
        end, data)
        cb(1)
end)

AddEventHandler('onClientResourceStart', function(resourceName)
    if resourceName ~= GetCurrentResourceName() then
        return
    end

    if NetworkIsSessionStarted() then
        loadingScreenFinished = true
    end
end)

RegisterCommand("testidentity", function()
    if not ready then
        print("[esx_identity] NUI non ancora pronta, riprova in qualche secondo.")
        return
    end

    setGuiState(true)
end, false)

RegisterCommand("closeidentity", function()
    setGuiState(false)
end, false)