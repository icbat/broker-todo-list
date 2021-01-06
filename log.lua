local ADDON, namespace = ...

local DEBUG = true

namespace.log = function(...)
    if DEBUG then
        print(ADDON, ...)
    end
end

namespace.printList = function(list)
    namespace.log("printing list", list)
    for i, v in pairs(list) do
        print(i, v)
    end
end
