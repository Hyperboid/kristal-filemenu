function Mod:init()
    print("Loaded "..self.info.name.."!")
    MUSIC_PITCHES.mod_menu = 0.95
end

function Mod:getFileSelectStyle()
    if Kristal.hasAnySaves(Mod.info.id) then
        -- Could check for a Completion Save here
        if Kristal.loadData("file_3") then
            return "normal"
        end
        return "greatdoor"
    end
    return "DEVICE"
end
