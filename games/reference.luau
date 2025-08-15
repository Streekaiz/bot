local Environment : {[any] : any} = getgenv() or _G
local Script : {[any] : any} = Environment.Skeptical or Environment.Script 

local Interface : {[any] : any} = loadstring(game:HttpGet("https://raw.githubusercontent.com/Streekaiz/Skeptical/refs/heads/main/interfaces/bitchbot-v1.luau"))()
local Services : {[any] : any} = Script.Dependencies.Services
local Clients : {[any] : any} = Script.Dependencies.Clients
local Miscallaenous : {[any] : any} = Script.Dependencies.Miscallaenous

local Players = Services:Get("Players")
local ReplicatedStorage = Services:Get("ReplicatedStorage")

local Camera = workspace.CurrentCamera 
local LocalPlayer = Players.LocalPlayer 

local Modules : {[any] : any} = {}; do 
    local LoadTick = tick()
    for Index, Module in next, ReplicatedStorage.Modules:GetChildren() do 
		if Module.ClassName == "ModuleScript" then 
			Modules[Module.Name] = require(Module)
			local NewTick = tick()
			Interface:Notification("Loaded " .. Module.Name .. " in " .. NewTick - LoadTick, 5)
			LoadTick = NewTick 
		end 
    end 
end 

local Window = Interface:Window({
    Name = "bitchbot"
}); do 
    local Page : {[any] : any}
    local Section : {[any] : any}
    local Pages = {
        Legit = Window:Page({Name = "Legit", Columns = 3}),
        Rage = Window:Page({Name = "Rage", Columns = 3}),
        Esp = Window:Page({Name = "ESP", Columns = 3}),
        Visual = Window:Page({Name = "Visual", Columns = 3}),
        Settings = Window:Page({Name = "Settings", Columns = 3})
    }; do 
        Page = Pages.Legit 
        Section = Page:Section({Name = "Aim Assist", Side = 1})

        Section = Page:Section({Name = "Silent Aim", Side = 2})
        Section:Toggle({Name = "enabled", Flag = "silentAimEnabled"}):Keybind({Name = "Silent Aim", Flag = "silentAimKeybind"})
        Section:Dropdown({Name = "body priority", Flag = "silentAimTargets", Items = {"Head", "Torso", "Arms" ,"Legs"}, Multi = true, Default = {"Head", "Torso"}})
        Section:Slider({Name = "hit chance", Flag = "silentAimChance", Min = 0, Max = 100, Default = 100, Suffix = "%"})
        Section:Dropdown({Name = "validation checks", Flag = "silentAimChecks", Items = {"team", "behind wall", "invisibility"}, Multi = true, Default = {"team", "behind wall"}})
        Section:Toggle({Name = "predict trajectory", Flag = "silentAimPredictionEnabled"})
        Section:Dropdown({Name = "prediction method", Flag = "silentAimPredictionMethod", Default = "standard", Items = {"standard", "bow", "other guns idk"}})
        Section:Toggle({Name = "limit to fov", Flag = "silentAimLimit"})
        Section:Toggle({Name = "show fov", Flag = "silentAimVisual"}):Colorpicker({Name = "color", Flag = "silentAimColor"})
        Section:Slider({Name = "fov radius", Flag = "silentAimRadius", Min = 0, Max = 360, Default = 180, Suffix = "px"})
    end 
end 

local OldUtilityRaycast = Modules["Utility"].Raycast; 

Modules["Utility"].Raycast = function(...)
    local Arguments = {...}

    if Interface.Flags.silentAimEnabled then 
        local Target, Magnitude, Data = Clients:GetClosestPlayer("Mouse", function(Player, Character, Humanoid, HumanoidRootPart, Health)
            if (table.find(Interface.Flags.silentAimChecks, "team") and Clients:IsFriendly(Player)) then 
                return false 
            end 

            if (table.find(Interface.Flags.silentAimChecks, "invisible") and Character.Head.Transparency == 1) then 
                return false 
            end 

            print(Miscallaenous:Raycast(HumanoidRootPart, HumanoidRootPart.Position, Camera.CFrame.Position))
            
            if table.find(Interface.Flags.silentAimChecks, "behind wall") then 
                return Miscallaenous:Raycast(HumanoidRootPart, HumanoidRootPart.Position, Camera.CFrame.Position)
            end 

            return true 
        end)

        if Target then 
            Arguments[3] = Target.Character.HumanoidRootPart.Position
        end 
    end 
    
    return OldUtilityRaycast(table.unpack(Arguments))
end
