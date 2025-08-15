-- // Startup
local Environment = getgenv() or _G
local Squidhook = Environment.Squidhook

-- // Dependencies 
local Dependencies = Squidhook.Dependencies 
local Clients = Dependencies.Clients 
local Instances = Dependencies.Instances 
local Miscallaenous = Dependencies.Miscallaenous 
local Services = Dependencies.Services 
local Signals = Dependencies.Signals 
local Tween = Dependencies.Tween 

-- // Interface 
local Library = Squidhook.Interface.Library
local Window = Squidhook.Interface.Window 

-- // Services 
local Workspace = Services:Get("Workspace")
local Players = Services:Get("Players")
local UserInputService = Services:Get("UserInputService")
local RunService = Services:Get("RunService")
local ReplicatedStorage = Services:Get("ReplicatedStorage")

-- // Vars
local LocalPlayer = Players.LocalPlayer 
local Camera = Workspace.CurrentCamera 

-- // Game 
local Modules = {}; do 
    local Timer = tick()
    for Index, Module in next, ReplicatedStorage:FindFirstChild("Modules"):GetChildren() do 
        if Module.ClassName == "ModuleScript" then 
            Modules[Module.Name] = require(Module)
            local NewTimer = Timer  
            Library:Notification({
                Lifetime = 1.5,
                Name = string.format(
                    "Loaded module: %s in %s milliseconds",
                    Module,
                    tostring(NewTimer - Timer)
                )
            })
            Timer = NewTimer 
        end
    end
end

-- // Panel
local Panel = Library:Panel({
    Name = "squidhook",
    ButtonName = "Menu"
}); do 
    local Pages = {
        Legit = Panel:Tab({Name = "Legit"}),
        Rage = Panel:Tab({Name = "Rage"}),
        Visual = Panel:Tab({Name = "Visuals"}),
        Misc = Panel:Tab({Name = "Misc"})
    }


end

