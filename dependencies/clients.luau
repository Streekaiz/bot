local Library = { }; do 
    Library.__index = Library 

    local Workspace = workspace 
    local Players = cloneref and cloneref(game:GetService("Players")) or game:GetService("Players")
    local UserInputService = cloneref and cloneref(game:GetService("UserInputService")) or game:GetService("UserInputService")

    local Camera = Workspace.CurrentCamera 
    local LocalPlayer = Players.LocalPlayer 

    local FindFirstChild = Workspace.FindFirstChild 
    local FindFirstChildOfClass = Workspace.FindFirstChildOfClass
    local TableFind = table.find 
    local Vector2New = Vector2.new 

    Library.GetCharacter = function(self, Player)
        return Player.Character 
    end 

    Library.GetHumanoid = function(self, Character)
        return FindFirstChildOfClass(Character, "Humanoid") 
    end 

    Library.GetRoot = function(self, Character)
        return FindFirstChild(Character, "HumanoidRootPart") 
    end

    Library.GetHealth = function(self, Humanoid)
        return Humanoid.Health, Humanoid.MaxHealth  
    end 

    Library.IsAlive = function(self, Player)
        local Character = Library:GetCharacter(Player)
        if not Character then 
            return false 
        end 

        local Humanoid = Library:GetHumanoid(Character)
        local HumanoidRootPart = Library:GetRoot(Character)

        if not Humanoid or not HumanoidRootPart then 
            return false 
        end 

        local Health = Library:GetHealth(Humanoid)

        if Health < 0 then 
            return false 
        end 

        return true, Character, Humanoid, HumanoidRootPart, Health 
    end 

    Library.IsFriendly = function(self, Player)
        return Player.Team == LocalPlayer.Team 
    end 

    Library.IsEnemy = function(self, Player)
        return Player.Team ~= LocalPlayer.Team 
    end 

    Library.GetBodyParts = function(self, Character, RootPart, Indexes, Hitboxes)
        local Parts = {}
        local BodyParts = Hitboxes or { "Head", "Torso", "Arms", "Legs" }

        for Index, Part in pairs(Character:GetChildren()) do
            if Part:IsA("BasePart") and Part ~= RootPart then
                if TableFind(BodyParts, "Head") and Part.Name:lower():find("head") then
                    Parts[Indexes and Part.Name or #Parts + 1] = Part
                elseif TableFind(BodyParts, "Torso") and Part.Name:lower():find("torso") then
                    Parts[Indexes and Part.Name or #Parts + 1] = Part
                elseif TableFind(BodyParts, "Arms") and Part.Name:lower():find("arm") then
                    Parts[Indexes and Part.Name or #Parts + 1] = Part
                elseif TableFind(BodyParts, "Legs") and Part.Name:lower():find("leg") then
                    Parts[Indexes and Part.Name or #Parts + 1] = Part
                elseif
                    (TableFind(BodyParts, "Arms") and Part.Name:lower():find("hand"))
                    or (TableFind(BodyParts, "Legs") and Part.Name:lower():find("foot"))
                then
                    Parts[Indexes and Part.Name or #Parts + 1] = Part
                end
            end
        end

        return Parts
    end

    Library.GetClosestPlayer = function(self, Mode, Validate)
        Mode = Mode or "Mouse" -- // Mouse, Character / will be used at some point
        Validate = Validate or function() 
            return true 
        end

        local Mouse = UserInputService:GetMouseLocation()

        local Target = nil 
        local Magnitude = math.huge  
        local Data

        for Index, Player in next, Players:GetPlayers() do 
            if Player == LocalPlayer then
                continue 
            end 

            local Alive, Character, Humanoid, HumanoidRootPart, Health = Library:IsAlive(Player)
            if not Alive then 
                continue 
            end 
                
            local ScreenPosition = Camera:WorldToViewportPoint(HumanoidRootPart.Position)
            local MousePosition = Vector2New(Mouse.X, Mouse.Y)
            local PlayerMagnitude = (Vector2New(ScreenPosition.X, ScreenPosition.Y) - MousePosition).Magnitude

            if not Validate(Player, Character, Humanoid, HumanoidRootPart, Health) then 
                continue 
            end 
        
            if PlayerMagnitude < Magnitude then 
                Target = Player 
                Magnitude = PlayerMagnitude 
                Data = {
                    Character = Character, 
                    Humanoid = Humanoid, 
                    HumanoidRootPart = HumanoidRootPart, 
                    Health = Health
                }
            end 
        end

        return Target, Magnitude, Data 
    end 

    Library.GetClosestPart = function(self, Character, List)
        local Mouse = UserInputService:GetMouseLocation()

        local Target = nil 
        local Magnitude = math.huge  

        for Index, Part in next, Character:GetChildren() do 
            if not Part:IsA("BasePart") then 
                continue 
            end 

            local Position = Camera:WorldToViewportPoint(Part.Position)
            local PartMagnitude = (Vector2New(Position.X, Position.Y) - Mouse).Magnitude

            if Magnitude > PartMagnitude and TableFind(List, Part) then
                Target = Part
                Magnitude = PartMagnitude
            end
        end 

        return Target, Magnitude 
    end 
end

return Library
