---@class ModlandFileStartScreen : StateClass
---@field menu FileSelectMenu
---@field data SaveData
---@overload fun(menu: FileSelectMenu): ModlandFileStartScreen
local ModlandFileStartScreen, super = Class(StateClass)

function ModlandFileStartScreen:init(menu)
    self.menu = menu
end

function ModlandFileStartScreen:registerEvents()
    self:registerEvent("enter", self.onEnter)
    self:registerEvent("leave", self.onLeave)
    self:registerEvent("pause", self.onPause)
    self:registerEvent("resume", self.onResume)
    self:registerEvent("keypressed", self.onKeyPressed)
    self:registerEvent("update", self.update)
    self:registerEvent("draw", self.draw)
end

function ModlandFileStartScreen:onKeyPressed(key)
    if (Input.isCancel(key) or (Input.isConfirm(key) and self.selected_y == 2)) and #self.menu.state_manager.state_stack > 0 then
        if Input.isConfirm(key) then
            Assets.playSound("ui_select")
        else
            Assets.playSound("ui_cancel_small")
        end
        self.menu:popState()
    elseif Input.isConfirm(key) and self.selected_y == 1 then
        Assets.playSound("ui_select")
        if self.data then
            self:enterGame()
        else
            self.menu:pushState("FILENAME")
        end
    elseif Input.is("up", key) and self.selected_y == 2 then
        self.selected_y = 1
        Assets.playSound("ui_move")
    elseif Input.is("down", key) and self.selected_y == 1 then
        self.selected_y = 2
        Assets.playSound("ui_move")
    end
end

function ModlandFileStartScreen:draw()
    Draw.setColor(COLORS.ltgray)
    love.graphics.print("--- Instruction ---", 176, 40)
    love.graphics.push()
    love.graphics.translate(170, 100)
    for index, value in ipairs({
            "[Z or ENTER] - Confirm",
            "[X or SHIFT] - Cancel",
            "[C or CTRL] - Menu (In-game)",
            "[F4] - Fullscreen",
            "[Hold ESC] - Quit",
            "When HP is 0, you lose."
        }) do
        love.graphics.print(value, 0, 0)
        love.graphics.translate(0,36)
    end
    love.graphics.pop()
    Draw.setColor(self.selected_y == 1 and COLORS.yellow or COLORS.white)
    love.graphics.print("Begin Game", 170, 344)
    Draw.setColor(self.selected_y == 2 and COLORS.yellow or COLORS.white)
    love.graphics.print("Return", 170, 384)
end

function ModlandFileStartScreen:onResume()
    self.menu.heart.visible = false
end

function ModlandFileStartScreen:onPause()
    self.menu.heart.visible = true
end

---@param data SaveData
---@param slot integer
function ModlandFileStartScreen:onEnter(_, data, slot)
    self.data = data
    self.slot = slot
    self.selected_y = 1
    self:onResume()
    local music = self:getMusic()
    self.resume_music = Game.world.music:isPlaying()
    self.music = Music()
    if music and music ~= Game.world.music.current then
        Game.world.music:pause()
        self.music:play(music)
    end
end

function ModlandFileStartScreen:enterGame()
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

function ModlandFileStartScreen:getMusic()
    if self.data and self.data.flags and (self.data.flags.menu_music ~= nil) then
        return self.data.flags.menu_music
    end
    return nil
end

function ModlandFileStartScreen:onLeave()
    self:onPause()
    self.music:remove()
    if self.resume_music then
        Game.world.music:resume()
    end
end

return ModlandFileStartScreen