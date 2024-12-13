function Mod:init()
    print("Loaded "..self.info.name.."!")
    -- Make it obvious when the mod reloads
    Assets.playSound("bell", .2, 1)
end

function Mod:afmGetStyle()
    -- Could check for a Completion Save here
    if Kristal.loadData("file_3") then
        return "normal"
    end
    if Kristal.loadData("file_2") then
        return "greatdoor"
    end
    return "DEVICE"
end
