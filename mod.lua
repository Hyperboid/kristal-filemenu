function Mod:init()
    print("Loaded "..self.info.name.."!")
end

function Mod:afmGetStyle()
    -- Could check for a Completion Save here
    if Kristal.loadData("file_3") then
        return "normal"
    end
    if Kristal.loadData("file_2") or true then
        return "greatdoor"
    end
    return "DEVICE"
end
