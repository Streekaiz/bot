local Environment = getgenv() or _G
local Author = "Streekaiz"
local Repository = "Squidhook"
local LoadTick = tick()

local LoadedDependencies, Dependencies = {}, {
    "Clients",
    "Instances",
    "Miscallaenous",
    "Services",
    "Signals",
    "String",
    "Tween"
}

for Index, Dependency in next, Dependencies do 
    local Success = false 
    local Source

    Success, Source = pcall(function(...)
        return loadstring(
            game:HttpGet(
                string.format(
                    'https://raw.githubusercontent.com/%s/%s/main/dependencies/%s.luau', 
                    Author,
                    Repository,
                    Dependency
                )
            ), Dependency 
        )
    end)

    if not Success then 
        warn(
            string.format(
                "failed to load dependency: %s, error: %s, ignoring error; loading other dependencies",
                Dependency,
                Source
            )
        )
    end 

    LoadedDependencies[Dependency] = Source()
    local NewTick = tick()
    warn("loaded dependency in " .. NewTick - LoadTick)
    LoadTick = NewTick 
end

Environment[Repository] = {}
Environment[Repository].Dependencies = LoadedDependencies 

Environment[Repository]:GetInterface = function(Name : string)

end 

return Environment[Repository]