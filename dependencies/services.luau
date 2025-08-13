local Library = { }; do 
    Library.__index = Library 
    
    local CloneReference = cloneref or function(...)
        return ... 
    end

    Library.Get = function(self, Name : string)
        return CloneReference(game:GetService(Name))
    end
end

return Library 