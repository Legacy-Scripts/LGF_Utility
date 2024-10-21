Config = {}


Config.isPlayerDead = function()
    if GetResourceState('ars_ambulancejob'):find('start') then
        return LocalPlayer.state.dead
    else
        return IsEntityDead(cache.ped)
    end
end
