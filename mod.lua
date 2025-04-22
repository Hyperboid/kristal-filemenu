function Mod:init()
    print("Loaded "..self.info.name.."!")
    self.DT_MULT = 1
    Utils.hook(love.timer, "step", function (orig, ...)
        local dt = orig(...)
        return dt * math.max(0.05, self.DT_MULT)
    end)
end

function Mod:afmGetStyle()
    do return "greatdoor" end
    -- Could check for a Completion Save here
    if Kristal.loadData("file_3") then
        return "normal"
    end
    if Kristal.loadData("file_2") then
        return "greatdoor"
    end
    return "DEVICE"
end
