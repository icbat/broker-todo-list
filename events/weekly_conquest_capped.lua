local ADDON, namespace = ...
local L = namespace.L

namespace.registerOnUpdate({
    name = "Great Vault: PvP",
    percentCompleted = function() 
        local progress = C_WeeklyRewards.GetConquestWeeklyProgress()
        -- TODO test the edge cases. is Progress only ever out of the current step, or is it cumulative?
        -- namespace.printList(progress)
        
        local overallProgress = progress['unlocksCompleted'] / progress['maxUnlocks']
        if overallProgress == 1 then
            return overallProgress
        end

        local towardsNextStep = progress['progress'] / progress['maxProgress']
        local oneStep = 1 / progress['maxUnlocks']
        return overallProgress + oneStep * towardsNextStep
    end
})