local Settings = Library:Panel({
    Name = "settings",
    ButtonName = "Interface"
}); do 
    local Section
    local Pages = {
        Theme = Settings:Tab({Name = "Theme"}),
        Config = Settings:Tab({Name = "Config"})
    }

    Section = Pages.Config:Column({Fill = true}):Section({Name = "Configuration"}); do 
        Library.ConfigList = Section:List({Name = "Files List", Flag = "ConfigList", Size = 100})
        Section:Textbox({Name = "File Name", Flag = "ConfigName"})
        Section:Button({Name = "Save", Callback = function(...)
            writefile(Library.Directory .. "/configs/" .. Library.Flags.ConfigName .. ".cfg", Library:GetConfig())
            Library:Notification({Name = "Saved config.", Lifetime = 5})
            Library:UpdateConfigList()
        end})
        Section:Button({Name = "Load", Callback = function(...)
            writefile(Library.Directory .. "/configs/" .. Library.Flags.ConfigName .. ".cfg", Library:GetConfig())
            Library:Notification({Name = "Loaded config.", Lifetime = 5})
            Library:UpdateConfigList()
        end})

        Section:Button({Name = "Delete", Callback = function() 
            delfile(Library.Directory .. "/configs/" .. Library.Flags.ConfigName .. ".cfg")  
            Library:Notification({Name = "Deleted config.", Lifetime = 5})
            Library:UpdateConfigList() 
        end})
    end

    Section = Pages.Theme:Column({Fill = true}):Section({Name = "Colors"}); do 
        local Preset = {
            Inline = Color3.fromRGB(46, 46, 46),
            Outline = Color3.fromRGB(10, 10, 15),
            Accent = Color3.fromRGB(19, 128, 225),
            Background = Color3.fromRGB(20, 20, 25),              
            Misc = Color3.fromRGB(30, 30, 35),
            TextColor = Color3.fromRGB(245, 245, 245),
            Unselected = Color3.fromRGB(145, 145, 145),
            Tooltip = Color3.fromRGB(73, 73, 73),
            SecondaryMisc = Color3.fromRGB(23, 23, 28),
            Font = "ProggyClean",
            TextSize = 12
        }

        Section:Label({Name = "Accent"}):Colorpicker({
            Color = Preset.Accent,
            Callback = function(Color)
                Library:RefreshTheme("Accent", Color)
            end
        })

        Section:Label({Name = "Background"}):Colorpicker({
            Color = Preset.Background,
            Callback = function(Color)
                Library:RefreshTheme("Background", Color)
            end
        })

        Section:Label({Name = "Inline"}):Colorpicker({
            Color = Preset.Inline,
            Callback = function(Color)
                Library:RefreshTheme("Inline", Color)
            end
        })

        Section:Label({Name = "Outline"}):Colorpicker({
            Color = Preset.Outline,
            Callback = function(Color)
                Library:RefreshTheme("Outline", Color)
            end
        })

        Section:Label({Name = "Text"}):Colorpicker({
            Color = Preset.TextColor,
            Callback = function(Color)
                Library:RefreshTheme("TextColor", Color)
            end
        })

        Section:Label({Name = "Unselected"}):Colorpicker({
            Color = Preset.Unselected,
            Callback = function(Color)
                Library:RefreshTheme("Unselected", Color)
            end
        })

        Section:Label({Name = "Tooltip"}):Colorpicker({
            Color = Preset.Tooltip,
            Callback = function(Color)
                Library:RefreshTheme("Tooltip", Color)
            end
        })

        Label = Section:Label({Name = "Element Gradient"})

        Label:Colorpicker({
            Flag = "THEME_GRADIENT_1",
            Color = Preset.Misc,
            Callback = function(Color)
                Library:RefreshTheme("Misc", Color)

                for _, Sequence in next, Squidhook.Interface.Themes.Gradients.Elements do 
                    Sequence.Color = ColorSequence.new({
                        ColorSequenceKeypoint.new(0, Library.Flags["THEME_GRADIENT_1"]),
                        ColorSequenceKeypoint.new(1, Library.Flags["THEME_GRADIENT_2"])
                    })
                end
            end
        })

        Label:Colorpicker({
            Flag = "THEME_GRADIENT_2",
            Color = Preset.SecondaryMisc,
            Callback = function(Color)
                Library:RefreshTheme("SecondaryMisc", Color)

                for _, Sequence in next, Squidhook.Interface.Themes.Gradients.Elements do 
                    Sequence.Color = ColorSequence.new({
                        ColorSequenceKeypoint.new(0, Library.Flags["THEME_GRADIENT_1"]),
                        ColorSequenceKeypoint.new(1, Library.Flags["THEME_GRADIENT_2"])
                    })
                end
            end
        })
    end

    Section = Pages.Theme:Column({Fill = true}):Section({Name = "Interface"}); do 
        Section:Label({Name = "Menu Bind"}):Keybind({Name = "Menu Bind", Key = Enum.KeyCode.E, Callback = Window.SetVisible})
        Section:Slider({Name = "Tween Speed", Min = 0, Max = 3, Decimal = Library.DraggingSpeed, Default = .3, Callback = function(num)
            Library.TweeningSpeed = num
        end})

        Section:Dropdown({Name = "Tweening Style", Options = {"Linear", "Sine", "Back", "Quad", "Quart", "Quint", "Bounce", "Elastic", "Exponential", "Circular", "Cubic"}, Flag = "LibraryEasingStyle", Default = "Quint", Callback = function(Option)
            Library.EasingStyle = Enum.EasingStyle[Option]
        end})

        Section:Slider({Name = "Dragging Speed", Min = 0, Max = 1, Decimal = .01, Default = .05, Callback = function(num)
            Library.DraggingSpeed = num
        end})

        Section:Toggle({Name = "Watermark", Callback = Window.SetWatermarkVisible})
        Section:Toggle({Name = "Keybind List", Callback = function(State)
            Library.KeyblindList.Items.Holder.Visible = State 
            Library.KeybindList.Items.List.Visible = State 
        end})
        Section:Textbox({Name = "Custom Menu Name", Default = Window.Name, Callback = function(Name)
            Window.Name = Name 
        end})
        Section:Dropdown({Name = "Interface Font", Options = {"ProggyClean", "Tahoma", "Verdana", "SmallestPixel", "ProggyTiny", "Minecraftia", "Tahoma Bold", "Rubik"}, Default = "ProggyClean", Callback = function(Font)
            for _, Text in Squidhook.Interface.Themes.Utility.TextColor.TextColor3 do 
                Text.FontFace = Squidhook.Interface.Fonts[Font]
            end
        end})

        Section:Slider({Name = "TextSize", Default = 12, Decimal = 1, Min = 1, Max = 30, Callback = function(Size)
            for _, Text in Squidhook.Interface.Themes.Utility.TextColor.TextColor3 do 
                Text.TextSize = Size
            end
        end})
    end
end
