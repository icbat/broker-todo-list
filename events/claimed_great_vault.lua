local ADDON, namespace = ...
local L = namespace.L

namespace.registerOnUpdate({
    name = "Claimed Great Vault Reward",
    percentCompleted = function() return C_WeeklyRewards.CanClaimRewards() end
})
