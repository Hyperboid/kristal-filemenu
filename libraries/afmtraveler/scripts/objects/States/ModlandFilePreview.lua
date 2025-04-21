---@class ModlandFilePreview : StateClass
---@field menu FileSelectMenu
---@field data SaveData
---@overload fun(menu: FileSelectMenu): ModlandFilePreview
local ModlandFilePreview, super = Class(StateClass)

function ModlandFilePreview:init(menu)
    self.menu = menu
end

function ModlandFilePreview:registerEvents()
    self:registerEvent("enter", self.onEnter)
    self:registerEvent("leave", self.onLeave)
    self:registerEvent("pause", self.onPause)
    self:registerEvent("resume", self.onResume)
    self:registerEvent("keypressed", self.onKeyPressed)
    self:registerEvent("update", self.update)
    self:registerEvent("draw", self.draw)
end

function ModlandFilePreview:onKeyPressed(key)
    if Input.isCancel(key) and #self.menu.state_manager.state_stack > 0 then
        self.menu:popState()
    elseif Input.isConfirm(key) then
        if self.data then
            self:enterGame()
        else
            self.menu:pushState("FILENAME")
        end
    end
end

function ModlandFilePreview:draw()
    Draw.setColor(COLORS.ltgray)
    love.graphics.push()
    love.graphics.translate(170, 100)
    for index, value in ipairs({
            "This menu hasn't been\nimplemented properly yet.",
            "\nFor now, Press Z to\nload, and X to go back",
        }) do
        love.graphics.print(value, 0, 0)
        love.graphics.translate(0,40)
    end
    love.graphics.pop()
end

function ModlandFilePreview:onResume()
    self.menu.heart.visible = false
end

function ModlandFilePreview:onPause()
    self.menu.heart.visible = true
end

---@param button FileButton
---@param slot integer
function ModlandFilePreview:onEnter(_, button, slot)
    self.data = button.data
    self.slot = slot
    self:onResume()
    local music = self:getMusic()
    self.resume_music = false
    self.music = Music()
    if music and music ~= Game.world.music.current then
        self.resume_music = Game.world.music:isPlaying()
        Game.world.music:pause()
        self.music:play(music)
    end
end

function ModlandFilePreview:enterGame()
    self.music:remove()
    if self.data then
        Game:load(self.data, self.slot, true)
    else
        Game.playtime = 0
        Game.save_id = self.menu.file_select.selected_y
        Game.save_name = Game.save_name
        Game.world:loadMap(Kristal.getLibConfig("afilemenu", "map"))
    end
    Kristal.callEvent("afmPostInit", not self.data)
end

function ModlandFilePreview:getMusic()
    if self.data and self.data.flags and (self.data.flags.menu_music ~= nil) then
        return self.data.flags.menu_music
    end
    return nil
end

function ModlandFilePreview:onLeave()
    self:onPause()
    self.music:remove()
    if self.resume_music then
        Game.world.music:resume()
    end
end

return ModlandFilePreview