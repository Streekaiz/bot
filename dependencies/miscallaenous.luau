local Library = { }; do 
    Library.__index = Library
    
    local Workspace = workspace
    local Vector3New = Vector3.new

    Library.GetPoints = function(self, BasePart)
        return {
            BasePart.Position + (Vector3New(BasePart.Size.X, 0, 0) / 2),
            BasePart.Position - (Vector3New(BasePart.Size.X, 0, 0) / 2),
            BasePart.Position + (Vector3New(0, BasePart.Size.Y, 0) / 2),
            BasePart.Position - (Vector3New(0, BasePart.Size.Y, 0) / 2),
            BasePart.Position + (Vector3New(0, 0, BasePart.Size.Z) / 2),
            BasePart.Position - (Vector3New(0, 0, BasePart.Size.Z) / 2),
            BasePart.Position,
        }
    end

    Library.GetMultiPoints = function(self, BasePart)
        return {
            BasePart.Position + (Vector3New(BasePart.Size.X, 0, 0) / 2),
            BasePart.Position - (Vector3New(BasePart.Size.X, 0, 0) / 2),
            BasePart.Position + (Vector3New(0, BasePart.Size.Y, 0) / 2),
            BasePart.Position - (Vector3New(0, BasePart.Size.Y, 0) / 2),
            BasePart.Position + (Vector3New(0, 0, BasePart.Size.Z) / 2),
            BasePart.Position - (Vector3New(0, 0, BasePart.Size.Z) / 2),
            BasePart.Position + (Vector3New(BasePart.Size.X, BasePart.Size.Y, 0) / 2),
            BasePart.Position - (Vector3New(BasePart.Size.X, BasePart.Size.Y, 0) / 2),
            BasePart.Position + (Vector3New(0, BasePart.Size.Y, BasePart.Size.Z) / 2),
            BasePart.Position - (Vector3New(0, BasePart.Size.Y, BasePart.Size.Z) / 2),
            BasePart.Position + (Vector3New(BasePart.Size.X, 0, BasePart.Size.Z) / 2),
            BasePart.Position - (Vector3New(BasePart.Size.X, 0, BasePart.Size.Z) / 2),
            BasePart.Position + (Vector3New(-BasePart.Size.X, BasePart.Size.Y, 0) / 2),
            BasePart.Position + (Vector3New(BasePart.Size.X, -BasePart.Size.Y, 0) / 2),
            BasePart.Position + (Vector3New(0, -BasePart.Size.Y, BasePart.Size.Z) / 2),
            BasePart.Position + (Vector3New(0, BasePart.Size.Y, -BasePart.Size.Z) / 2),
            BasePart.Position + (Vector3New(-BasePart.Size.X, 0, BasePart.Size.Z) / 2),
            BasePart.Position + (Vector3New(BasePart.Size.X, 0, -BasePart.Size.Z) / 2),
            BasePart.Position + (Vector3New(-BasePart.Size.X, BasePart.Size.Y, BasePart.Size.Z) / 2),
            BasePart.Position + (Vector3New(BasePart.Size.X, -BasePart.Size.Y, BasePart.Size.Z) / 2),
            BasePart.Position + (Vector3New(BasePart.Size.X, BasePart.Size.Y, -BasePart.Size.Z) / 2),
            BasePart.Position + (Vector3New(-BasePart.Size.X, -BasePart.Size.Y, BasePart.Size.Z) / 2),
            BasePart.Position + (Vector3New(BasePart.Size.X, -BasePart.Size.Y, -BasePart.Size.Z) / 2),
            BasePart.Position + (Vector3New(-BasePart.Size.X, BasePart.Size.Y, -BasePart.Size.Z) / 2),
            BasePart.Position + (BasePart.Size / 2),
            BasePart.Position - (BasePart.Size / 2),
            BasePart.Position,
        }
    end

    Library.Scan = function(self, Origin, Position, Accuracy, Ignore)
        local Hit, RayPosition = Workspace:FindPartOnRayWithIgnoreList(
            Ray.new(
                Origin, 
                (Position - Origin).Unit * (Position - Origin).Magnitude
            ), 
            Ignore or {}, 
            false, 
            true
        )

        return (RayPosition - Position).Magnitude <= (Accuracy or 1), Hit, Position 
    end

    Library.CompareDistance = function(self, Basepart1, Basepart2)
        return (Basepart1.Position - Basepart2.Position).Magnitude 
    end
end 

return Library 