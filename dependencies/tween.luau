local Library = {}; do
    Library.__index = Library 

    local TweenService = cloneref and cloneref(game:GetService("TweenService")) or game:GetService("TweenService")

    Library.Create = function(self, Object : Instance, Properties : {[any] : any}, Info : TweenInfo)
        local Data = setmetatable({
            Object = Object,
            Properties = Properties,
            Info = Info or TweenInfo.new(1, Enum.EasingStyle.Linear, Enum.EasingDirection.Out)
        }, Library)

        Data.Tween = TweenService:Create(Object, Data.Info, Properties)
        Data:Play()

        return Data 
    end

    Library.Play = function(self)
        assert(self.Tween, "Call this on a created tween")

        self.Tween:Play()

        return self
    end

    Library.Pause = function(self)
        assert(self.Tween, "Call this on a created tween")

        self.Tween:Pause()

        return self 
    end

    Library.Clean = function(self)
        assert(self.Tween, "Call this on a created tween")

        self.Tween:Pause()
        self.Tween = nil 
    end 
end

return Library