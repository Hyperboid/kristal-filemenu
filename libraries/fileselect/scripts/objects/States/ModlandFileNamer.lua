---@class ModlandFileNamer : StateClass
---@field menu FileSelectMenu
local ModlandFileNamer, super = Class(StateClass)

function ModlandFileNamer:init(menu)
    self.menu = menu
end

function ModlandFileNamer:registerEvents()
    self:registerEvent("enter", self.onEnter)
    self:registerEvent("leave", self.onLeave)
    self:registerEvent("keypressed", self.onKeyPressed)
    -- self:registerEvent("update", self.update)
    self:registerEvent("draw", self.draw)
end

function ModlandFileNamer:onEnter()
    self.container = Object()
    self.menu:addChild(self.container)
    self.container:addChild(MFileButton())
end

function ModlandFileNamer:onLeave()
    -- self.menu:removeChild(self.container)
    self.container:remove()
    self.container = nil
end

function ModlandFileNamer:onKeyPressed(key, is_repeat)
    if Input.isMenu(key) then
        Assets.stopAndPlaySound("bell", 1, 1)
    elseif Input.isCancel(key) then
        -- self.menu.state_manager:setState("FILESELECT")
        self.menu.state_manager:popState()
    end
end

function ModlandFileNamer:draw()
    love.graphics.rectangle("fill", 100,0,100,100)
end

return ModlandFileNamer