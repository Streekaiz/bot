local Library = { }; do 
    Library.__index = Library 

    local Lower = string.lower 
    local Upper = string.upper 
    local Format = string.format 

    Library.Case = function(self, Name, Casing)
        if Casing == "lowercase" then 
            return Lower(Name)
        elseif Casing == "uppercase" then
            return Upper(Name)
        else 
            return Name 
        end
    end

    Library.Surround = function(self, Name, Front, Behind)
        return Format("%s%s%s", Front, Name, Behind)
    end
end

return Library 