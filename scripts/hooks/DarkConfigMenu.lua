if not Kristal.getLibConfig("afilemenu", "configMenuOverride") then
    return DarkConfigMenu
end

local DarkConfigMenu, super = Class(DarkConfigMenu)

function DarkConfigMenu:addExitOptions()
    self:addOption(DarkConfigOption(self, "Return to Title", function()
        Game.fader:fadeOut(function ()
            Game:load(nil, nil, true)
        end, {})
        self.fadeout = true
        return
    end))

    self:addOption(DarkConfigOption(self, "Back", function()
        if Game.chapter ~= 1 then -- TODO
            Assets.stopAndPlaySound("ui_cancel_small")
        end
        Game.world.menu:closeBox()
    end))
end

function DarkConfigMenu:draw()
    if self.fadeout then
        super.super.draw(self)
        return
    end
    super.draw(self)
end

return DarkConfigMenu
