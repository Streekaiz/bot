local Environment : {[any] : any} = getgenv() or _G; do 
    local Author : string = "Streekaiz"
    local Repository : string = "bot"
    local Timer : number = tick()

    local Squidhook : {[any] : any} = {Dependencies = {}}; do 
        Squidhook.LoadInterface = function(self, Interface : string)
            return loadstring(
                game:HttpGet(
                    string.format(
                        'https://raw.githubusercontent.com/%s/%s/refs/heads/master/interfaces/%s.luau', 
                        Author,
                        Repository,
                        string.lower(Interface)
                    )
                ), Interface
            )
        end

        local Interface : {[any] : any} = Squidhook:LoadInterface("octohook")()
        local Window : {[any] : any} = Interface.Library:Window({
            Name = "squidhook"
        })

        Interface.Library:Notification({
            Lifetime = 5,
            Name = string.format(
                "Loaded interface in %s milliseconds",
                tostring(tick() - Timer)
            )
        })

        Squidhook.Interface = Interface 
        Squidhook.Window = Window 

        Timer = tick()
    end 

    for Index, Dependency in pairs({
        "Clients",
        "Instances",
        "Miscallaenous",
        "Services",
        "Signals",
        "String",
        "Tween"
    }) do 
        local Success : boolean = false 
        local Content : (any) = ""

        Success, Content = pcall(function(... : any)
            return loadstring(
                game:HttpGet(
                    string.format(
                        'https://raw.githubusercontent.com/%s/%s/refs/heads/master/dependencies/%s.luau', 
                        Author,
                        Repository,
                        string.lower(Dependency)
                    )
                )
            )
        end)

        if not Success then 
            Squidhook.Interface.Library:Notification({
                Name = string.format(
                    "Failed to load dependency: %s, error message: %s",
                    Dependency,
                    tostring(Content)
                )
            })
            continue 
        end

        Squidhook.Dependencies[Dependency] = Content()

        local NewTimer = tick()

        Squidhook.Interface.Library:Notification({
            Lifetime = 5,
            Name = string.format(
                "Successfully loaded dependency: %s in %s milliseconds",
                Dependency,
                tostring(NewTimer - Timer)
            )
        })

        Timer = NewTimer 
    end

    Environment.Squidhook = Squidhook 
end