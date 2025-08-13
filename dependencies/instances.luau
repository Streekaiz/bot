local Library = { }; do 
    Library.__index = Library

    Library.Create = function(self, ClassName : string, Properties : {[string] : any})
        local Data = setmetatable({
            Class = ClassName,
            Properties = Properties,
            Instance = Instance.new(ClassName)
        }, Library)

        for Index, Value in next, Properties do 
            Data:Set(Index, Value)
        end

        if self.Instance then 
            Data:Set("Parent", self.Instance)
        end

        return Data 
    end

    Library.Set = function(self, Index : string, Value : any)
        assert(self.Instance, "Call this function on a instance only")
        
        self.Instance[Index] = Value 

        return self 
    end

    Library.Get = function(self)
        assert(self.Instance, "Call this function on a instance only")
        
        return self.Instance
    end
end

return Library 