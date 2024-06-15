--ok so don't aks me how this works cus i stole it from ff and im shocked it worked so well
--sorry guys ._.

local json = require "json"
FHAC.savedata = FHAC.savedata or {}
FHAC.gamestarted = FHAC.gamestarted or false

local SavedataConfig = {
    Persistent = {
        Config = {}
    },
    Run = {},
}

function AddConfig(name, default)

end

function FHAC.SaveSaveData() -- imagine writing out savedata again hahahaaHAHAHAHAHANH FUCK
    FHAC.savedata.config = {
        AutoDebug5 = FHAC.AutoDebug5,
        ShowRoomNames = FHAC.ShowRoomNames,
        RoomNameOpacity = FHAC.RoomNameOpacity,
        RoomNameScale = FHAC.RoomNameScale,
    }

    local psave = mod.getFieldInit(FiendFolio.savedata, 'run', 'playerSaveData', {})
    for i = 1, game:GetNumPlayers() do
        local p = Isaac.GetPlayer(i - 1)
        local data = p:GetData()

        local playerSave = {}
        if data.ffsavedata then
            for key, val in pairs(data.ffsavedata) do
                playerSave[key] = val
            end
        end

        psave[i] = playerSave
    end

    Isaac.SaveModData(mod, json.encode(FHAC.savedata))
end

function FiendFolio.LoadSaveData()
    if not mod:HasData() then
        FiendFolio.SaveSaveData()
        print("FiendFolio mod save initialisation")
    else
        FiendFolio.savedata = json.decode(mod:LoadData())

        local config = FHAC.savedata.config
        if config then
            FHAC.AutoDebug5                = config.AutoDebug5 or FHAC.AutoDebug5
            FHAC.ShowRoomNames             = config.ShowRoomNames or FHAC.ShowRoomNames
            FHAC.RoomNameOpacity           = config.RoomNameOpacity or FHAC.RoomNameOpacity
            FHAC.RoomNameScale             = config.RoomNameScale or FHAC.RoomNameScale
            FHAC.DeathFortune              = config.GreatFortune or FHAC.DeathFortune
        end
    end
end

FHAC.LoadSaveData()

--originally didn't need this but an upcoming item went "haha"
FHAC:AddCallback(ModCallbacks.MC_POST_PLAYER_INIT, function(_, player)
    local basedata = player:GetData()
    basedata.ffsavedata = {}
    local data = basedata.ffsavedata

    data.RunEffects = {
        RoomClearCounts = {}, -- intended for keeping track of clear counts since picking up item
        Collectibles = {},
        Trinkets = {},
        TrueRoomClearCounts = {}, -- The above one gets reset whenever you take damage.
    }
end)

FHAC:AddCallback(ModCallbacks.MC_POST_GAME_STARTED, function(_, continuing)
	FHAC.DebugString("PREHOPESAVELOAD")
    FHAC.LoadSaveData()
	FHAC.DebugString("POSTHOPESAVELOAD")

    if not continuing then
        FHAC.savedata.run = {}
    end

    if continuing then
        for i = 1, game:GetNumPlayers() do
            local p = Isaac.GetPlayer(i - 1)
            local pdata = p:GetData()

            for key, val in pairs(FHAC.savedata.run.playerSaveData[i]) do
                pdata.ffsavedata[key] = val
            end

            AddPlayerShardHearts(p, 0)
            p:AddCacheFlags(CacheFlag.CACHE_ALL)
            p:EvaluateItems()
        end
    end

    gamestarted = true
end)

FHAC:AddCallback(ModCallbacks.MC_PRE_GAME_EXIT, function()
	Isaac.DebugString("PREGAMEEXITPRESAVE")
    FHAC.SaveSaveData()
	Isaac.DebugString("PREGAMEEXITPOSTSAVE")
    FHAC.gamestarted = false
end)

FHAC:AddCallback(ModCallbacks.MC_POST_GAME_END, function()
    FHAC.gamestarted = false
end)

FHAC:AddCallback(ModCallbacks.MC_POST_NEW_LEVEL, function()
    FHAC.getFieldInit(FHAC.savedata, 'run', {}).level = {}
    if FHAC.gamestarted then
        FHAC.SaveSaveData()
    end
end)