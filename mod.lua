function Mod:init()
    print("Loaded "..self.info.name.."!")
    self.DT_MULT = 1
    Utils.hook(love.timer, "step", function (orig, ...)
        local dt = orig(...)
        return dt * math.max(0.05, self.DT_MULT)
    end)
end

function Mod:afmGetMusic()
    if not Mod.libs.afmtraveler then return end
    local data = Kristal.getSaveFile(1)
    if not data then
        return "ut_menu0"
    else
        -- For the true Knockoff Deltatraveler experience, put My Castle Town here.
        return "ut_menu0"
    end
end

function Mod:afmGetStyle()
    if Mod.libs.afmtraveler then return "normal" end
    -- Could check for a Completion Save here
    if Kristal.loadData("file_3") then
        return "normal"
    end
    if Kristal.loadData("file_2") then
        return "greatdoor"
    end
    return "DEVICE"
end
