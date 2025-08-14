local Environment = getgenv() or _G
local Author = "Streekaiz"
local Repository = "bot"
local EnvName = "Squidhook"
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
	setclipboard(string.format(
                    'https://raw.githubusercontent.com/%s/%s/refs/heads/main/dependencies/%s.luau', 
                    Author,
                    Repository,
                    string.lower(Dependency)
                ))
    Success, Source = pcall(function(...)
        return loadstring(
            game:HttpGet(
                string.format(
                    'https://raw.githubusercontent.com/%s/%s/refs/heads/master/dependencies/%s.luau', 
                    Author,
                    Repository,
                    string.lower(Dependency)
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

		continue
    end 

    LoadedDependencies[Dependency] = Source()
    local NewTick = tick()
    warn("loaded dependency in " .. NewTick - LoadTick)
    LoadTick = NewTick 
end

Environment[EnvName] = {}
Environment[EnvName].Dependencies = LoadedDependencies 
Environment[EnvName].GetInterface = function(self, Name)
    return loadstring(
        game:HttpGet(
            string.format(
                'https://raw.githubusercontent.com/%s/%s/refs/heads/master/interfaces/%s.luau', 
                Author,
                Repository,
                string.lower(Name)
            )
        ), Name
    )
end 

return Environment[Repository]